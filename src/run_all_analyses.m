%% CENSUSLENS - END-TO-END ANALYTICAL PIPELINE
% Sequentially executes all mathematical models and reproduces all results.

clc;
clear;
close all;

scriptDir = fileparts(mfilename("fullpath"));
projectRoot = fileparts(scriptDir);
cd(projectRoot);
addpath(scriptDir);

disp("===============================================================");
disp("             CENSUSLENS - FULL PIPELINE EXECUTION              ");
disp("===============================================================");

steps = {
    "1. Data Preprocessing",           "preprocess_data.m";
    "2. Demographic Engineering",       "feature_engineering.m";
    "3. Feature Standardization",       "run_standardization.m";
    "4. Covariance PCA (Census)",       "manual_pca.m";
    "5. Economy SVD Validation",        "manual_svd.m";
    "6. Demographic PCA",              "demographic_pca.m";
    "7. Adaptive Batch-Wise PCA",       "adaptive_pca.m";
    "8. District Clustering & Profiling","run_clustering.m";
    "9. Resource Demand Estimation",    "resource_demand.m";
    "10. Scenario Forecasting",         "run_forecasting.m";
    "11. Data Validation Suite",        "validate_data.m"
};

for i = 1:size(steps, 1)
    stepName = steps{i, 1};
    stepScript = steps{i, 2};
    scriptPath = fullfile(scriptDir, stepScript);
    
    fprintf("\n>>> Running Step %d/%d: %s (%s)...\n", i, size(steps, 1), stepName, stepScript);
    try
        run(scriptPath);
        fprintf("    [SUCCESS] %s completed.\n", stepName);
    catch ME
        fprintf("    [ERROR] %s failed: %s\n", stepName, ME.message);
        rethrow(ME);
    end
end

disp("===============================================================");
disp("ALL ANALYTICAL PIPELINE STEPS EXECUTED AND VALIDATED.");
disp("===============================================================");
