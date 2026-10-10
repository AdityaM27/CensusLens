clc;
clear;
close all;

% Load processed census data
load(fullfile("data", "processed", "census_processed.mat"));

% Total population
totalPopulation = Tclean.TOT_P;

% Total workers
totalWorkers = Tclean.TOT_WORK_P;

% Create demographic indicators
childShare = Tclean.P_06 ./ totalPopulation;

literacyProportion = Tclean.P_LIT ./ totalPopulation;

scShare = Tclean.P_SC ./ totalPopulation;

stShare = Tclean.P_ST ./ totalPopulation;

workerRatio = totalWorkers ./ totalPopulation;

mainWorkerRatio = Tclean.MAINWORK_P ./ totalWorkers;

% Combine features into a matrix
X_demo = [
    childShare, ...
    literacyProportion, ...
    scShare, ...
    stShare, ...
    workerRatio, ...
    mainWorkerRatio
];

% Feature names
demoFeatureNames = {
    'ChildShare'
    'LiteracyProportion'
    'SCShare'
    'STShare'
    'WorkerRatio'
    'MainWorkerRatio'
};

% Remove rows containing invalid values
validRows = all(isfinite(X_demo), 2);

X_demo = X_demo(validRows, :);
T_demo = Tclean(validRows, :);

regionNames_demo = string(T_demo.Name);

% Save results
outputFolder = fullfile("data", "processed");

if ~isfolder(outputFolder)
    mkdir(outputFolder);
end

save(fullfile(outputFolder, "demographic_features.mat"), ...
    "X_demo", "T_demo", "regionNames_demo", ...
    "demoFeatureNames");

disp("Demographic feature engineering completed.");
disp("Dataset dimensions:");
disp(size(X_demo));

disp("Feature names:");
disp(demoFeatureNames);