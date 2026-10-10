%% CENSUSLENS - SCENARIO FORECASTING
% Generates baseline and 5-year child population scenarios (2.0% baseline).

clc;
clear;
close all;

% Locate project root
scriptDir = fileparts(mfilename("fullpath"));
projectRoot = fileparts(scriptDir);

% Load processed census data
dataFile = fullfile(projectRoot, "data", "processed", "census_processed.mat");
if ~isfile(dataFile)
    error("Processed data file not found: %s", dataFile);
end
load(dataFile, "Tclean", "regionNames");

% Extract baseline child population (0-6)
baselineChildren = Tclean.P_06;
growthRate = 0.02; % 2.0% annual illustrative growth assumption
numYears = 5;

% Compute 5-year projections
[forecastTable, projectionMatrix, summaryData] = ...
    calculate_forecast(baselineChildren, regionNames, growthRate, numYears);

disp("==================================================");
disp("       CENSUSLENS - SCENARIO FORECASTING          ");
disp("==================================================");
disp("Assumption: " + string(summaryData.GrowthRatePercent) + "% uniform annual compound growth");
disp("National Baseline (0-6):  " + sprintf('%.0f', summaryData.NationalBaseline));
disp("National Year 5 (0-6):     " + sprintf('%.0f', summaryData.NationalProjected(end)));
disp("Net Projected Addition:    " + sprintf('%.0f', summaryData.TotalNetAddition));
disp(" ");
disp("First 10 District Projections:");
disp(forecastTable(1:min(10, height(forecastTable)), :));

% Save results
outDir = fullfile(projectRoot, "results", "forecasting");
if ~isfolder(outDir)
    mkdir(outDir);
end

% Save CSV
csvFile = fullfile(outDir, "forecast_results.csv");
writetable(forecastTable, csvFile);
disp("Saved forecast_results.csv successfully.");

% Save MAT
matFile = fullfile(outDir, "forecast_results.mat");
save(matFile, "forecastTable", "projectionMatrix", "summaryData", ...
     "growthRate", "numYears", "baselineChildren", "regionNames");
disp("Saved forecast_results.mat successfully.");
