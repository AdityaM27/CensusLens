clc;
clear;
close all;

% Load standardized census data
load(fullfile("data", "processed", "census_standardized.mat"));

% Step 1: Perform Singular Value Decomposition
[U, S, V_svd] = svd(Z, "econ");

% Step 2: Extract singular values
singularValues = diag(S);

% Step 3: Calculate variance represented by each singular value
m = size(Z, 1);

svdEigenvalues = (singularValues.^2) / (m - 1);

explainedVarianceSVD = ...
    (svdEigenvalues / sum(svdEigenvalues)) * 100;

cumulativeVarianceSVD = cumsum(explainedVarianceSVD);

% Step 4: Reconstruct the original standardized matrix
Z_reconstructed = U * S * V_svd';

% Step 5: Calculate reconstruction error
reconstructionError = ...
    norm(Z - Z_reconstructed, "fro") / norm(Z, "fro");

% Display results
disp("Singular values:");
disp(singularValues);

disp("Eigenvalues calculated from SVD:");
disp(svdEigenvalues);

disp("Explained variance from SVD (%):");
disp(explainedVarianceSVD);

disp("Full reconstruction relative error:");
disp(reconstructionError);

disp("Dimensions of U:");
disp(size(U));

disp("Dimensions of S:");
disp(size(S));

disp("Dimensions of V:");
disp(size(V_svd));

% Step 6: Save SVD results
outputFolder = fullfile("results", "svd");

if ~isfolder(outputFolder)
    mkdir(outputFolder);
end

save(fullfile(outputFolder, "svd_results.mat"), ...
    "U", "S", "V_svd", "singularValues", ...
    "svdEigenvalues", "explainedVarianceSVD", ...
    "cumulativeVarianceSVD", "reconstructionError");

disp("SVD results saved successfully.");
