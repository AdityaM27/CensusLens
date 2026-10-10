clc;
clear;
close all;

% Load standardized census data and district information
load(fullfile("data", "processed", "census_standardized.mat"));

% Dataset dimensions
[m, n] = size(Z);

% Number of components to retain
k = 3;

% Process observations in batches
batchSize = 100;

% Batch endpoints
batchEnds = batchSize:batchSize:m;

if isempty(batchEnds) || batchEnds(end) ~= m
    batchEnds = [batchEnds, m];
end

% Store results
numBatches = length(batchEnds);
varianceRetained = zeros(numBatches, 1);
reconstructionError = zeros(numBatches, 1);
observationsProcessed = zeros(numBatches, 1);

% Process batches cumulatively
for b = 1:numBatches

    % Current observations
    currentEnd = batchEnds(b);
    Zcurrent = Z(1:currentEnd, :);

    % Refit PCA using the accumulated observations
    Ccurrent = (Zcurrent' * Zcurrent) / (size(Zcurrent, 1) - 1);

    [Vcurrent, Dcurrent] = eig(Ccurrent);

    eigenvaluesCurrent = diag(Dcurrent);

    [eigenvaluesCurrent, idx] = ...
        sort(eigenvaluesCurrent, "descend");

    Vcurrent = Vcurrent(:, idx);

    % Calculate retained variance
    varianceRetained(b) = ...
        100 * sum(eigenvaluesCurrent(1:k)) ...
        / sum(eigenvaluesCurrent);

    % Project and reconstruct using the first k components
    VcurrentK = Vcurrent(:, 1:k);

    Ycurrent = Zcurrent * VcurrentK;

    Zreconstructed = Ycurrent * VcurrentK';

    % Calculate relative reconstruction error
    reconstructionError(b) = ...
        norm(Zcurrent - Zreconstructed, "fro") ...
        / norm(Zcurrent, "fro");

    observationsProcessed(b) = currentEnd;

end

% Display results
adaptiveResults = table( ...
    observationsProcessed, ...
    varianceRetained, ...
    reconstructionError, ...
    'VariableNames', ...
    {'ObservationsProcessed', ...
     'VarianceRetainedPercent', ...
     'RelativeReconstructionError'});

disp("Batch-wise PCA results:");
disp(adaptiveResults);

% Plot retained variance
figure;
plot(observationsProcessed, varianceRetained, "-o");
xlabel("Cumulative Observations Processed");
ylabel("Variance Retained (%)");
title("Batch-Wise PCA: Variance Retained");
grid on;

% Plot reconstruction error
figure;
plot(observationsProcessed, reconstructionError, "-o");
xlabel("Cumulative Observations Processed");
ylabel("Relative Reconstruction Error");
title("Batch-Wise PCA: Reconstruction Error");
grid on;

% Save results
outputFolder = fullfile("results", "adaptive");

if ~isfolder(outputFolder)
    mkdir(outputFolder);
end

save(fullfile(outputFolder, "adaptive_pca_results.mat"), ...
    "adaptiveResults", "observationsProcessed", ...
    "varianceRetained", "reconstructionError", ...
    "batchSize", "k");

disp("Adaptive PCA experiment results saved successfully.");
