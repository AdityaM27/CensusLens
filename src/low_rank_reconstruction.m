clc;
clear;
close all;

% Load standardized census data
load(fullfile("data", "processed", "census_standardized.mat"));

% Perform SVD
[U, S, V] = svd(Z, "econ");

% Number of observations and features
[m, n] = size(Z);

% Values of k to test
kValues = [1, 2, 3, 5, 8];

% Store reconstruction errors
reconstructionErrors = zeros(length(kValues), 1);

% Store explained variance
singularValues = diag(S);
allEigenvalues = (singularValues.^2) / (m - 1);

explainedVariance = ...
    (allEigenvalues / sum(allEigenvalues)) * 100;

cumulativeVariance = cumsum(explainedVariance);

% Reconstruct data for different values of k
for i = 1:length(kValues)

    k = kValues(i);

    % Keep only the first k components
    Uk = U(:, 1:k);
    Sk = S(1:k, 1:k);
    Vk = V(:, 1:k);

    % Low-rank reconstruction
    Zk = Uk * Sk * Vk';

    % Relative Frobenius reconstruction error
    reconstructionErrors(i) = ...
        norm(Z - Zk, "fro") / norm(Z, "fro");

end
% Display results
componentsColumn = kValues(:);
errorColumn = reconstructionErrors(:);
varianceColumn = cumulativeVariance(kValues(:));

resultsTable = table( ...
    componentsColumn, ...
    errorColumn, ...
    varianceColumn, ...
    'VariableNames', ...
    {'Components', 'RelativeError', 'CumulativeVariancePercent'});

disp("Low-rank reconstruction results:");
disp(resultsTable);



% Plot reconstruction error
figure;
plot(kValues, reconstructionErrors, "-o");
xlabel("Number of Components (k)");
ylabel("Relative Frobenius Reconstruction Error");
title("Low-Rank Reconstruction Error");
grid on;

% Save results
outputFolder = fullfile("results", "svd");

if ~isfolder(outputFolder)
    mkdir(outputFolder);
end

save(fullfile(outputFolder, "low_rank_results.mat"), ...
    "kValues", "reconstructionErrors", ...
    "cumulativeVariance", "resultsTable");

disp("Low-rank reconstruction results saved successfully.");

