clc;
clear;
close all;

% Load demographic PCA results
load(fullfile("results", "pca", "demographic_pca.mat"));

% Create clustering results folder if it does not exist
if ~exist(fullfile("results", "clustering"), "dir")
mkdir(fullfile("results", "clustering"));
end

% Use the first five principal components
X_cluster = Y_demo_reduced;

% Set the random seed for reproducibility
rng(42);

% Test different numbers of clusters
K_values = 2:6;
silhouette_scores = zeros(length(K_values), 1);

disp("Evaluating K-means clustering...");

for i = 1:length(K_values)

K = K_values(i);

% Perform K-means clustering
cluster_labels_temp = kmeans( ...
    X_cluster, K, ...
    "Replicates", 10, ...
    "MaxIter", 500);

% Calculate silhouette values
sil_values = silhouette(X_cluster, cluster_labels_temp);

% Calculate average silhouette score
silhouette_scores(i) = mean(sil_values);

fprintf("K = %d, Average silhouette score = %.4f\n", ...
    K, silhouette_scores(i));

end

% Select K with the highest average silhouette score
[best_silhouette, best_index] = max(silhouette_scores);
bestK = K_values(best_index);

% Perform final clustering
cluster_labels = kmeans( ...
X_cluster, bestK, ...
"Replicates", 20, ...
"MaxIter", 500);

% Display results
fprintf("\nBest K based on silhouette score: %d\n", bestK);
fprintf("Best average silhouette score: %.4f\n", best_silhouette);

disp("Cluster sizes:");

for k = 1:bestK
fprintf("Cluster %d: %d districts\n", ...
k, sum(cluster_labels == k));
end

% Plot silhouette scores for different K values
figure;
plot(K_values, silhouette_scores, "-o", "LineWidth", 2);
xlabel("Number of Clusters (K)");
ylabel("Average Silhouette Score");
title("Selecting K for District Clustering");
xticks(K_values);
grid on;

% Plot the first two principal components
figure;
gscatter(X_cluster(:,1), X_cluster(:,2), cluster_labels);
xlabel("Principal Component 1");
ylabel("Principal Component 2");
title("Demographic Clusters of Census Districts");
grid on;

% Save clustering results
save(fullfile("results", "clustering", "cluster_results.mat"), ...
"X_cluster", "K_values", "silhouette_scores", ...
"bestK", "best_silhouette", "cluster_labels", ...
"regionNames_demo", "demoFeatureNames");

disp("Saved cluster_results.mat successfully.");
