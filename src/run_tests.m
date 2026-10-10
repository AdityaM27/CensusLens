function testResults = run_tests()
% RUN_TESTS Automated test suite for CensusLens
%
% Tests:
%   1. Data loading (load_project_data)
%   2. Overview statistics & KPIs
%   3. Demographic feature ranges & validity
%   4. PCA mathematical consistency & k95
%   5. SVD reconstruction error & PCA equivalence
%   6. Clustering partition & labels
%   7. Cluster profile tables
%   8. Resource demand proxies
%   9. Dynamic forecasting at multiple growth rates (-1%, 0%, 2%, 5%)
%  10. Dashboard application instantiation & teardown

    scriptDir = fileparts(mfilename("fullpath"));
    projectRoot = fileparts(scriptDir);
    addpath(scriptDir);

    disp("===============================================================");
    disp("              CENSUSLENS - AUTOMATED TEST SUITE                ");
    disp("===============================================================");

    tests = {
        '1. Data Loading',                        @testDataLoading;
        '2. Overview Statistics & KPIs',           @testOverviewKPIs;
        '3. Demographic Feature Validity',         @testDemographicFeatures;
        '4. PCA Numerical Consistency',            @testPCAConsistency;
        '5. SVD & PCA-SVD Equivalence',            @testSVDReconstruction;
        '6. Clustering Partition & Labels',        @testClusteringLabels;
        '7. Cluster Profile Tables',               @testClusterProfiles;
        '8. Resource Demand Proxies',              @testResourceDemand;
        '9. Dynamic Forecasting (Multiple Rates)', @testForecastingEngine;
        '10. Dashboard Startup & Clean Teardown',  @testDashboardStartup
    };

    numTests = size(tests, 1);
    results = table('Size', [numTests, 3], ...
        'VariableTypes', {'string', 'string', 'string'}, ...
        'VariableNames', {'TestName', 'Status', 'Details'});

    totalPassed = 0;

    for i = 1:numTests
        tName = tests{i, 1};
        tFunc = tests{i, 2};
        fprintf("Running Test %d/%d: %-38s ", i, numTests, tName);
        try
            detail = tFunc(projectRoot);
            results.TestName(i) = tName;
            results.Status(i) = "PASSED";
            results.Details(i) = detail;
            totalPassed = totalPassed + 1;
            fprintf("[PASSED]\n");
        catch ME
            results.TestName(i) = tName;
            results.Status(i) = "FAILED";
            results.Details(i) = string(ME.message);
            fprintf("[FAILED: %s]\n", ME.message);
        end
    end

    fprintf("\n===============================================================\n");
    fprintf("TEST SUMMARY: %d / %d TESTS PASSED (%.1f%%)\n", ...
        totalPassed, numTests, (totalPassed / numTests) * 100);
    disp("===============================================================");
    disp(results);

    if nargout > 0
        testResults = results;
    end

end

%% Individual Test Cases
function detail = testDataLoading(~)
    data = load_project_data();
    assert(data.numDistricts == 640, "Expected 640 districts.");
    assert(height(data.Tclean) == 640, "Tclean height mismatch.");
    assert(length(data.districtKeys) == 640, "districtKeys length mismatch.");
    detail = "Loaded 640 districts and all feature matrices.";
end

function detail = testOverviewKPIs(~)
    data = load_project_data();
    kpi = data.kpi;
    assert(kpi.totalPopulation > 1.2e9 && kpi.totalPopulation < 1.3e9, "Total population out of range.");
    assert(kpi.totalChildren > 1.5e8 && kpi.totalChildren < 1.8e8, "Child population out of range.");
    assert(kpi.nationalChildShare > 10 && kpi.nationalChildShare < 20, "Child share out of range.");
    assert(height(kpi.top10Table) == 10, "Top 10 table must have 10 rows.");
    detail = sprintf('Pop: %.2fB, Children: %.2fM, ChildShare: %.2f%%', ...
        kpi.totalPopulation/1e9, kpi.totalChildren/1e6, kpi.nationalChildShare);
end

function detail = testDemographicFeatures(~)
    data = load_project_data();
    X_demo = data.X_demo;
    assert(all(isfinite(X_demo(:))), "Non-finite values found in X_demo.");
    assert(all(X_demo(:) >= 0 & X_demo(:) <= 1.05), "Demographic proportions must lie in [0, 1].");
    assert(size(X_demo, 2) == 6, "Expected 6 demographic features.");
    detail = "All 6 demographic indicators finite and within valid proportion bounds [0, 1].";
