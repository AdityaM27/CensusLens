clc;
clear;
close all;

% Load standardized demographic data
load(fullfile("data", "processed", "demographic_standardized.mat"));

% Number of observations and features
[m, n] = size(Z_demo);

% Calculate covariance matrix
C_demo = (Z_demo' * Z_demo) / (m - 1);

% Calculate eigenvalues and eigenvectors
[V_demo, D_demo] = eig(C_demo);

% Extract eigenvalues
eigenvalues_demo = diag(D_demo);

% Sort eigenvalues in descending order
[eigenvalues_demo, idx] = sort(eigenvalues_demo, "descend");
V_demo = V_demo(:, idx);

% Calculate explained variance
explainedVariance_demo = ...
(eigenvalues_demo / sum(eigenvalues_demo)) * 100;

% Calculate cumulative explained variance
cumulativeVariance_demo = cumsum(explainedVariance_demo);

% Select components needed to retain at least 95% variance
k95_demo = find(cumulativeVariance_demo >= 95, 1, "first");

% Calculate PCA scores
Y_demo = Z_demo * V_demo;

% Keep only the selected components
Y_demo_reduced = Y_demo(:, 1:k95_demo);

% Display results
disp("Demographic PCA completed.");

disp("Eigenvalues:");
disp(eigenvalues_demo');

disp("Explained variance (%):");
disp(explainedVariance_demo');

disp("Cumulative explained variance (%):");
disp(cumulativeVariance_demo');

disp("Components required for 95% variance:");
disp(k95_demo);

disp("Reduced dataset dimensions:");
disp(size(Y_demo_reduced));

% Plot cumulative explained variance
figure;
plot(1:n, cumulativeVariance_demo, "-o", "LineWidth", 2);
hold on;
yline(95, "--r", "95% Threshold");
xlabel("Number of Principal Components");
ylabel("Cumulative Explained Variance (%)");
title("Demographic PCA: Explained Variance");
grid on;
xticks(1:n);
hold off;

% Create output directory if necessary
if ~exist(fullfile("results", "pca"), "dir")
mkdir(fullfile("results", "pca"));
end

% Save PCA results
save(fullfile("results", "pca", "demographic_pca.mat"), ...
"C_demo", "V_demo", "eigenvalues_demo", ...
"explainedVariance_demo", "cumulativeVariance_demo", ...
"k95_demo", "Y_demo", "Y_demo_reduced", ...
"demoFeatureNames", "regionNames_demo");

disp("Saved demographic_pca.mat successfully.");
