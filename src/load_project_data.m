function data = load_project_data()
% LOAD_PROJECT_DATA Centralized data loading and caching utility for CensusLens
%
% Returns a structured bundle of all demographic, PCA, SVD, clustering,
% and forecasting datasets required across CensusLens. Handles path resolution
% and falls back gracefully if any optional auxiliary file is missing.

    scriptDir = fileparts(mfilename("fullpath"));
    projectRoot = fileparts(scriptDir);

    data = struct();
    data.projectRoot = projectRoot;

    %% 1. Base Processed Census Data
    cFile = fullfile(projectRoot, "data", "processed", "census_processed.mat");
    if ~isfile(cFile)
        error("Base processed data not found at %s. Run src/preprocess_data.m first.", cFile);
    end
    c = load(cFile);
    data.Tclean = c.Tclean;
    data.X = c.X;
    data.featureNames = c.featureNames;
    data.districtNames = string(c.regionNames);
    data.numDistricts = height(data.Tclean);

    % Add geographic metadata
    [data.districtKeys, data.stateNames, data.stateCodes] = get_geographic_metadata(data.Tclean);

    %% 2. Demographic Features
    dFile = fullfile(projectRoot, "data", "processed", "demographic_features.mat");
    if isfile(dFile)
        d = load(dFile);
        data.X_demo = d.X_demo;
        data.demoFeatureNames = d.demoFeatureNames;
    else
        % Compute inline if file missing
        totP = double(data.Tclean.TOT_P);
        totW = double(data.Tclean.TOT_WORK_P);
        childS = double(data.Tclean.P_06) ./ max(totP, 1);
        litP = double(data.Tclean.P_LIT) ./ max(totP, 1);
        scS = double(data.Tclean.P_SC) ./ max(totP, 1);
        stS = double(data.Tclean.P_ST) ./ max(totP, 1);
        workR = totW ./ max(totP, 1);
        mainWR = double(data.Tclean.MAINWORK_P) ./ max(totW, 1);
        data.X_demo = [childS, litP, scS, stS, workR, mainWR];
        data.demoFeatureNames = {'ChildShare', 'LiteracyProportion', 'SCShare', 'STShare', 'WorkerRatio', 'MainWorkerRatio'};
    end

    %% 3. Standardized Data
    sFile = fullfile(projectRoot, "data", "processed", "census_standardized.mat");
    if isfile(sFile)
        s = load(sFile);
        data.Z = s.Z;
    else
        data.Z = standardize_data(data.X);
    end

    dsFile = fullfile(projectRoot, "data", "processed", "demographic_standardized.mat");
    if isfile(dsFile)
        ds = load(dsFile);
        data.Z_demo = ds.Z_demo;
    else
        data.Z_demo = standardize_data(data.X_demo);
    end

    %% 4. PCA Results
    pcaFile = fullfile(projectRoot, "results", "pca", "pca_results.mat");
    if isfile(pcaFile)
        data.pca = load(pcaFile);
    else
        % Compute covariance PCA inline if missing
        m = size(data.Z, 1);
        C = (data.Z' * data.Z) / (m - 1);
        [V, D] = eig(C);
        eigVals = diag(D);
        [eigVals, idx] = sort(eigVals, 'descend');
        V = V(:, idx);
        expVar = (eigVals / sum(eigVals)) * 100;
        cumVar = cumsum(expVar);
        k95 = find(cumVar >= 95, 1, 'first');
        Y = data.Z * V;
        data.pca = struct('C', C, 'V', V, 'eigenvalues', eigVals, ...
            'explainedVariance', expVar, 'cumulativeVariance', cumVar, 'k95', k95, 'Y', Y);
    end

    % Demographic PCA Results
    pcaDemoFile = fullfile(projectRoot, "results", "pca", "demographic_pca.mat");
    if isfile(pcaDemoFile)
        data.pca_demo = load(pcaDemoFile);
    else
        m_d = size(data.Z_demo, 1);
        C_d = (data.Z_demo' * data.Z_demo) / (m_d - 1);
        [V_d, D_d] = eig(C_d);
        eigVals_d = diag(D_d);
        [eigVals_d, idx_d] = sort(eigVals_d, 'descend');
        V_d = V_d(:, idx_d);
        expVar_d = (eigVals_d / sum(eigVals_d)) * 100;
        cumVar_d = cumsum(expVar_d);
        k95_d = find(cumVar_d >= 95, 1, 'first');
        Y_d = data.Z_demo * V_d;
        data.pca_demo = struct('C_demo', C_d, 'V_demo', V_d, 'eigenvalues_demo', eigVals_d, ...
            'explainedVariance_demo', expVar_d, 'cumulativeVariance_demo', cumVar_d, ...
            'k95_demo', k95_d, 'Y_demo', Y_d, 'demoFeatureNames', {data.demoFeatureNames});
    end

    %% 5. SVD Results
    svdFile = fullfile(projectRoot, "results", "svd", "svd_results.mat");
    if isfile(svdFile)
        data.svd = load(svdFile);
    else
        [U, S, V_svd] = svd(data.Z, "econ");
        sVals = diag(S);
        m_s = size(data.Z, 1);
        sEig = (sVals.^2) / (m_s - 1);
        expVarSVD = (sEig / sum(sEig)) * 100;
        cumVarSVD = cumsum(expVarSVD);
        recErr = norm(data.Z - U * S * V_svd', "fro") / norm(data.Z, "fro");
        data.svd = struct('U', U, 'S', S, 'V_svd', V_svd, 'singularValues', sVals, ...
            'svdEigenvalues', sEig, 'explainedVarianceSVD', expVarSVD, ...
            'cumulativeVarianceSVD', cumVarSVD, 'reconstructionError', recErr);
    end

    % Precompute Low-Rank Reconstruction Errors for all k = 1:numFeatures
    numF = size(data.Z, 2);
    sVals = data.svd.singularValues;
    totalSsq = sum(sVals.^2);
    lowRankErrors = zeros(numF, 1);
    for k = 1:numF
        lowRankErrors(k) = sqrt(sum(sVals((k+1):end).^2) / totalSsq);
    end
    data.svd.lowRankErrors = lowRankErrors;

    %% 6. Adaptive PCA Results
    adFile = fullfile(projectRoot, "results", "adaptive", "adaptive_pca_results.mat");
    if isfile(adFile)
        data.adaptive = load(adFile);
    else
        data.adaptive = struct();
    end

    %% 7. Clustering Results
    clFile = fullfile(projectRoot, "results", "clustering", "cluster_results.mat");
    cpFile = fullfile(projectRoot, "results", "clustering", "cluster_profiles.mat");
    if isfile(clFile)
        cl = load(clFile);
        data.clustering.labels = cl.cluster_labels;
        data.clustering.bestK = cl.bestK;
    else
        data.clustering.labels = ones(data.numDistricts, 1);
        data.clustering.bestK = 3;
    end

    if isfile(cpFile)
        cp = load(cpFile);
        data.clustering.profileTable = cp.profileTable;
        data.clustering.clusterProfiles = cp.clusterProfiles;
        data.clustering.clusterSizes = cp.clusterSizes;
    else
        % Profile inline if needed
        k = data.clustering.bestK;
        profiles = zeros(k, size(data.X_demo, 2));
        sizes = zeros(k, 1);
        for cIdx = 1:k
            mask = (data.clustering.labels == cIdx);
            sizes(cIdx) = sum(mask);
            profiles(cIdx, :) = mean(data.X_demo(mask, :), 1);
        end
        pTab = array2table(profiles, 'VariableNames', data.demoFeatureNames);
        pTab.Cluster = (1:k)';
        pTab.ObservationCount = sizes;
        pTab = movevars(pTab, ["Cluster", "ObservationCount"], "Before", 1);
        data.clustering.profileTable = pTab;
        data.clustering.clusterProfiles = profiles;
        data.clustering.clusterSizes = sizes;
    end

    %% 8. Forecasting Results
    fcFile = fullfile(projectRoot, "results", "forecasting", "forecast_results.mat");
    if isfile(fcFile)
        data.forecasting = load(fcFile);
    else
        data.forecasting = struct();
    end

    % Ensure forecastTable, projectionMatrix, and summaryData exist and are valid
    if ~isfield(data.forecasting, 'forecastTable') || isempty(data.forecasting.forecastTable) || ...
       ~isfield(data.forecasting, 'summaryData') || isempty(data.forecasting.summaryData)
        [fTab, pMat, sData] = calculate_forecast(data.Tclean.P_06, data.districtNames, 0.02, 5);
        data.forecasting.forecastTable = fTab;
        data.forecasting.projectionMatrix = pMat;
        data.forecasting.summaryData = sData;
        data.forecasting.growthRate = 0.02;
        data.forecasting.numYears = 5;
    end

    %% 9. Guaranteed Canonical Resource Demand Table
    % Directly construct from Tclean to guarantee column names and avoid schema mismatches
    totPop = double(data.Tclean.TOT_P);
    childPop = double(data.Tclean.P_06);
    childShare = (childPop ./ max(totPop, 1)) * 100;
    normChildPop = childPop / max(childPop);
    normChildShare = childShare / max(childShare);
    priorityScore = sqrt(normChildPop .* normChildShare) * 100;
    ecceUnits = ceil(childPop / 40);

    canonicalResourceTable = table( ...
        data.districtNames, data.stateNames, data.districtKeys, ...
        totPop, childPop, childShare, ecceUnits, priorityScore, ...
        'VariableNames', {'District', 'State', 'DistrictKey', 'TotalPopulation', ...
        'ChildPopulation_0_6', 'ChildSharePercent', 'IllustrativeECCEUnitsProxy', 'DemographicPriorityScore'});

    % Sort by Child Population descending
    [~, sortChildIdx] = sort(childPop, 'descend');
    data.resourceTable = canonicalResourceTable(sortChildIdx, :);

    % Also save to results/forecasting/resource_demand.mat so external files remain updated
    rdFolder = fullfile(projectRoot, "results", "forecasting");
    if ~isfolder(rdFolder), mkdir(rdFolder); end
    resourceTable = data.resourceTable; %#ok<NASGU>
    save(fullfile(rdFolder, "resource_demand.mat"), "resourceTable");

    %% 10. Key Performance Indicators (KPIs)
    kpi = struct();
    kpi.totalPopulation = sum(double(data.Tclean.TOT_P));
    kpi.totalChildren = sum(double(data.Tclean.P_06));
    kpi.nationalChildShare = (kpi.totalChildren / kpi.totalPopulation) * 100;
    kpi.totalLiterate = sum(double(data.Tclean.P_LIT));
    kpi.nationalLiteracyRate = (kpi.totalLiterate / kpi.totalPopulation) * 100;
    kpi.totalWorkers = sum(double(data.Tclean.TOT_WORK_P));
    kpi.nationalWorkerRate = (kpi.totalWorkers / kpi.totalPopulation) * 100;
    kpi.totalDistricts = data.numDistricts;

    % Top 10 observations by population
    [~, sortPopIdx] = sort(double(data.Tclean.TOT_P), 'descend');
    top10Idx = sortPopIdx(1:min(10, data.numDistricts));
    kpi.top10Table = table((1:10)', data.districtNames(top10Idx), data.stateNames(top10Idx), ...
        double(data.Tclean.TOT_P(top10Idx)), double(data.Tclean.P_06(top10Idx)), ...
        (double(data.Tclean.P_06(top10Idx)) ./ double(data.Tclean.TOT_P(top10Idx))) * 100, ...
        (double(data.Tclean.P_LIT(top10Idx)) ./ double(data.Tclean.TOT_P(top10Idx))) * 100, ...
        'VariableNames', {'Rank', 'District', 'State', 'TotalPopulation', 'ChildPopulation_0_6', 'ChildSharePercent', 'LiteracyPercent'});

    data.kpi = kpi;

end