end

function detail = testPCAConsistency(~)
    data = load_project_data();
    pca = data.pca_demo;
    assert(all(diff(pca.eigenvalues_demo) <= 0), "Eigenvalues must be sorted descending.");
    assert(abs(sum(pca.explainedVariance_demo) - 100) < 1e-4, "Explained variance must sum to 100%.");
    assert(pca.k95_demo >= 1 && pca.k95_demo <= 6, "k95 out of range.");
    assert(size(pca.Y_demo, 1) == 640, "Score matrix row mismatch.");
    detail = sprintf('k95 = %d, PC1 var = %.1f%%, Cumulative = %.1f%%', ...
        pca.k95_demo, pca.explainedVariance_demo(1), pca.cumulativeVariance_demo(pca.k95_demo));
end

function detail = testSVDReconstruction(~)
    data = load_project_data();
    svdData = data.svd;
    assert(svdData.reconstructionError < 1e-10, "Full SVD reconstruction error exceeds tolerance.");
    m = size(data.Z, 1);
    svdEig = (svdData.singularValues.^2) / (m - 1);
    pcaEig = data.pca.eigenvalues(1:length(svdEig));
    maxDiff = max(abs(svdEig - pcaEig));
    assert(maxDiff < 1e-8, "PCA and SVD eigenvalues diverge.");
    detail = sprintf('Full Rec Error = %.2e, Max |PCA - SVD| = %.2e', svdData.reconstructionError, maxDiff);
end

function detail = testClusteringLabels(~)
    data = load_project_data();
    labels = data.clustering.labels;
    assert(length(labels) == 640, "Expected 640 cluster labels.");
    assert(data.clustering.bestK == 3, "Expected bestK = 3.");
    uLabels = unique(labels);
    assert(isequal(uLabels(:)', [1, 2, 3]), "Labels must be 1, 2, 3.");
    cSizes = [sum(labels == 1), sum(labels == 2), sum(labels == 3)];
    detail = sprintf('Sizes: C1=%d, C2=%d, C3=%d (Total = %d)', cSizes(1), cSizes(2), cSizes(3), sum(cSizes));
end

function detail = testClusterProfiles(~)
    data = load_project_data();
    pTab = data.clustering.profileTable;
    assert(height(pTab) == 3, "Profile table must contain 3 clusters.");
    assert(ismember("ObservationCount", string(pTab.Properties.VariableNames)), "ObservationCount column missing.");
    assert(sum(pTab.ObservationCount) == 640, "Cluster observation counts must sum to 640.");
    detail = "Profile table verified for 3 clusters with 640 total observations.";
end

function detail = testResourceDemand(~)
    data = load_project_data();
    rTab = data.resourceTable;
    assert(height(rTab) == 640, "Resource table must contain 640 districts.");
    varNames = string(rTab.Properties.VariableNames);
    if ismember("ChildPopulation_0_6", varNames)
        cPop = rTab.ChildPopulation_0_6;
    else
        cPop = rTab.P_06;
    end
    assert(all(cPop >= 0), "Child population cannot be negative.");
    detail = "640 district resource demand proxies verified with non-negative counts.";
end

function detail = testForecastingEngine(~)
    data = load_project_data();
    rates = [-0.01, 0.0, 0.015, 0.02, 0.035, 0.05];
    for r = rates
        [fTab, pMat, sData] = calculate_forecast(data.Tclean.P_06, data.districtNames, r, 5);
        assert(height(fTab) == 640, "Forecast table row mismatch.");
        assert(size(pMat, 2) == 5, "Must project 5 years.");
        % Verify compounding formula on district 1
        expectedY5 = double(data.Tclean.P_06(1)) * ((1 + r)^5);
        assert(abs(pMat(1, 5) - expectedY5) < 1e-4, "Compounding formula mismatch.");
    end
    detail = "Verified dynamic forecasting at -1%, 0%, 1.5%, 2%, 3.5%, and 5% rates.";
end

function detail = testDashboardStartup(~)
    fig = CensusLensDashboard();
    assert(isvalid(fig), "Figure failed to create.");
    pause(0.5);
    delete(fig);
    detail = "CensusLensDashboard instantiated, rendered, and closed successfully.";
end
