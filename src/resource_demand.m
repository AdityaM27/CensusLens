%% CENSUSLENS - RESOURCE DEMAND PROXY ESTIMATION
% Calculates demographic proxies for early-childhood resource planning.

clc;
clear;
close all;

% Locate project root
scriptDir = fileparts(mfilename("fullpath"));
projectRoot = fileparts(scriptDir);

% Load processed data
dataFile = fullfile(projectRoot, "data", "processed", "census_processed.mat");
if ~isfile(dataFile)
    error("Processed census data not found: %s", dataFile);
end
load(dataFile, "Tclean", "regionNames");

% Geographic metadata
[districtKeys, stateNames, stateCodes] = get_geographic_metadata(Tclean);

% Baseline metrics
totPop = double(Tclean.TOT_P);
childPop = double(Tclean.P_06);
childShare = childPop ./ max(totPop, 1);

% Demographic proxy estimates (illustrative planning norms):
% 1. ECCE / Anganwadi target units proxy (assuming planning norm of ~40 children / unit)
normChildrenPerUnit = 40;
ecceProxyUnits = ceil(childPop ./ normChildrenPerUnit);

% 2. Demographic Priority Score (geometric mean of standardized child volume and child share)
normChildPop = childPop / max(childPop);
normChildShare = childShare / max(childShare);
priorityScore = sqrt(normChildPop .* normChildShare) * 100;

% Construct Resource Planning Table
resourceTable = table( ...
    regionNames, ...
    stateNames, ...
    districtKeys, ...
    totPop, ...
    childPop, ...
    childShare * 100, ...
    ecceProxyUnits, ...
    priorityScore, ...
    'VariableNames', { ...
        'District', ...
        'State', ...
        'DistrictKey', ...
        'TotalPopulation', ...
        'ChildPopulation_0_6', ...
        'ChildSharePercent', ...
        'IllustrativeECCEUnitsProxy', ...
        'DemographicPriorityScore' ...
    });

% Sort by Child Population
[~, sortIdx] = sort(childPop, 'descend');
resourceTable = resourceTable(sortIdx, :);

% Display top 10
disp("==================================================");
disp("    CENSUSLENS - RESOURCE DEMAND PROXY ANALYSIS   ");
disp("==================================================");
disp("Top 10 Districts by Child Population (0-6):");
disp(resourceTable(1:10, {'District', 'State', 'TotalPopulation', 'ChildPopulation_0_6', 'ChildSharePercent'}));

% Save results
outDir = fullfile(projectRoot, "results", "forecasting");
if ~isfolder(outDir)
    mkdir(outDir);
end

matFile = fullfile(outDir, "resource_demand.mat");
save(matFile, "resourceTable", "normChildrenPerUnit", "districtKeys", "stateNames");
disp("Saved resource_demand.mat successfully.");
