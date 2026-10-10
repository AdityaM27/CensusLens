%% CENSUSLENS - STANDARDIZATION PIPELINE
% Standardizes Census features and Demographic indicators using standardize_data.

clc;
clear;
close all;

% Locate project root
scriptDir = fileparts(mfilename("fullpath"));
projectRoot = fileparts(scriptDir);

% 1. Standardize Census Features
censusProcFile = fullfile(projectRoot, "data", "processed", "census_processed.mat");
if ~isfile(censusProcFile)
    error("Processed census file not found: %s", censusProcFile);
end
load(censusProcFile, "X", "Tclean", "regionNames", "featureNames");

[Z, mu, sigma] = standardize_data(X);

censusStdFile = fullfile(projectRoot, "data", "processed", "census_standardized.mat");
save(censusStdFile, "Z", "mu", "sigma", "featureNames", "regionNames", "Tclean");
disp("Saved census_standardized.mat successfully.");
disp("Z matrix size: " + mat2str(size(Z)));

% 2. Standardize Demographic Indicators
demoProcFile = fullfile(projectRoot, "data", "processed", "demographic_features.mat");
if ~isfile(demoProcFile)
    error("Demographic features file not found: %s", demoProcFile);
end
load(demoProcFile, "X_demo", "T_demo", "regionNames_demo", "demoFeatureNames");

[Z_demo, mu_demo, sigma_demo] = standardize_data(X_demo);

demoStdFile = fullfile(projectRoot, "data", "processed", "demographic_standardized.mat");
save(demoStdFile, "Z_demo", "mu_demo", "sigma_demo", "demoFeatureNames", "regionNames_demo", "T_demo");
disp("Saved demographic_standardized.mat successfully.");
disp("Z_demo matrix size: " + mat2str(size(Z_demo)));
