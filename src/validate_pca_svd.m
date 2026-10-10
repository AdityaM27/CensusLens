
clc;
clear;
close all;

% Load PCA results
load(fullfile("results", "pca", "pca_results.mat"));

% Store PCA eigenvalues
pcaEigenvalues = eigenvalues;

% Load SVD results
load(fullfile("results", "svd", "svd_results.mat"));

% Compare eigenvalues
eigenvalueDifference = abs(pcaEigenvalues - svdEigenvalues);

% Calculate maximum absolute difference
maxEigenvalueDifference = max(eigenvalueDifference);

% Compare explained variance
load(fullfile("results", "pca", "pca_results.mat"), ...
    "explainedVariance");

explainedVarianceDifference = ...
    abs(explainedVariance - explainedVarianceSVD);

maxVarianceDifference = max(explainedVarianceDifference);

% Display results
disp("PCA eigenvalues:");
disp(pcaEigenvalues);

disp("SVD-derived eigenvalues:");
disp(svdEigenvalues);

disp("Absolute eigenvalue differences:");
disp(eigenvalueDifference);

disp("Maximum eigenvalue difference:");
disp(maxEigenvalueDifference);

disp("Maximum explained variance difference (%):");
disp(maxVarianceDifference);

% Validation check
tolerance = 1e-8;

if maxEigenvalueDifference < tolerance && ...
        maxVarianceDifference < tolerance
    disp("VALIDATION PASSED: PCA and SVD results agree.");
else
    disp("VALIDATION FAILED: Check the calculations.");
end

% Save validation results
outputFolder = fullfile("results", "pca");

if ~isfolder(outputFolder)
    mkdir(outputFolder);
end

save(fullfile(outputFolder, "pca_svd_validation.mat"), ...
    "pcaEigenvalues", "svdEigenvalues", ...
    "eigenvalueDifference", "maxEigenvalueDifference", ...
    "explainedVarianceDifference", "maxVarianceDifference", ...
    "tolerance");

disp("PCA-SVD validation results saved successfully.");
