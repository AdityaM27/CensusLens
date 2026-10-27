function [resourceTable, selectedSummary] = calculate_resource_demand( ...
    baselineChildren, regionNames, districtKeys, growthRate, numYears, ...
    targetCoverage, childrenPerCentre, staffPerCentre)
% CALCULATE_RESOURCE_DEMAND Builds an illustrative early-childhood demand scenario.
% It reports total requirements only. Existing capacity is absent from CensusLens,
% therefore additional centres and staff are explicitly marked unavailable.

    if nargin < 5 || isempty(numYears), numYears = 5; end
    if nargin < 6 || isempty(targetCoverage), targetCoverage = 1.0; end
    if nargin < 7 || isempty(childrenPerCentre), childrenPerCentre = 40; end
    if nargin < 8 || isempty(staffPerCentre), staffPerCentre = 2; end

    validateattributes(growthRate, {'numeric'}, {'scalar', 'real', 'finite', '>', -1});
    validateattributes(numYears, {'numeric'}, {'scalar', 'integer', 'positive'});
    validateattributes(targetCoverage, {'numeric'}, {'scalar', 'real', 'finite', '>=', 0, '<=', 1});
    validateattributes(childrenPerCentre, {'numeric'}, {'scalar', 'real', 'finite', 'positive'});
    validateattributes(staffPerCentre, {'numeric'}, {'scalar', 'real', 'finite', 'positive'});

    baselineChildren = double(baselineChildren(:));
    regionNames = string(regionNames(:));
    districtKeys = string(districtKeys(:));
    numRegions = numel(baselineChildren);
    if numel(regionNames) ~= numRegions || numel(districtKeys) ~= numRegions
        error('CensusLens:ResourceDemand:InputSizeMismatch', ...
            'baselineChildren, regionNames, and districtKeys must have equal lengths.');
    end

    years = (0:numYears)';
    perRegion = numel(years);
    regionIndex = repelem((1:numRegions)', perRegion);
    yearColumn = repmat(years, numRegions, 1);
    projectedChildren = baselineChildren(regionIndex) .* ((1 + growthRate) .^ yearColumn);
    requiredSeats = ceil(projectedChildren .* targetCoverage);
    requiredCentres = ceil(requiredSeats ./ childrenPerCentre);
    requiredStaff = ceil(requiredCentres .* staffPerCentre);
    unavailable = repmat("Unavailable: no capacity inventory loaded", numel(regionIndex), 1);

    resourceTable = table( ...
        regionNames(regionIndex), districtKeys(regionIndex), yearColumn, ...
        round(projectedChildren), requiredSeats, requiredCentres, requiredStaff, ...
        unavailable, unavailable, unavailable, ...
        'VariableNames', {'District', 'DistrictKey', 'Year', 'ProjectedChildren_0_6', ...
        'RequiredSeats', 'RequiredCentres', 'RequiredStaff', ...
        'ExistingCapacityData', 'AdditionalCentres', 'AdditionalStaff'});

    selectedSummary = struct();
    selectedSummary.AssumptionNote = sprintf([ ...
        'Illustrative scenario only: %.0f%% target coverage; %.0f planned seats per centre; %.0f staff per centre. ' ...
        'No centre-capacity inventory is available, so additional resources cannot be calculated.'], ...
        targetCoverage * 100, childrenPerCentre, staffPerCentre);
    selectedSummary.Years = years;
end