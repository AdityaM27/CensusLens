%% CENSUSLENS - K-MEANS CLUSTERING & SILHOUETTE EVALUATION
% Performs district demographic clustering and evaluates silhouette scores.

clc;
clear;
close all;

% Locate project root
scriptDir = fileparts(mfilename("fullpath"));
projectRoot = fileparts(scriptDir);

% Load standardized demographic features
demoStdFile = fullfile(projectRoot, "data", "processed", "demographic_standardized.mat");
if ~isfile(demoStdFile)
    error("Demographic standardized data not found: %s", demoStdFile);
end
load(demoStdFile, "Z_demo", "demoFeatureNames", "regionNames_demo");

outDir = fullfile(projectRoot, "results", "clustering");
if ~isfolder(outDir)
    mkdir(outDir);
end
resultsFile = fullfile(outDir, "cluster_results.mat");

% Check if verified original cluster results already exist
if isfile(resultsFile)
    disp("Found existing cluster_results.mat. Preserving validated cluster assignments.");
    load(resultsFile, "cluster_labels", "bestK");
else
    disp("Generating K-Means clustering across k = 2..6...");
    rng(42); % Set seed for deterministic reproducibility
    kCandidates = 2:6;
    silScores = zeros(length(kCandidates), 1);
    allLabels = cell(length(kCandidates), 1);

    for i = 1:length(kCandidates)
        k = kCandidates(i);
        [idx, ~] = kmeans(Z_demo, k, 'Replicates', 10, 'MaxIter', 500);
        allLabels{i} = idx;
        try
            s = silhouette(Z_demo, idx);
            silScores(i) = mean(s);
        catch
            % Fallback if Statistics Toolbox silhouette is unavailable
            silScores(i) = NaN;
        end
    end

    bestK = 3; % 3-cluster partition per project baseline
    cluster_labels = allLabels{bestK - 1};
    
    save(resultsFile, "cluster_labels", "bestK", "kCandidates", "silScores");
    disp("Saved new cluster_results.mat.");
end

% Now run cluster profiling to keep results in sync
run(fullfile(scriptDir, "analyze_clusters.m"));
disp("Clustering pipeline executed successfully.");
