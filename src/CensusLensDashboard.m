function fig = CensusLensDashboard()
% CENSUSLENS DASHBOARD (Streamlined Executive Edition)
% Focused 2-Tab Demographic Intelligence & Strategic Policy Suite
% Compatible with MATLAB R2024 and Windows
%
% Layout:
%   Tab 1: Main Dashboard (Executive KPIs, District Demographics & PCA Landscape)
%   Tab 2: Final Results & Policy Impact (3-Cluster Solution, Resource Allocation & Dynamic Forecasting)

    %% 1. Ensure Path and Load Centralized Data
    scriptDir = fileparts(mfilename("fullpath"));
    projectRoot = fileparts(scriptDir);
    addpath(scriptDir);

    try
        data = load_project_data();
    catch ME
        errordlg("Failed to load project data: " + ME.message, "CensusLens Error");
        rethrow(ME);
    end

    %% 2. Styling Palette
    NAVY_DARK     = [0.08, 0.14, 0.24];
    NAVY_LIGHT    = [0.93, 0.95, 0.98];
    PANEL_BG      = [0.98, 0.98, 0.99];
    CARD_BG       = [1.00, 1.00, 1.00];
    TEXT_MAIN     = [0.12, 0.15, 0.20];
    ACCENT_BLUE   = [0.12, 0.44, 0.76];
    ACCENT_TEAL   = [0.11, 0.60, 0.54];
    ACCENT_ORANGE = [0.85, 0.45, 0.12];
    FONT_FAMILY   = 'Segoe UI';

    %% 3. Main Figure Setup
    screenSize = get(0, 'ScreenSize');
    figWidth  = min(1320, screenSize(3) - 60);
    figHeight = min(880,  screenSize(4) - 80);
    posX = max(30, (screenSize(3) - figWidth) / 2);
    posY = max(40, (screenSize(4) - figHeight) / 2);

    fig = uifigure('Name', 'CensusLens: Demographic Intelligence & Policy Dashboard (Census 2011)', ...
        'Position', [posX, posY, figWidth, figHeight], ...
        'Color', NAVY_LIGHT);

    mainGrid = uigridlayout(fig, [2, 1]);
    mainGrid.RowHeight = {55, '1x'};
    mainGrid.Padding = [10, 8, 10, 8];
    mainGrid.RowSpacing = 6;

    %% 4. Top Header Banner
    headerPanel = uipanel(mainGrid, 'BackgroundColor', NAVY_DARK, 'BorderType', 'none');
    headerGrid = uigridlayout(headerPanel, [1, 2]);
    headerGrid.ColumnWidth = {'1x', 360};
    headerGrid.Padding = [16, 6, 16, 6];

    titleLabel = uilabel(headerGrid, 'Text', 'CENSUSLENS | Demographic Intelligence & Policy Dashboard', ...
        'FontName', FONT_FAMILY, 'FontSize', 17, 'FontWeight', 'bold', ...
        'FontColor', [1, 1, 1]);
    titleLabel.VerticalAlignment = 'center';

    subLabel = uilabel(headerGrid, 'Text', 'India Census 2011 | 640 Districts | Computational Analytics', ...
        'FontName', FONT_FAMILY, 'FontSize', 11, 'FontColor', [0.85, 0.90, 0.98]);
    subLabel.HorizontalAlignment = 'right';
    subLabel.VerticalAlignment = 'center';

    %% 5. Streamlined 2-Tab Navigation
    tabGroup = uitabgroup(mainGrid);

    tabDashboard = uitab(tabGroup, 'Title', '  1. Main Dashboard (Demographic Intelligence)  ');
    tabResults   = uitab(tabGroup, 'Title', '  2. Final Results (Clusters, Resources & Forecasts)  ');

    % Build Tab 1 & Tab 2
    buildMainDashboardTab(tabDashboard, data, CARD_BG, ACCENT_BLUE, ACCENT_TEAL, FONT_FAMILY);
    buildFinalResultsTab(tabResults, data, CARD_BG, ACCENT_BLUE, ACCENT_ORANGE, FONT_FAMILY);

end

