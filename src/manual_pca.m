clc;
clear;
close all;

% Load standardized census data
load(fullfile("data", "processed", "census_standardized.mat"));

% Step 1: Calculate the covariance matrix
C = (Z' * Z) / (size(Z, 1) - 1);

disp("Covariance matrix:");
disp(C);

% Step 2: Calculate eigenvalues and eigenvectors
[V, D] = eig(C);

eigenvalues = diag(D);

% Step 3: Sort eigenvalues in descending order
[eigenvalues, idx] = sort(eigenvalues, "descend");
V = V(:, idx);

% Step 4: Calculate explained variance
explainedVariance = (eigenvalues / sum(eigenvalues)) * 100;

% Step 5: Calculate cumulative explained variance
cumulativeVariance = cumsum(explainedVariance);

% Step 6: Calculate principal component scores
Y = Z * V;

% Step 7: Find the number of components needed for 95% variance
k95 = find(cumulativeVariance >= 95, 1, "first");

% Display results
disp("Eigenvalues:");
disp(eigenvalues);

disp("Explained variance (%):");
disp(explainedVariance);

disp("Cumulative explained variance (%):");
disp(cumulativeVariance);

disp("Components required for 95% variance:");
disp(k95);

disp("Dimensions of PCA scores:");
disp(size(Y));

% Step 8: Plot cumulative explained variance
figure;
plot(1:length(cumulativeVariance), cumulativeVariance, "-o");
xlabel("Number of Principal Components");
ylabel("Cumulative Explained Variance (%)");
title("PCA - Cumulative Explained Variance");
grid on;

% Step 9: Save PCA results
outputFolder = fullfile("results", "pca");

if ~isfolder(outputFolder)
    mkdir(outputFolder);
end

save(fullfile(outputFolder, "pca_results.mat"), ...
    "C", "V", "eigenvalues", "explainedVariance", ...
    "cumulativeVariance", "Y", "k95");

disp("PCA results saved successfully.");