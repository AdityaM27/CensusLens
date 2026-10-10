function [forecastTable, projectionMatrix, summaryData] = calculate_forecast(baselineChildren, regionNames, growthRate, numYears)
% CALCULATE_FORECAST Computes scenario-based child population projections
%
% Syntax:
%   [forecastTable, projectionMatrix, summaryData] = calculate_forecast(baselineChildren, regionNames, growthRate, numYears)
%
% Inputs:
%   baselineChildren - Column vector of child population (P_06) at baseline
%   regionNames      - String or cell array of district/region names
%   growthRate       - Annual compound growth rate (e.g., 0.02 for 2.0%)
%   numYears         - Number of projection horizon years (default: 5)
%
% Outputs:
%   forecastTable    - Table with columns [Region, BaselineChildren, Year1...YearN]
%   projectionMatrix - [numObservations x numYears] matrix of projected values
%   summaryData      - Struct with national totals, CAGR, and assumption notes
%
% Methodological Note:
%   This is an illustrative geometric sensitivity scenario (P_t = P_0 * (1 + r)^t),
%   NOT an actuarial cohort-component demographic forecast.

    if nargin < 4 || isempty(numYears)
        numYears = 5;
    end
    if nargin < 3 || isempty(growthRate)
        growthRate = 0.02; % Default 2.0%
    end

    baselineChildren = double(baselineChildren(:));
    regionNames = string(regionNames(:));
    numObs = length(baselineChildren);

    % Compute compound annual projections
    projectionMatrix = zeros(numObs, numYears);
    for t = 1:numYears
        projectionMatrix(:, t) = baselineChildren .* ((1 + growthRate) .^ t);
    end

    % Build table with explicit column headers
    colNames = {'Region', 'BaselineChildren'};
    for t = 1:numYears
        colNames{end + 1} = sprintf('Year%d', t); %#ok<AGROW>
    end

    forecastTable = table(regionNames, baselineChildren, 'VariableNames', colNames(1:2));
    for t = 1:numYears
        forecastTable.(colNames{t + 2}) = projectionMatrix(:, t);
    end

    % Summary metrics
    nationalBaseline = sum(baselineChildren);
    nationalProjected = sum(projectionMatrix, 1);
    
    summaryData = struct();
    summaryData.GrowthRatePercent = growthRate * 100;
    summaryData.HorizonYears = numYears;
    summaryData.NationalBaseline = nationalBaseline;
    summaryData.NationalProjected = nationalProjected;
    summaryData.TotalNetAddition = nationalProjected(end) - nationalBaseline;
    summaryData.TotalPercentChange = ((nationalProjected(end) / nationalBaseline) - 1) * 100;
    summaryData.Disclaimer = "Illustrative scenario simulation assuming uniform geometric growth. Not a validated demographic prediction.";

end
