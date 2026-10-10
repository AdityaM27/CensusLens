clc;
clear;
close all;

% Load demographic features
load(fullfile("data", "processed", "demographic_features.mat"));

% Calculate mean and standard deviation
mu_demo = mean(X_demo, 1);
sigma_demo = std(X_demo, 0, 1);

% Check for invalid or constant features
if any(~isfinite(sigma_demo)) || any(sigma_demo == 0)
    error("Invalid or constant demographic feature detected.");
end

% Standardize the features
Z_demo = (X_demo - mu_demo) ./ sigma_demo;

% Display dimensions
disp("Demographic standardization completed.");
disp("Standardized dataset dimensions:");
disp(size(Z_demo));

% Verify the result
disp("Feature means (should be approximately zero):");
disp(mean(Z_demo, 1));

disp("Feature standard deviations (should be approximately one):");
disp(std(Z_demo, 0, 1));

% Save results
save(fullfile("data", "processed", "demographic_standardized.mat"), ...
    "X_demo", "Z_demo", "mu_demo", "sigma_demo", ...
    "demoFeatureNames", "T_demo", "regionNames_demo");

disp("Saved demographic_standardized.mat successfully.");