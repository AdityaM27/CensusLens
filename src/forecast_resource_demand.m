clc;
clear;
close all;

% Load resource demand results
load(fullfile("results", "forecasting", "resource_demand.mat"));

% Forecast settings
forecastYears = 5;
annualGrowthRate = 0.02;  % Illustrative 2% annual growth assumption

% Create forecast table
numRegions = height(resourceTable);

forecastTable = table( ...
resourceTable.Region, ...
resourceTable.ChildPopulation, ...
'VariableNames', {'Region', 'BaselineChildren'});

% Generate forecasts for each future year
for year = 1:forecastYears

yearName = sprintf("Year%d", year);

forecastTable.(yearName) = ...
    resourceTable.ChildPopulation .* ...
    (1 + annualGrowthRate).^year;

end

% Display the first 10 regions
disp("Five-year illustrative resource-demand forecast:");
disp(forecastTable(1:min(10, numRegions), :));

% Calculate total forecast for each year
disp("Total projected child population by year:");

for year = 1:forecastYears

yearName = sprintf("Year%d", year);

fprintf("%s: %.0f\n", ...
    yearName, sum(forecastTable.(yearName)));

end

% Create year labels for the plot
years = 0:forecastYears;

totalChildren = zeros(1, forecastYears + 1);
totalChildren(1) = sum(resourceTable.ChildPopulation);

for year = 1:forecastYears
totalChildren(year + 1) = ...
sum(forecastTable.(sprintf("Year%d", year)));
end

% Plot forecast
figure;
plot(years, totalChildren, "-o", "LineWidth", 2);
xlabel("Years from Baseline");
ylabel("Projected Population Aged 0-6");
title("Illustrative Five-Year Resource-Demand Scenario");
xticks(years);
grid on;

% Save results
writetable(forecastTable, ...
fullfile("results", "forecasting", "forecast_results.csv"));

save(fullfile("results", "forecasting", "forecast_results.mat"), ...
"forecastTable", "forecastYears", ...
"annualGrowthRate", "years", "totalChildren");

disp("Saved forecast_results.csv and forecast_results.mat.");
