clc;
clear;
close all;

% Load processed census data
load(fullfile("data", "processed", "census_standardized.mat"));

% Load PCA results
load(fullfile("results", "pca", "pca_results.mat"));

% Load SVD results
load(fullfile("results", "svd", "svd_results.mat"));

% Load low-rank reconstruction results
load(fullfile("results", "svd", "low_rank_results.mat"));

% Load adaptive PCA results
load(fullfile("results", "adaptive", "adaptive_pca_results.mat"));

% Select the first three principal components
k = 3;
Y_reduced = Y(:, 1:k);

% Calculate the three-component SVD reconstruction
Z_reduced = U(:, 1:k) * S(1:k, 1:k) * V_svd(:, 1:k)';

% Create output folder
outputFolder = fullfile("data", "processed");

if ~isfolder(outputFolder)
    mkdir(outputFolder);
end

% Export the main project dataset
save(fullfile(outputFolder, "censuslens_final.mat"), ...
    "X", "Z", "Tclean", "regionNames", "featureNames", ...
    "Y_reduced", "k95", "eigenvalues", ...
    "explainedVariance", "cumulativeVariance", ...
    "singularValues", "svdEigenvalues", ...
    "reconstructionErrors", "kValues", ...
    "adaptiveResults", "Z_reduced");

disp("CensusLens final dataset exported successfully.");
disp("Number of observations:");
disp(size(Z, 1));

disp("Original feature count:");
disp(size(Z, 2));

disp("Reduced feature count:");
disp(size(Y_reduced, 2));

disp("Export file:");
disp(fullfile(outputFolder, "censuslens_final.mat"));
