clc;
clear;
close all;

% Load clustering results
load(fullfile("results", "clustering", "cluster_results.mat"));

% Load original demographic features
load(fullfile("data", "processed", "demographic_features.mat"));

% Check that observations match
if size(X_demo, 1) ~= length(cluster_labels)
error("Feature rows and cluster labels do not match.");
end

% Create cluster profile matrix
numClusters = bestK;
numFeatures = size(X_demo, 2);

clusterProfiles = zeros(numClusters, numFeatures);
clusterSizes = zeros(numClusters, 1);

for k = 1:numClusters

% Select observations belonging to this cluster
idx = (cluster_labels == k);

% Calculate cluster size
clusterSizes(k) = sum(idx);

% Calculate mean demographic features
clusterProfiles(k, :) = mean(X_demo(idx, :), 1);

end

% Create a table of cluster profiles
profileTable = array2table(clusterProfiles, ...
"VariableNames", demoFeatureNames);

profileTable.Cluster = (1:numClusters)';
profileTable.ObservationCount = clusterSizes;

% Put cluster information first
profileTable = movevars(profileTable, ...
["Cluster", "ObservationCount"], "Before", 1);

% Display profiles
disp("Demographic cluster profiles:");
disp(profileTable);

% Create output folder if needed
if ~exist(fullfile("results", "clustering"), "dir")
mkdir(fullfile("results", "clustering"));
end

% Save cluster profiles
writetable(profileTable, ...
fullfile("results", "clustering", "cluster_profiles.csv"));

save(fullfile("results", "clustering", "cluster_profiles.mat"), ...
"profileTable", "clusterProfiles", "clusterSizes", ...
"demoFeatureNames", "bestK");

disp("Saved cluster_profiles.csv and cluster_profiles.mat.");