%% ========================================================================
% TAB 1: MAIN DASHBOARD (EXECUTIVE OVERVIEW, DEMOGRAPHICS & PCA)
% =========================================================================
function buildMainDashboardTab(parentTab, data, CARD_BG, ACCENT_BLUE, ACCENT_TEAL, FONT_FAMILY)
    tabGrid = uigridlayout(parentTab, [3, 1]);
    tabGrid.RowHeight = {90, '1.25x', '1x'};
    tabGrid.Padding = [12, 10, 12, 10];
    tabGrid.RowSpacing = 10;

    %% 1. Top KPI Summary Cards
    kpiGrid = uigridlayout(tabGrid, [1, 5]);
    kpiGrid.ColumnWidth = {'1x', '1x', '1x', '1x', '1x'};
    kpiGrid.Padding = [0, 0, 0, 0];

    createKPICard(kpiGrid, 'TOTAL POPULATION', sprintf('%.2f Billion', data.kpi.totalPopulation / 1e9), ...
        sprintf('%s persons', formatNumber(data.kpi.totalPopulation)), CARD_BG, ACCENT_BLUE, FONT_FAMILY);

    % Total Workforce (replacing Children 0-6)
    if isfield(data.kpi, 'totalWorkers')
        wVal = sprintf('%.2f Million', data.kpi.totalWorkers / 1e6);
        wSub = sprintf('%s workers (%.1f%%)', formatNumber(data.kpi.totalWorkers), data.kpi.nationalWorkerRate);
    else
        wVal = '481.89 Million';
        wSub = '481,888,868 active workers';
    end
    createKPICard(kpiGrid, 'TOTAL WORKFORCE', wVal, wSub, CARD_BG, [0.15, 0.65, 0.55], FONT_FAMILY);

    % National Sex Ratio (replacing Avg Child Share)
    if isfield(data.kpi, 'nationalSexRatio')
        srVal = sprintf('%d', data.kpi.nationalSexRatio);
    else
        srVal = '943';
    end
    createKPICard(kpiGrid, 'SEX RATIO', srVal, 'Females per 1,000 Males', CARD_BG, [0.85, 0.45, 0.15], FONT_FAMILY);

    createKPICard(kpiGrid, 'NATIONAL LITERACY', sprintf('%.2f%%', data.kpi.nationalLiteracyRate), ...
        sprintf('%s literates', formatNumber(data.kpi.totalLiterate)), CARD_BG, [0.45, 0.25, 0.70], FONT_FAMILY);
    createKPICard(kpiGrid, 'OBSERVATIONS', sprintf('%d Districts', data.numDistricts), ...
        '35 States & Union Territories', CARD_BG, [0.20, 0.50, 0.70], FONT_FAMILY);

    %% 2. Middle Row: Interactive District Comparison & PCA Space
    midGrid = uigridlayout(tabGrid, [1, 2]);
    midGrid.ColumnWidth = {'1.1x', '1x'};
    midGrid.Padding = [0, 0, 0, 0];

    % Left: District Demographics vs National Average
    demoPanel = uipanel(midGrid, 'BackgroundColor', CARD_BG, ...
        'Title', 'District Demographic Signature vs. National Average', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    dpLayout = uigridlayout(demoPanel, [2, 1]);
    dpLayout.RowHeight = {35, '1x'};
    dpLayout.Padding = [10, 8, 10, 8];

    selGrid = uigridlayout(dpLayout, [1, 4]);
    selGrid.ColumnWidth = {110, 240, 100, 180};
    selGrid.Padding = [0, 0, 0, 0];

    uilabel(selGrid, 'Text', 'Select District:', 'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    distDrop1 = uidropdown(selGrid, 'Items', cellstr(data.districtKeys), 'Value', char(data.districtKeys(1)), ...
        'FontName', FONT_FAMILY);

    uilabel(selGrid, 'Text', 'Compare With:', 'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    compItems = [{'National Average'}; cellstr(data.districtKeys)];
    distDrop2 = uidropdown(selGrid, 'Items', compItems, 'Value', 'National Average', 'FontName', FONT_FAMILY);

    axComp = uiaxes(dpLayout);
    axComp.FontName = FONT_FAMILY;

    % Right: PCA Dimensionality Reduction Scatter (640 Districts)
    pcaPanel = uipanel(midGrid, 'BackgroundColor', CARD_BG, ...
        'Title', 'PCA Demographic Space (6 Dimensions Projected into 2 Axes)', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    ppLayout = uigridlayout(pcaPanel, [1, 1]);
    ppLayout.Padding = [10, 8, 10, 8];
    axPCA = uiaxes(ppLayout);
    axPCA.FontName = FONT_FAMILY;

    %% 3. Bottom Row: Searchable District Master Register
    botPanel = uipanel(tabGrid, 'BackgroundColor', CARD_BG, ...
        'Title', 'Searchable National District Census Register (640 Administrative Units)', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    bpLayout = uigridlayout(botPanel, [2, 1]);
    bpLayout.RowHeight = {30, '1x'};
    bpLayout.Padding = [8, 6, 8, 6];

    searchBox = uieditfield(bpLayout, 'text', 'Placeholder', 'Type district or state name to filter instantly...', ...
        'FontName', FONT_FAMILY);

    if ismember('TOT_M', data.Tclean.Properties.VariableNames) && ismember('TOT_F', data.Tclean.Properties.VariableNames)
        srCol = round((double(data.Tclean.TOT_F) ./ max(double(data.Tclean.TOT_M), 1)) * 1000);
    else
        srCol = repmat(943, data.numDistricts, 1);
    end

    dispTable = table( ...
        (1:data.numDistricts)', ...
        data.districtNames, ...
        data.stateNames, ...
        double(data.Tclean.TOT_P), ...
        double(data.Tclean.TOT_WORK_P), ...
        srCol, ...
        double(data.Tclean.P_06), ...
        round((double(data.Tclean.P_06) ./ double(data.Tclean.TOT_P)) * 100, 2), ...
        double(data.Tclean.P_LIT), ...
        round((double(data.Tclean.P_LIT) ./ double(data.Tclean.TOT_P)) * 100, 2), ...
        'VariableNames', {'Index', 'District', 'State', 'TotalPopulation', 'Workers', 'SexRatio', 'ChildPop_0_6', 'ChildSharePct', 'Literates', 'LiteracyPct'});

    uiMasterTable = uitable(bpLayout, 'Data', dispTable, 'FontName', FONT_FAMILY, 'FontSize', 11);
    searchBox.ValueChangedFcn = @(src, ~) filterTable(src.Value, dispTable, uiMasterTable);

    % Link Updates
    refreshTab1 = @() updateTab1Plots(distDrop1.Value, distDrop2.Value, data, axComp, axPCA, ACCENT_BLUE, ACCENT_TEAL);
    distDrop1.ValueChangedFcn = @(~, ~) refreshTab1();
    distDrop2.ValueChangedFcn = @(~, ~) refreshTab1();
    refreshTab1();
end

function updateTab1Plots(selKey1, selKey2, data, axComp, axPCA, col1, col2)
    idx1 = find(data.districtKeys == string(selKey1), 1);
    if isempty(idx1), idx1 = 1; end

    vals1 = data.X_demo(idx1, :) * 100;
    lbls = {'Child Share', 'Literacy', 'SC Share', 'ST Share', 'Worker Ratio', 'Main Worker'};

    % Update Comparison Bar Chart
    cla(axComp);
    if strcmp(selKey2, 'National Average')
        vals2 = mean(data.X_demo, 1) * 100;
        name2 = 'National Mean';
    else
        idx2 = find(data.districtKeys == string(selKey2), 1);
        if isempty(idx2), idx2 = 1; end
        vals2 = data.X_demo(idx2, :) * 100;
        name2 = char(data.districtNames(idx2));
    end

    b = bar(axComp, [vals1; vals2]', 'grouped');
    b(1).FaceColor = col1;
    b(2).FaceColor = col2;
    axComp.XTick = 1:6;
    axComp.XTickLabel = lbls;
    axComp.YLabel.String = 'Proportion (%)';
    legend(axComp, {char(data.districtNames(idx1)), name2}, 'Location', 'northoutside', 'Orientation', 'horizontal');
    axComp.XGrid = 'on';
    axComp.YGrid = 'on';

    % Update PCA Scatter with Selected District Highlight
    cla(axPCA);
    Y = data.pca_demo.Y_demo;
    labels = data.clustering.labels;
    colors = [0.15 0.55 0.85; 0.90 0.40 0.20; 0.20 0.70 0.40];
    hold(axPCA, 'on');
    for c = 1:3
        m = (labels == c);
        scatter(axPCA, Y(m, 1), Y(m, 2), 22, colors(c, :), 'filled', 'MarkerFaceAlpha', 0.65);
    end
    % Plot highlighted district
    plot(axPCA, Y(idx1, 1), Y(idx1, 2), 'p', 'MarkerSize', 15, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'k', 'LineWidth', 1.5);
    hold(axPCA, 'off');
    axPCA.XLabel.String = sprintf('PC 1: Development/Literacy vs Child Dependency (%.1f%%)', data.pca_demo.explainedVariance_demo(1));
    axPCA.YLabel.String = sprintf('PC 2: Tribal / Agrarian Concentration (%.1f%%)', data.pca_demo.explainedVariance_demo(2));
    legend(axPCA, {'Cluster 1', 'Cluster 2', 'Cluster 3', [char(data.districtNames(idx1)), ' (Selected)']}, 'Location', 'northeast');
    axPCA.XGrid = 'on';
    axPCA.YGrid = 'on';
end

%% ========================================================================
% TAB 2: FINAL RESULTS & STRATEGIC PLANNING (CLUSTERS, RESOURCES & FORECAST)
% =========================================================================
function buildFinalResultsTab(parentTab, data, CARD_BG, ACCENT_BLUE, ACCENT_ORANGE, FONT_FAMILY)
    tabGrid = uigridlayout(parentTab, [2, 1]);
    tabGrid.RowHeight = {'1.1x', '1.15x'};
    tabGrid.Padding = [12, 10, 12, 10];
    tabGrid.RowSpacing = 10;

    %% Top Section: 3-Cluster Solution & Early Childhood Resource Demand
    topGrid = uigridlayout(tabGrid, [1, 2]);
    topGrid.ColumnWidth = {'1.1x', '1x'};
    topGrid.Padding = [0, 0, 0, 0];

    % Left: Cluster Archetype Profiles
    clustPanel = uipanel(topGrid, 'BackgroundColor', CARD_BG, ...
        'Title', 'Final Output 1: Unsupervised 3-Cluster Solution (Policy Archetypes)', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    cpLayout = uigridlayout(clustPanel, [2, 1]);
    cpLayout.RowHeight = {115, '1x'};
    cpLayout.Padding = [8, 6, 8, 6];

    % Profile summary table
    pTab = data.clustering.profileTable;
    uitable(cpLayout, 'Data', pTab, 'FontName', FONT_FAMILY, 'FontSize', 11);

    % Cluster explanation text
    expPanel = uipanel(cpLayout, 'BackgroundColor', [0.96, 0.98, 1.0], 'BorderType', 'none');
    epLayout = uigridlayout(expPanel, [1, 1]);
    epLayout.Padding = [8, 6, 8, 6];
    clustExplanation = sprintf([ ...
        'Demographic Cluster Takeaways (Unsupervised K-Means on Standardized Rates):\n' ...
        '  - Cluster 1 (125 Districts): High Scheduled Tribe (ST) share (~66.3%%), agrarian workforce -> Target: Tribal welfare & rural support.\n' ...
        '  - Cluster 2 (207 Districts): High Child Dependency (~16.5%%), lower literacy (~54.3%%) -> Target: High priority for preschools & child health.\n' ...
        '  - Cluster 3 (308 Districts): Advanced demographic transition, high literacy (~69.6%%), formal workforce -> Target: Urban & secondary development.']);
    uilabel(epLayout, 'Text', clustExplanation, 'FontName', FONT_FAMILY, 'FontSize', 10, 'FontColor', [0.1, 0.2, 0.35], 'WordWrap', 'on');

    % Right: Early Childhood Resource Demand Priority
    resPanel = uipanel(topGrid, 'BackgroundColor', CARD_BG, ...
        'Title', 'Final Output 2: Early Childhood Resource Demand Priority', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    rpLayout = uigridlayout(resPanel, [3, 1]);
    rpLayout.RowHeight = {40, 110, '1x'};
    rpLayout.Padding = [10, 6, 10, 6];

    % Disclaimer callout
    discLabel = uilabel(rpLayout, 'Text', 'Policy Notice: Child population (0-6) serves as an illustrative demographic planning proxy for preschool (ECCE) demand, not an audited physical deficit.', ...
        'FontName', FONT_FAMILY, 'FontSize', 9.5, 'FontColor', [0.65, 0.35, 0.05], 'FontAngle', 'italic', 'WordWrap', 'on');

    % District Inspector Card
    cardGrid = uigridlayout(rpLayout, [4, 2]);
    cardGrid.RowHeight = {26, 26, 26, 26};
    cardGrid.ColumnWidth = {110, '1x'};
    cardGrid.Padding = [0, 0, 0, 0];

    uilabel(cardGrid, 'Text', 'Inspect District:', 'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    resDistDrop = uidropdown(cardGrid, 'Items', cellstr(data.districtKeys), 'Value', char(data.districtKeys(1)), ...
        'FontName', FONT_FAMILY);

    uilabel(cardGrid, 'Text', 'Child Cohort (0-6):', 'FontName', FONT_FAMILY);
    lblChildPop = uilabel(cardGrid, 'Text', '-', 'FontName', FONT_FAMILY, 'FontWeight', 'bold');

    uilabel(cardGrid, 'Text', 'Child Share (%):', 'FontName', FONT_FAMILY);
    lblChildShare = uilabel(cardGrid, 'Text', '-', 'FontName', FONT_FAMILY);

    uilabel(cardGrid, 'Text', 'ECCE Units Proxy:', 'FontName', FONT_FAMILY);
    lblECCEProxy = uilabel(cardGrid, 'Text', '-', 'FontName', FONT_FAMILY, 'FontWeight', 'bold', 'FontColor', ACCENT_ORANGE);

    % Top 10 districts horizontal bar chart
    axDemand = uiaxes(rpLayout);
    axDemand.FontName = FONT_FAMILY;

    rTab = data.resourceTable;
    topChild = rTab.ChildPopulation_0_6(1:10) / 1e3;
    topNames = rTab.District(1:10);
    barh(axDemand, 10:-1:1, flipud(topChild), 'FaceColor', ACCENT_ORANGE);
    axDemand.YTick = 1:10;
    axDemand.YTickLabel = flipud(topNames);
    axDemand.XLabel.String = 'Children Aged 0-6 (Thousands)';
    title(axDemand, 'Top 10 Districts by Early Childhood Scale');
    axDemand.XGrid = 'on';
    axDemand.YGrid = 'on';

    updateResCard = @(key) updateResourceInspector(key, data, lblChildPop, lblChildShare, lblECCEProxy);
    resDistDrop.ValueChangedFcn = @(src, ~) updateResCard(src.Value);
    updateResCard(resDistDrop.Value);

    %% Bottom Section: Dynamic 5-Year Scenario Forecasting Engine
    fcPanel = uipanel(tabGrid, 'BackgroundColor', CARD_BG, ...
        'Title', 'Final Output 3: Dynamic 5-Year Scenario Forecasting Engine (P_t = P_0 * (1 + r)^t)', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    fcLayout = uigridlayout(fcPanel, [2, 1]);
    fcLayout.RowHeight = {40, '1x'};
    fcLayout.Padding = [10, 8, 10, 8];

    % Controls Top Bar
    ctrlGrid = uigridlayout(fcLayout, [1, 5]);
    ctrlGrid.ColumnWidth = {180, 100, 110, 260, '1x'};
    ctrlGrid.Padding = [0, 0, 0, 0];

    uilabel(ctrlGrid, 'Text', 'Annual Growth Rate (r):', 'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    rateSpinner = uispinner(ctrlGrid, 'Limits', [-3.0, 5.0], 'Value', 2.0, 'Step', 0.1, ...
        'ValueDisplayFormat', '%.1f%%', 'FontName', FONT_FAMILY);

    btnReset = uibutton(ctrlGrid, 'push', 'Text', 'Reset (2.0%)', 'FontName', FONT_FAMILY);

    uilabel(ctrlGrid, 'Text', 'Trajectory District:', 'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    fcDistDrop = uidropdown(ctrlGrid, 'Items', cellstr(data.districtKeys), 'Value', char(data.districtKeys(1)), ...
        'FontName', FONT_FAMILY);

    % Lower: Forecast Trend Chart + Forecast Table
    fcMidGrid = uigridlayout(fcLayout, [1, 2]);
    fcMidGrid.ColumnWidth = {'1.1x', '1.2x'};
    fcMidGrid.Padding = [0, 0, 0, 0];

    axTrend = uiaxes(fcMidGrid);
    axTrend.FontName = FONT_FAMILY;

    fcTableUI = uitable(fcMidGrid, 'FontName', FONT_FAMILY, 'FontSize', 11);

    % Real-time dynamic recalculation callback
    recalcForecast = @() updateForecastEngine(rateSpinner.Value / 100, fcDistDrop.Value, data, axTrend, fcTableUI, ACCENT_BLUE);
    rateSpinner.ValueChangedFcn = @(~, ~) recalcForecast();
    fcDistDrop.ValueChangedFcn  = @(~, ~) recalcForecast();
    btnReset.ButtonPushedFcn    = @(~, ~) setRateAndRecalc(rateSpinner, 2.0, recalcForecast);
    recalcForecast();

end

function setRateAndRecalc(spinner, val, recalcFn)
    spinner.Value = val;
    recalcFn();
end

function updateForecastEngine(rate, distKey, data, axTrend, uiTab, col)
    [fcTable, pMat, sData] = calculate_forecast(data.Tclean.P_06, data.districtNames, rate, 5);
    uiTab.Data = fcTable;

    idx = find(data.districtKeys == string(distKey), 1);
    if isempty(idx), idx = 1; end

    baseVal = double(data.Tclean.P_06(idx));
    traj = [baseVal, pMat(idx, :)];
    years = 0:5;

    cla(axTrend);
    plot(axTrend, years, traj / 1e3, '-bo', 'LineWidth', 2.2, 'MarkerFaceColor', col, 'MarkerSize', 7);
    axTrend.XTick = 0:5;
    axTrend.XTickLabel = {'Baseline', 'Yr 1', 'Yr 2', 'Yr 3', 'Yr 4', 'Yr 5'};
    axTrend.XLabel.String = 'Projection Horizon (Years)';
    axTrend.YLabel.String = 'Children Aged 0-6 (Thousands)';
    title(axTrend, sprintf('%s: 5-Year Trajectory at r = %.1f%% per year', char(data.districtNames(idx)), rate * 100));
    axTrend.XGrid = 'on';
    axTrend.YGrid = 'on';
end

function updateResourceInspector(key, data, lChild, lShare, lProxy)
    idx = find(data.districtKeys == string(key), 1);
    if isempty(idx), idx = 1; end

    totP = double(data.Tclean.TOT_P(idx));
    childP = double(data.Tclean.P_06(idx));
    childS = (childP / max(totP, 1)) * 100;
    ecceU = ceil(childP / 40);

    lChild.Text = sprintf('%s children', formatNumber(childP));
    lShare.Text = sprintf('%.2f%% of district population', childS);
    lProxy.Text = sprintf('%s target units (40-child norm)', formatNumber(ecceU));
end

function filterTable(query, fullTable, uiTable)
    query = strtrim(string(query));
    if query == ""
        uiTable.Data = fullTable;
    else
        matches = contains(string(fullTable.District), query, 'IgnoreCase', true) | ...
                  contains(string(fullTable.State), query, 'IgnoreCase', true);
        uiTable.Data = fullTable(matches, :);
    end
end

function createKPICard(parent, titleText, mainVal, subText, bgCol, accentCol, fontFam)
    p = uipanel(parent, 'BackgroundColor', bgCol, 'BorderType', 'line', 'HighlightColor', [0.85, 0.88, 0.92]);
    g = uigridlayout(p, [3, 1]);
    g.RowHeight = {16, 32, 14};
    g.Padding = [10, 8, 10, 8];
    g.RowSpacing = 2;

    uilabel(g, 'Text', titleText, 'FontName', fontFam, 'FontSize', 10, 'FontWeight', 'bold', 'FontColor', accentCol);
    uilabel(g, 'Text', mainVal, 'FontName', fontFam, 'FontSize', 18, 'FontWeight', 'bold', 'FontColor', [0.1, 0.15, 0.2]);
    uilabel(g, 'Text', subText, 'FontName', fontFam, 'FontSize', 9, 'FontColor', [0.45, 0.5, 0.58]);
end

function str = formatNumber(num)
    if isnan(num) || isempty(num)
        str = 'N/A';
        return;
    end
    num = round(double(num));
    numStr = sprintf('%.0f', num);
    len = length(numStr);
    if len <= 3
        str = numStr;
        return;
    end
    parts = {};
    remLen = rem(len, 3);
    if remLen > 0
        parts{end + 1} = numStr(1:remLen);
    end
    for i = (remLen + 1):3:len
        parts{end + 1} = numStr(i:(i + 2));
    end
    str = strjoin(parts, ',');
end
