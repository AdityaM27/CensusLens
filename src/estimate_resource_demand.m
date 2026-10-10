clc;
clear;
close all;

% Load the cleaned census dataset
load(fullfile("data", "processed", "census_processed.mat"));

% Check required columns
requiredColumns = ["P_06", "TOT_P"];

if ~all(ismember(requiredColumns, string(Tclean.Properties.VariableNames)))
error("Required columns P_06 or TOT_P are missing.");
end

% Extract child population and total population
childPopulation = Tclean.P_06;
totalPopulation = Tclean.TOT_P;

% Calculate child population share
childShare = childPopulation ./ totalPopulation;

% Define an illustrative resource planning scenario
% Assumption: one potential early-childhood place per child aged 0-6
estimatedPlaces = childPopulation;

% Create results table
resourceTable = table( ...
string(regionNames), ...
totalPopulation, ...
childPopulation, ...
childShare, ...
estimatedPlaces, ...
'VariableNames', { ...
'Region', ...
'TotalPopulation', ...
'ChildPopulation', ...
'ChildShare', ...
'IllustrativePlaces'});

% Display first 10 rows
disp("Illustrative resource demand estimates:");
disp(resourceTable(1:min(10,height(resourceTable)), :));

% Summary statistics
disp("Total observations:");
disp(height(resourceTable));

fprintf("Total population across observations: %.0f\n", ...
sum(totalPopulation));

fprintf("Total population aged 0-6: %.0f\n", ...
sum(childPopulation));

fprintf("Average child population share: %.2f%%\n", ...
100 * mean(childShare, "omitnan"));

% Create output folder if needed
if ~exist(fullfile("results", "forecasting"), "dir")
mkdir(fullfile("results", "forecasting"));
end

% Save CSV and MAT files
writetable(resourceTable, ...
fullfile("results", "forecasting", "resource_demand.csv"));

save(fullfile("results", "forecasting", "resource_demand.mat"), ...
"resourceTable", "childPopulation", "totalPopulation", ...
"childShare", "estimatedPlaces");

disp("Saved resource_demand.csv and resource_demand.mat.");
