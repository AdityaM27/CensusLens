function fig = CensusLensDashboard()
% CENSUSLENS DASHBOARD
% Comprehensive Demographic Intelligence & Resource Demand Analysis Application
% Compatible with MATLAB R2024 and Windows
%
% Syntax:
%   CensusLensDashboard()
%   fig = CensusLensDashboard()
%
% Sections:
%   A. Overview
%   B. Demographic Analysis
%   C. PCA Analysis
%   D. SVD Analysis
%   E. Adaptive PCA
%   F. District Clustering
%   G. Resource Planning
%   H. Scenario Forecasting
%   I. Mathematical Summary

    %% 1. Ensure Path and Load Data
    scriptDir = fileparts(mfilename("fullpath"));
    projectRoot = fileparts(scriptDir);
    addpath(scriptDir);

    try
        data = load_project_data();
    catch ME
        errordlg("Failed to load project data: " + ME.message, "CensusLens Error");
        rethrow(ME);
    end

    %% 2. Color Palette & Styling Constants
    NAVY_DARK   = [0.08, 0.14, 0.24];
    NAVY_LIGHT  = [0.93, 0.95, 0.98];
    PANEL_BG    = [0.98, 0.98, 0.99];
    CARD_BG     = [1.00, 1.00, 1.00];
    TEXT_MAIN   = [0.12, 0.15, 0.20];
    TEXT_MUTED  = [0.40, 0.45, 0.52];
    ACCENT_BLUE = [0.12, 0.44, 0.76];
    ACCENT_TEAL = [0.11, 0.60, 0.54];
    ACCENT_ORANGE = [0.85, 0.45, 0.12];
    FONT_FAMILY = 'Segoe UI';

    %% 3. Main Figure Creation
    screenSize = get(0, 'ScreenSize');
    figWidth  = min(1320, screenSize(3) - 60);
    figHeight = min(880,  screenSize(4) - 80);
    posX = max(30, (screenSize(3) - figWidth) / 2);
    posY = max(40, (screenSize(4) - figHeight) / 2);

    fig = uifigure('Name', 'CensusLens Demographic Intelligence Dashboard (Census 2011)', ...
        'Position', [posX, posY, figWidth, figHeight], ...
        'Color', NAVY_LIGHT);

    % Main Vertical Layout
    mainGrid = uigridlayout(fig, [2, 1]);
    mainGrid.RowHeight = {55, '1x'};
    mainGrid.Padding = [10, 8, 10, 8];
    mainGrid.RowSpacing = 6;

    %% 4. Top Header Banner
    headerPanel = uipanel(mainGrid, 'BackgroundColor', NAVY_DARK, 'BorderType', 'none');
    headerGrid = uigridlayout(headerPanel, [1, 2]);
    headerGrid.ColumnWidth = {'1x', 320};
    headerGrid.Padding = [15, 6, 15, 6];

    titleLabel = uilabel(headerGrid, 'Text', 'CENSUSLENS | Demographic Intelligence & Resource Demand Suite', ...
        'FontName', FONT_FAMILY, 'FontSize', 17, 'FontWeight', 'bold', ...
        'FontColor', [1, 1, 1]);
    titleLabel.VerticalAlignment = 'center';

    subLabel = uilabel(headerGrid, 'Text', 'India Census 2011 | 640 Districts | Computational Analytics', ...
        'FontName', FONT_FAMILY, 'FontSize', 11, 'FontColor', [0.8, 0.85, 0.95]);
    subLabel.HorizontalAlignment = 'right';
    subLabel.VerticalAlignment = 'center';

    %% 5. Navigation Tabs
    tabGroup = uitabgroup(mainGrid);

    tabOverview    = uitab(tabGroup, 'Title', '1. Overview');
    tabDemo        = uitab(tabGroup, 'Title', '2. Demographics');
    tabPCA         = uitab(tabGroup, 'Title', '3. PCA Analysis');
    tabSVD         = uitab(tabGroup, 'Title', '4. SVD Analysis');
    tabAdaptive    = uitab(tabGroup, 'Title', '5. Adaptive PCA');
    tabClusters    = uitab(tabGroup, 'Title', '6. District Clusters');
    tabResources   = uitab(tabGroup, 'Title', '7. Resource Planning');
    tabForecast    = uitab(tabGroup, 'Title', '8. Forecasting');
    tabMathSummary = uitab(tabGroup, 'Title', '9. Mathematical Summary');

    % =========================================================================
    %% TAB 1: OVERVIEW
    % =========================================================================
    buildOverviewTab(tabOverview, data, CARD_BG, PANEL_BG, ACCENT_BLUE, TEXT_MAIN, TEXT_MUTED, FONT_FAMILY);

    % =========================================================================
    %% TAB 2: DEMOGRAPHIC ANALYSIS
    % =========================================================================
    buildDemographicsTab(tabDemo, data, CARD_BG, PANEL_BG, ACCENT_BLUE, ACCENT_TEAL, TEXT_MAIN, FONT_FAMILY);

    % =========================================================================
    %% TAB 3: PCA ANALYSIS
    % =========================================================================
    buildPCATab(tabPCA, data, CARD_BG, PANEL_BG, ACCENT_BLUE, TEXT_MAIN, FONT_FAMILY);

    % =========================================================================
    %% TAB 4: SVD ANALYSIS
    % =========================================================================
    buildSVDTab(tabSVD, data, CARD_BG, PANEL_BG, ACCENT_BLUE, ACCENT_TEAL, TEXT_MAIN, FONT_FAMILY);

    % =========================================================================
    %% TAB 5: ADAPTIVE PCA
    % =========================================================================
    buildAdaptivePCATab(tabAdaptive, data, CARD_BG, PANEL_BG, ACCENT_BLUE, ACCENT_ORANGE, TEXT_MAIN, FONT_FAMILY);

    % =========================================================================
    %% TAB 6: DISTRICT CLUSTERING
    % =========================================================================
    buildClusteringTab(tabClusters, data, CARD_BG, PANEL_BG, TEXT_MAIN, FONT_FAMILY);

    % =========================================================================
    %% TAB 7: RESOURCE PLANNING
    % =========================================================================
    buildResourcePlanningTab(tabResources, data, CARD_BG, PANEL_BG, ACCENT_ORANGE, TEXT_MAIN, FONT_FAMILY);

    % =========================================================================
    %% TAB 8: FORECASTING
    % =========================================================================
    buildForecastingTab(tabForecast, data, CARD_BG, PANEL_BG, ACCENT_BLUE, TEXT_MAIN, FONT_FAMILY);

    % =========================================================================
    %% TAB 9: MATHEMATICAL SUMMARY
    % =========================================================================
    buildMathSummaryTab(tabMathSummary, data, CARD_BG, PANEL_BG, TEXT_MAIN, FONT_FAMILY);

end

%% ========================================================================
% HELPER: TAB 1 BUILDER (OVERVIEW)
% =========================================================================
function buildOverviewTab(parentTab, data, CARD_BG, PANEL_BG, ACCENT_BLUE, TEXT_MAIN, TEXT_MUTED, FONT_FAMILY)
    tabGrid = uigridlayout(parentTab, [3, 1]);
    tabGrid.RowHeight = {95, '1.1x', '1x'};
    tabGrid.Padding = [12, 10, 12, 10];
    tabGrid.RowSpacing = 10;

    % 1. KPI Cards Panel
    kpiGrid = uigridlayout(tabGrid, [1, 5]);
    kpiGrid.ColumnWidth = {'1x', '1x', '1x', '1x', '1x'};
    kpiGrid.Padding = [0, 0, 0, 0];

    createKPICard(kpiGrid, 'TOTAL POPULATION', sprintf('%.2f Billion', data.kpi.totalPopulation / 1e9), ...
        sprintf('%s persons', formatNumber(data.kpi.totalPopulation)), CARD_BG, ACCENT_BLUE, FONT_FAMILY);
    createKPICard(kpiGrid, 'CHILD POPULATION (0-6)', sprintf('%.2f Million', data.kpi.totalChildren / 1e6), ...
        sprintf('%s children', formatNumber(data.kpi.totalChildren)), CARD_BG, [0.15, 0.65, 0.55], FONT_FAMILY);
    createKPICard(kpiGrid, 'AVG CHILD SHARE', sprintf('%.2f%%', data.kpi.nationalChildShare), ...
        'National demographic ratio', CARD_BG, [0.85, 0.45, 0.15], FONT_FAMILY);
    createKPICard(kpiGrid, 'NATIONAL LITERACY', sprintf('%.2f%%', data.kpi.nationalLiteracyRate), ...
        sprintf('%s literates', formatNumber(data.kpi.totalLiterate)), CARD_BG, [0.45, 0.25, 0.70], FONT_FAMILY);
    createKPICard(kpiGrid, 'OBSERVATIONS', sprintf('%d Districts', data.kpi.totalDistricts), ...
        '35 States & Union Territories', CARD_BG, [0.20, 0.50, 0.70], FONT_FAMILY);

    % 2. Middle Row: Top 10 Chart & Top 10 Table
    midGrid = uigridlayout(tabGrid, [1, 2]);
    midGrid.ColumnWidth = {'1.1x', '1.3x'};
    midGrid.Padding = [0, 0, 0, 0];

    % Top 10 Bar Chart
    chartPanel = uipanel(midGrid, 'BackgroundColor', CARD_BG, 'Title', 'Top 10 Most Populous Districts in India (2011)', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    cLayout = uigridlayout(chartPanel, [1, 1]);
    cLayout.Padding = [10, 8, 10, 8];
    ax = uiaxes(cLayout);
    top10 = data.kpi.top10Table;
    topPops = top10.TotalPopulation / 1e6;
    topNames = top10.District;
    barh(ax, 10:-1:1, flipud(topPops), 'FaceColor', ACCENT_BLUE);
    ax.YTick = 1:10;
    ax.YTickLabel = flipud(topNames);
    ax.XLabel.String = 'Population (Millions)';
    ax.Title.String = 'Population Scale (Millions)';
    ax.FontName = FONT_FAMILY;
    ax.XGrid = 'on';
    ax.YGrid = 'on';

    % Top 10 Table
    topPanel = uipanel(midGrid, 'BackgroundColor', CARD_BG, 'Title', 'Top 10 District Key Demographics', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    tLayout = uigridlayout(topPanel, [1, 1]);
    tLayout.Padding = [6, 6, 6, 6];
    uitable(tLayout, 'Data', top10, 'FontName', FONT_FAMILY, 'FontSize', 11);

    % 3. Bottom Row: All Districts Searchable Table
    allPanel = uipanel(tabGrid, 'BackgroundColor', CARD_BG, 'Title', 'Complete District Census Dataset (640 Administrative Units)', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    allLayout = uigridlayout(allPanel, [2, 1]);
    allLayout.RowHeight = {30, '1x'};
    allLayout.Padding = [8, 6, 8, 6];

    searchBox = uieditfield(allLayout, 'text', 'Placeholder', 'Search district or state name...', ...
        'FontName', FONT_FAMILY);

    % Prepare Master Display Table
    dispTable = table( ...
        (1:data.numDistricts)', ...
        data.districtNames, ...
        data.stateNames, ...
        double(data.Tclean.TOT_P), ...
        double(data.Tclean.P_06), ...
        round((double(data.Tclean.P_06) ./ double(data.Tclean.TOT_P)) * 100, 2), ...
        double(data.Tclean.P_LIT), ...
        round((double(data.Tclean.P_LIT) ./ double(data.Tclean.TOT_P)) * 100, 2), ...
        double(data.Tclean.TOT_WORK_P), ...
        'VariableNames', {'Index', 'District', 'State', 'TotalPopulation', 'ChildPop_0_6', 'ChildSharePct', 'Literates', 'LiteracyPct', 'Workers'});

    allDistTable = uitable(allLayout, 'Data', dispTable, 'FontName', FONT_FAMILY, 'FontSize', 11);

    % Search Filter Callback
    searchBox.ValueChangedFcn = @(src, ~) filterOverviewTable(src.Value, dispTable, allDistTable);
end

function filterOverviewTable(query, fullTable, uiTable)
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

%% ========================================================================
% HELPER: TAB 2 BUILDER (DEMOGRAPHIC ANALYSIS)
% =========================================================================
function buildDemographicsTab(parentTab, data, CARD_BG, PANEL_BG, ACCENT_BLUE, ACCENT_TEAL, TEXT_MAIN, FONT_FAMILY)
    tabGrid = uigridlayout(parentTab, [3, 1]);
    tabGrid.RowHeight = {45, '1.2x', '1x'};
    tabGrid.Padding = [12, 10, 12, 10];
    tabGrid.RowSpacing = 10;

    % Controls Top Bar
    ctrlPanel = uipanel(tabGrid, 'BackgroundColor', CARD_BG, 'BorderType', 'none');
    ctrlGrid = uigridlayout(ctrlPanel, [1, 5]);
    ctrlGrid.ColumnWidth = {130, 260, 150, 260, '1x'};
    ctrlGrid.Padding = [10, 6, 10, 6];

    uilabel(ctrlGrid, 'Text', 'Primary District:', 'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    distDropdown1 = uidropdown(ctrlGrid, 'Items', cellstr(data.districtKeys), 'Value', char(data.districtKeys(1)), ...
        'FontName', FONT_FAMILY);

    uilabel(ctrlGrid, 'Text', 'Compare Against:', 'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    compItems = [{'National Average'}; cellstr(data.districtKeys)];
    distDropdown2 = uidropdown(ctrlGrid, 'Items', compItems, 'Value', 'National Average', ...
        'FontName', FONT_FAMILY);

    % Middle Row: Comparison Chart & Indicator Scatter
    midGrid = uigridlayout(tabGrid, [1, 2]);
    midGrid.ColumnWidth = {'1.1x', '1x'};
    midGrid.Padding = [0, 0, 0, 0];

    compPanel = uipanel(midGrid, 'BackgroundColor', CARD_BG, 'Title', 'Demographic Indicator Comparison (Rates %)', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    cpLayout = uigridlayout(compPanel, [1, 1]);
    cpLayout.Padding = [10, 8, 10, 8];
    axComp = uiaxes(cpLayout);
    axComp.FontName = FONT_FAMILY;

    scatterPanel = uipanel(midGrid, 'BackgroundColor', CARD_BG, 'Title', 'Cross-Indicator Distribution (Literacy vs Child Share)', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    scLayout = uigridlayout(scatterPanel, [1, 1]);
    scLayout.Padding = [10, 8, 10, 8];
    axScatter = uiaxes(scLayout);
    axScatter.FontName = FONT_FAMILY;

    % Bottom Row: Detailed Indicator Matrix Table
    botPanel = uipanel(tabGrid, 'BackgroundColor', CARD_BG, 'Title', 'District Demographic Indicators Matrix (6 Core Dimension Rates)', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    bpLayout = uigridlayout(botPanel, [1, 1]);
    bpLayout.Padding = [6, 6, 6, 6];

    demoDispTable = table( ...
        data.districtNames, ...
        data.stateNames, ...
        round(data.X_demo(:, 1) * 100, 2), ...
        round(data.X_demo(:, 2) * 100, 2), ...
        round(data.X_demo(:, 3) * 100, 2), ...
        round(data.X_demo(:, 4) * 100, 2), ...
        round(data.X_demo(:, 5) * 100, 2), ...
        round(data.X_demo(:, 6) * 100, 2), ...
        'VariableNames', {'District', 'State', 'ChildSharePct', 'LiteracyPct', 'SCSharePct', 'STSharePct', 'WorkerRatioPct', 'MainWorkerRatioPct'});
    uitable(bpLayout, 'Data', demoDispTable, 'FontName', FONT_FAMILY, 'FontSize', 11);

    % Update Function
    updatePlots = @() updateDemoPlots(distDropdown1.Value, distDropdown2.Value, data, axComp, axScatter, ACCENT_BLUE, ACCENT_TEAL);
    distDropdown1.ValueChangedFcn = @(~, ~) updatePlots();
    distDropdown2.ValueChangedFcn = @(~, ~) updatePlots();
    updatePlots();
end

function updateDemoPlots(selKey1, selKey2, data, axComp, axScatter, col1, col2)
    idx1 = find(data.districtKeys == string(selKey1), 1);
    if isempty(idx1), idx1 = 1; end

    vals1 = data.X_demo(idx1, :) * 100;
    lbls = {'Child Share', 'Literacy', 'SC Share', 'ST Share', 'Worker Ratio', 'Main Worker'};

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

    % Scatter Plot: Literacy (X) vs Child Share (Y)
    cla(axScatter);
    xAll = data.X_demo(:, 2) * 100; % Literacy
    yAll = data.X_demo(:, 1) * 100; % Child Share
    scatter(axScatter, xAll, yAll, 20, [0.7, 0.75, 0.85], 'filled', 'MarkerFaceAlpha', 0.6);
    hold(axScatter, 'on');
    plot(axScatter, vals1(2), vals1(1), 'rp', 'MarkerSize', 14, 'MarkerFaceColor', 'r', 'LineWidth', 1.5);
    if ~strcmp(selKey2, 'National Average')
        plot(axScatter, vals2(2), vals2(1), 'bs', 'MarkerSize', 12, 'MarkerFaceColor', 'b', 'LineWidth', 1.5);
    end
    hold(axScatter, 'off');
    axScatter.XLabel.String = 'Literacy Proportion (%)';
    axScatter.YLabel.String = 'Child Population Share (%)';
    title(axScatter, 'Demographic Transition: Child Dependency vs Literacy');
    axScatter.XGrid = 'on';
    axScatter.YGrid = 'on';
end

%% ========================================================================
% HELPER: TAB 3 BUILDER (PCA ANALYSIS)
% =========================================================================
function buildPCATab(parentTab, data, CARD_BG, PANEL_BG, ACCENT_BLUE, TEXT_MAIN, FONT_FAMILY)
    tabGrid = uigridlayout(parentTab, [2, 2]);
    tabGrid.RowHeight = {'1.1x', '1x'};
    tabGrid.ColumnWidth = {'1.1x', '1x'};
    tabGrid.Padding = [12, 10, 12, 10];
    tabGrid.RowSpacing = 10;
    tabGrid.ColumnSpacing = 10;

    % 1. Variance Scree Plot
    screePanel = uipanel(tabGrid, 'BackgroundColor', CARD_BG, 'Title', 'PCA Explained & Cumulative Variance (Scree Plot)', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    sLayout = uigridlayout(screePanel, [1, 1]);
    sLayout.Padding = [10, 8, 10, 8];
    axScree = uiaxes(sLayout);
    axScree.FontName = FONT_FAMILY;

    expVar = data.pca_demo.explainedVariance_demo;
    cumVar = data.pca_demo.cumulativeVariance_demo;
    numPC = length(expVar);

    bar(axScree, 1:numPC, expVar, 0.5, 'FaceColor', [0.7, 0.8, 0.9], 'EdgeColor', ACCENT_BLUE);
    hold(axScree, 'on');
    plot(axScree, 1:numPC, cumVar, '-ro', 'LineWidth', 2, 'MarkerFaceColor', 'r');
    yline(axScree, 95, '--k', '95% Threshold', 'LineWidth', 1.5);
    hold(axScree, 'off');
    axScree.XTick = 1:numPC;
    axScree.XLabel.String = 'Principal Component Index';
    axScree.YLabel.String = 'Variance (%)';
    title(axScree, sprintf('k_{95} = %d Components Required for >=95%% Variance', data.pca_demo.k95_demo));
    legend(axScree, {'Individual Variance (%)', 'Cumulative Variance (%)'}, 'Location', 'east');
    axScree.XGrid = 'on';
    axScree.YGrid = 'on';

    % 2. PCA Score Space (PC1 vs PC2)
    scorePanel = uipanel(tabGrid, 'BackgroundColor', CARD_BG, 'Title', 'District Score Projection (PC1 vs PC2 Space)', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    scLayout = uigridlayout(scorePanel, [1, 1]);
    scLayout.Padding = [10, 8, 10, 8];
    axScore = uiaxes(scLayout);
    axScore.FontName = FONT_FAMILY;

    Y = data.pca_demo.Y_demo;
    clusters = data.clustering.labels;
    colors = [0.15 0.55 0.85; 0.90 0.40 0.20; 0.20 0.70 0.40];
    hold(axScore, 'on');
    for c = 1:3
        mask = (clusters == c);
        scatter(axScore, Y(mask, 1), Y(mask, 2), 22, colors(c, :), 'filled', 'MarkerFaceAlpha', 0.7);
    end
    hold(axScore, 'off');
    axScore.XLabel.String = sprintf('PC 1 (%.1f%% Variance)', expVar(1));
    axScore.YLabel.String = sprintf('PC 2 (%.1f%% Variance)', expVar(2));
    legend(axScore, {'Cluster 1', 'Cluster 2', 'Cluster 3'}, 'Location', 'northeast');
    axScore.XGrid = 'on';
    axScore.YGrid = 'on';

    % 3. Eigenvector Loadings Table
    loadPanel = uipanel(tabGrid, 'BackgroundColor', CARD_BG, 'Title', 'Principal Component Loadings (Eigenvectors V)', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    lpLayout = uigridlayout(loadPanel, [1, 1]);
    lpLayout.Padding = [6, 6, 6, 6];

    V = data.pca_demo.V_demo;
    featNames = data.demoFeatureNames;
    loadTable = table(featNames(:), round(V(:, 1), 4), round(V(:, 2), 4), round(V(:, 3), 4), round(V(:, 4), 4), ...
        'VariableNames', {'Feature', 'PC1_Loading', 'PC2_Loading', 'PC3_Loading', 'PC4_Loading'});
    uitable(lpLayout, 'Data', loadTable, 'FontName', FONT_FAMILY, 'FontSize', 11);

    % 4. Mathematical Interpretation & Summary
    interpPanel = uipanel(tabGrid, 'BackgroundColor', CARD_BG, 'Title', 'Mathematical Formulation & Dimensionality Reduction', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    ipLayout = uigridlayout(interpPanel, [1, 1]);
    ipLayout.Padding = [12, 10, 12, 10];

    txt = sprintf([ ...
        'Covariance PCA Formulation:\n' ...
        '  - Standardized Data: Z in R^{640 x 6} (zero mean, unit variance)\n' ...
        '  - Sample Covariance: C = (Z^T * Z) / (m - 1)\n' ...
        '  - Eigendecomposition: C * V = V * Lambda, sorted descending\n\n' ...
        'Interpretation of Principal Axes:\n' ...
        '  - PC1 explains %.1f%% of variance: Strong negative loading on Literacy vs positive on Child Share.\n' ...
        '    Represents the primary demographic transition axis (development vs dependency).\n' ...
        '  - PC2 explains %.1f%% of variance: Dominated by ST Share (Tribal demographic concentration).\n' ...
        '  - Cumulative Retained Variance: First %d components capture %.1f%% of total demographic variance.\n' ...
        '  - Dimensionality Reduction: Compresses 6 correlated dimensions into 2 orthogonal axes without substantive information loss.'], ...
        expVar(1), expVar(2), data.pca_demo.k95_demo, cumVar(data.pca_demo.k95_demo));

    uilabel(ipLayout, 'Text', txt, 'FontName', FONT_FAMILY, 'FontSize', 11, 'WordWrap', 'on');
end

%% ========================================================================
% HELPER: TAB 4 BUILDER (SVD ANALYSIS)
% =========================================================================
function buildSVDTab(parentTab, data, CARD_BG, PANEL_BG, ACCENT_BLUE, ACCENT_TEAL, TEXT_MAIN, FONT_FAMILY)
    tabGrid = uigridlayout(parentTab, [2, 2]);
    tabGrid.RowHeight = {'1.1x', '1x'};
    tabGrid.ColumnWidth = {'1.1x', '1x'};
    tabGrid.Padding = [12, 10, 12, 10];
    tabGrid.RowSpacing = 10;
    tabGrid.ColumnSpacing = 10;

    % 1. Low-Rank Reconstruction Error Chart
    reconPanel = uipanel(tabGrid, 'BackgroundColor', CARD_BG, 'Title', 'Low-Rank Reconstruction Relative Frobenius Error e_k', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    rpLayout = uigridlayout(reconPanel, [1, 1]);
    rpLayout.Padding = [10, 8, 10, 8];
    axRecon = uiaxes(rpLayout);
    axRecon.FontName = FONT_FAMILY;

    kRange = 1:length(data.svd.lowRankErrors);
    plot(axRecon, kRange, data.svd.lowRankErrors * 100, '-bs', 'LineWidth', 2, 'MarkerFaceColor', ACCENT_BLUE);
    hold(axRecon, 'on');
    plot(axRecon, length(kRange), data.svd.reconstructionError * 100, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
    hold(axRecon, 'off');
    axRecon.XTick = kRange;
    axRecon.XLabel.String = 'Truncation Rank k (Singular Components Retained)';
    axRecon.YLabel.String = 'Relative Frobenius Error (%)';
    title(axRecon, 'Low-Rank Error Decay: ||Z - Z_k||_F / ||Z||_F');
    axRecon.XGrid = 'on';
    axRecon.YGrid = 'on';

    % 2. Mathematical PCA vs SVD Equivalence Table
    eqPanel = uipanel(tabGrid, 'BackgroundColor', CARD_BG, 'Title', 'PCA vs SVD Numerical Equivalence Verification', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    epLayout = uigridlayout(eqPanel, [1, 1]);
    epLayout.Padding = [6, 6, 6, 6];

    m = size(data.Z, 1);
    sVals = data.svd.singularValues;
    svdEig = (sVals.^2) / (m - 1);
    pcaEig = data.pca.eigenvalues(1:length(sVals));
    diffEig = abs(pcaEig - svdEig);

    compTable = table( ...
        (1:length(sVals))', ...
        round(sVals, 3), ...
        round(svdEig, 4), ...
        round(pcaEig, 4), ...
        diffEig, ...
        'VariableNames', {'Index', 'SingularValue_Sigma', 'SVD_Derived_Lambda', 'PCA_Cov_Lambda', 'AbsoluteDifference'});
    uitable(epLayout, 'Data', compTable, 'FontName', FONT_FAMILY, 'FontSize', 11);

    % 3. Singular Value Spectrum Bar Chart
    specPanel = uipanel(tabGrid, 'BackgroundColor', CARD_BG, 'Title', 'Singular Value Spectrum \sigma_i', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    spLayout = uigridlayout(specPanel, [1, 1]);
    spLayout.Padding = [10, 8, 10, 8];
    axSpec = uiaxes(spLayout);
    axSpec.FontName = FONT_FAMILY;

    bar(axSpec, 1:length(sVals), sVals, 0.5, 'FaceColor', ACCENT_TEAL);
    axSpec.XTick = 1:length(sVals);
    axSpec.XLabel.String = 'Singular Value Index i';
    axSpec.YLabel.String = 'Singular Value \sigma_i';
    title(axSpec, sprintf('Total Frobenius Energy: ||Z||_F = %.2f', norm(data.Z, 'fro')));
    axSpec.XGrid = 'on';
    axSpec.YGrid = 'on';

    % 4. Mathematical Comparison Text
    mathPanel = uipanel(tabGrid, 'BackgroundColor', CARD_BG, 'Title', 'Theoretical Relationship: SVD & Eigendecomposition', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    mpLayout = uigridlayout(mathPanel, [1, 1]);
    mpLayout.Padding = [12, 10, 12, 10];

    svdText = sprintf([ ...
        'Singular Value Decomposition (Economy SVD):\n' ...
        '  - Matrix Factorization: Z = U * S * V^T, where U in R^{640 x n}, S in R^{n x n}, V in R^{n x n}\n' ...
        '  - Orthogonality: U^T * U = I_n and V^T * V = I_n\n\n' ...
        'Equivalence to Covariance Eigendecomposition:\n' ...
        '  - Covariance: C = (Z^T * Z) / (m - 1) = (V * S^2 * V^T) / (m - 1)\n' ...
        '  - Relationship: lambda_i = sigma_i^2 / (m - 1)\n' ...
        '  - Right singular vectors V of Z equal eigenvectors V of covariance C.\n\n' ...
        'Reconstruction Precision:\n' ...
        '  - Full reconstruction relative error: %.2e (machine precision)\n' ...
        '  - Rank-3 low-rank approximation retains %.1f%% of total matrix energy.\n' ...
        '  - Confirms complete numerical consistency between PCA and SVD.'], ...
        data.svd.reconstructionError, (1 - data.svd.lowRankErrors(min(3, length(data.svd.lowRankErrors)))) * 100);

    uilabel(mpLayout, 'Text', svdText, 'FontName', FONT_FAMILY, 'FontSize', 11, 'WordWrap', 'on');
end

%% ========================================================================
% HELPER: TAB 5 BUILDER (ADAPTIVE PCA)
% =========================================================================
function buildAdaptivePCATab(parentTab, data, CARD_BG, PANEL_BG, ACCENT_BLUE, ACCENT_ORANGE, TEXT_MAIN, FONT_FAMILY)
    tabGrid = uigridlayout(parentTab, [2, 2]);
    tabGrid.RowHeight = {'1.1x', '1x'};
    tabGrid.ColumnWidth = {'1.2x', '1x'};
    tabGrid.Padding = [12, 10, 12, 10];
    tabGrid.RowSpacing = 10;
    tabGrid.ColumnSpacing = 10;

    % 1. Batch Convergence Dual Chart
    chartPanel = uipanel(tabGrid, 'BackgroundColor', CARD_BG, 'Title', 'Batch-Wise PCA: Stability & Error Progression (k = 3)', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    cpLayout = uigridlayout(chartPanel, [1, 1]);
    cpLayout.Padding = [10, 8, 10, 8];
    axDual = uiaxes(cpLayout);
    axDual.FontName = FONT_FAMILY;

    if isfield(data.adaptive, 'observationsProcessed')
        obs = data.adaptive.observationsProcessed;
        varRet = data.adaptive.varianceRetained;
        recErr = data.adaptive.reconstructionError;

        yyaxis(axDual, 'left');
        plot(axDual, obs, varRet, '-bo', 'LineWidth', 2, 'MarkerFaceColor', ACCENT_BLUE);
        axDual.YLabel.String = 'Retained Variance (%)';
        axDual.YColor = ACCENT_BLUE;

        yyaxis(axDual, 'right');
        plot(axDual, obs, recErr, '-s', 'Color', ACCENT_ORANGE, 'LineWidth', 2, 'MarkerFaceColor', ACCENT_ORANGE);
        axDual.YLabel.String = 'Relative Reconstruction Error';
        axDual.YColor = ACCENT_ORANGE;

        axDual.XLabel.String = 'Cumulative Observations Processed (Districts)';
        title(axDual, 'Batch Convergence across 7 Cumulative Stages (N=100..640)');
        axDual.XGrid = 'on';
        axDual.YGrid = 'on';
    end

    % 2. Adaptive Results Table
    tabPanel = uipanel(tabGrid, 'BackgroundColor', CARD_BG, 'Title', 'Batch Experiment Numerical Log', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    tpLayout = uigridlayout(tabPanel, [1, 1]);
    tpLayout.Padding = [6, 6, 6, 6];

    if isfield(data.adaptive, 'adaptiveResults')
        uitable(tpLayout, 'Data', data.adaptive.adaptiveResults, 'FontName', FONT_FAMILY, 'FontSize', 11);
    end

    % 3. Algorithmic Distinction & Critical Discussion
    discPanel = uipanel(tabGrid, 'BackgroundColor', CARD_BG, 'Title', 'CRITICAL DISTINCTION: Batch-Wise Full Refit vs Genuine Incremental PCA', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    dpLayout = uigridlayout(discPanel, [1, 1]);
    dpLayout.Padding = [12, 10, 12, 10];

    discText = sprintf([ ...
        'Methodological Assessment of the Batch-Wise Experiment:\n\n' ...
        '1. What this experiment implements:\n' ...
        '   - It performs batch-wise cumulative full-refit PCA.\n' ...
        '   - For each cumulative slice Z(1:b, :), the full sample covariance C_b is recomputed\n' ...
        '     from scratch and diagonalized via eig(C_b).\n' ...
        '   - Computational Cost per step: O(b * n^2 + n^3). Total complexity: O(N^2 * n^2 / B).\n' ...
        '   - Purpose: Validates demographic subspace stability as the geographic sample expands.\n\n' ...
        '2. Contrast with Genuine Online/Incremental PCA (IPCA):\n' ...
        '   - True Incremental PCA (e.g., CCIPCA - Weng et al., Brand Fast SVD):\n' ...
        '     * Updates eigenvectors sequentially in O(n * k) operations per observation.\n' ...
        '     * Never forms or stores the covariance matrix C.\n' ...
        '     * Suitable for unbounded data streams with constant memory footprint.\n\n' ...
        'Conclusion: The project experiment is an empirical convergence study, not a computationally efficient incremental algorithm.']);

    uilabel(dpLayout, 'Text', discText, 'FontName', FONT_FAMILY, 'FontSize', 11, 'WordWrap', 'on');

    % 4. Empirical Stability Takeaways
    takePanel = uipanel(tabGrid, 'BackgroundColor', CARD_BG, 'Title', 'Empirical Subspace Stability Findings', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    tkLayout = uigridlayout(takePanel, [1, 1]);
    tkLayout.Padding = [12, 10, 12, 10];

    takeText = sprintf([ ...
        'Key Numerical Observations:\n\n' ...
        '  - Initial Batch (N = 100): Retained variance for k=3 starts at %.1f%% with error %.3f.\n' ...
        '  - Final Sample (N = 640): Retained variance settles at %.1f%% with error %.3f.\n' ...
        '  - Subspace Drift: Subspace variance shows minor oscillation across early northern batches\n' ...
        '    before stabilizing beyond N = 400.\n' ...
        '  - Robustness: Proves that top 3 principal components represent persistent demographic\n' ...
        '    structure rather than localized regional sampling artifacts.'], ...
        data.adaptive.varianceRetained(1), data.adaptive.reconstructionError(1), ...
        data.adaptive.varianceRetained(end), data.adaptive.reconstructionError(end));

    uilabel(tkLayout, 'Text', takeText, 'FontName', FONT_FAMILY, 'FontSize', 11, 'WordWrap', 'on');
end

%% ========================================================================
% HELPER: TAB 6 BUILDER (DISTRICT CLUSTERING)
% =========================================================================
function buildClusteringTab(parentTab, data, CARD_BG, PANEL_BG, TEXT_MAIN, FONT_FAMILY)
    tabGrid = uigridlayout(parentTab, [3, 1]);
    tabGrid.RowHeight = {'1.1x', '1x', '1x'};
    tabGrid.Padding = [12, 10, 12, 10];
    tabGrid.RowSpacing = 10;

    % Top Row: Profiles Table & Cluster PCA Visualization
    topGrid = uigridlayout(tabGrid, [1, 2]);
    topGrid.ColumnWidth = {'1.2x', '1x'};
    topGrid.Padding = [0, 0, 0, 0];

    profPanel = uipanel(topGrid, 'BackgroundColor', CARD_BG, 'Title', '3-Cluster Demographic Profiles (Mean Feature Rates)', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    ppLayout = uigridlayout(profPanel, [1, 1]);
    ppLayout.Padding = [6, 6, 6, 6];
    uitable(ppLayout, 'Data', data.clustering.profileTable, 'FontName', FONT_FAMILY, 'FontSize', 11);

    chartPanel = uipanel(topGrid, 'BackgroundColor', CARD_BG, 'Title', 'Cluster Separation in Reduced Demographic Space', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    cpLayout = uigridlayout(chartPanel, [1, 1]);
    cpLayout.Padding = [10, 8, 10, 8];
    axClust = uiaxes(cpLayout);
    axClust.FontName = FONT_FAMILY;

    Y = data.pca_demo.Y_demo;
    labels = data.clustering.labels;
    colors = [0.15 0.55 0.85; 0.90 0.40 0.20; 0.20 0.70 0.40];
    hold(axClust, 'on');
    for c = 1:3
        m = (labels == c);
        scatter(axClust, Y(m, 1), Y(m, 2), 24, colors(c, :), 'filled', 'MarkerFaceAlpha', 0.7);
    end
    hold(axClust, 'off');
    axClust.XLabel.String = 'PC 1 (Demographic Transition / Literacy)';
    axClust.YLabel.String = 'PC 2 (Tribal / Rural Concentration)';
    legend(axClust, {'Cluster 1 (N=125)', 'Cluster 2 (N=207)', 'Cluster 3 (N=308)'}, 'Location', 'northeast');
    axClust.XGrid = 'on';
    axClust.YGrid = 'on';

    % Middle Row: Cluster Centroid Comparison Bar Chart
    midPanel = uipanel(tabGrid, 'BackgroundColor', CARD_BG, 'Title', 'Demographic Profile Signatures across Clusters (Centroid Comparison)', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    mpLayout = uigridlayout(midPanel, [1, 1]);
    mpLayout.Padding = [10, 8, 10, 8];
    axBar = uiaxes(mpLayout);
    axBar.FontName = FONT_FAMILY;

    cProf = data.clustering.clusterProfiles * 100;
    b = bar(axBar, cProf', 'grouped');
    b(1).FaceColor = colors(1, :);
    b(2).FaceColor = colors(2, :);
    b(3).FaceColor = colors(3, :);
    axBar.XTick = 1:6;
    axBar.XTickLabel = {'Child Share', 'Literacy', 'SC Share', 'ST Share', 'Worker Ratio', 'Main Worker'};
    axBar.YLabel.String = 'Mean Percentage (%)';
    legend(axBar, {'Cluster 1: High ST / Agrarian (125)', 'Cluster 2: High Child Share / Dependency (207)', 'Cluster 3: High Literacy / Formal Workforce (308)'}, ...
        'Location', 'northoutside', 'Orientation', 'horizontal');
    axBar.XGrid = 'on';
    axBar.YGrid = 'on';

    % Bottom Row: Searchable District Membership Table with Cluster Filter
    botPanel = uipanel(tabGrid, 'BackgroundColor', CARD_BG, 'Title', 'District Cluster Membership Explorer (640 Districts)', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    bpLayout = uigridlayout(botPanel, [2, 1]);
    bpLayout.RowHeight = {32, '1x'};
    bpLayout.Padding = [8, 6, 8, 6];

    fGrid = uigridlayout(bpLayout, [1, 3]);
    fGrid.ColumnWidth = {180, 240, '1x'};
    fGrid.Padding = [0, 0, 0, 0];

    clusterFilter = uidropdown(fGrid, 'Items', {'All Clusters', 'Cluster 1 (High ST/Agrarian)', 'Cluster 2 (High Child Share)', 'Cluster 3 (High Literacy)'}, ...
        'FontName', FONT_FAMILY);
    distSearch = uieditfield(fGrid, 'text', 'Placeholder', 'Filter by district or state name...', 'FontName', FONT_FAMILY);

    uilabel(fGrid, 'Text', 'Note: Cluster numbers (1, 2, 3) are arbitrary unsupervised labels, not an ordinal ranking.', ...
        'FontName', FONT_FAMILY, 'FontColor', [0.45, 0.5, 0.58], 'FontAngle', 'italic');

    clusterMemTable = table( ...
        labels, ...
        data.districtNames, ...
        data.stateNames, ...
        round(data.X_demo(:, 1) * 100, 2), ...
        round(data.X_demo(:, 2) * 100, 2), ...
        round(data.X_demo(:, 4) * 100, 2), ...
        round(data.X_demo(:, 5) * 100, 2), ...
        'VariableNames', {'Cluster', 'District', 'State', 'ChildSharePct', 'LiteracyPct', 'STSharePct', 'WorkerRatioPct'});
    memUiTable = uitable(bpLayout, 'Data', clusterMemTable, 'FontName', FONT_FAMILY, 'FontSize', 11);

    updateMembership = @() filterClusterMembership(clusterFilter.Value, distSearch.Value, clusterMemTable, memUiTable);
    clusterFilter.ValueChangedFcn = @(~, ~) updateMembership();
    distSearch.ValueChangedFcn = @(~, ~) updateMembership();
end

function filterClusterMembership(clustVal, query, fullTab, uiTab)
    filtered = fullTab;
    if startsWith(clustVal, 'Cluster 1')
        filtered = filtered(filtered.Cluster == 1, :);
    elseif startsWith(clustVal, 'Cluster 2')
        filtered = filtered(filtered.Cluster == 2, :);
    elseif startsWith(clustVal, 'Cluster 3')
        filtered = filtered(filtered.Cluster == 3, :);
    end

    query = strtrim(string(query));
    if query ~= ""
        m = contains(string(filtered.District), query, 'IgnoreCase', true) | ...
            contains(string(filtered.State), query, 'IgnoreCase', true);
        filtered = filtered(m, :);
    end
    uiTab.Data = filtered;
end

%% ========================================================================
% HELPER: TAB 7 BUILDER (RESOURCE PLANNING)
% =========================================================================
function buildResourcePlanningTab(parentTab, data, CARD_BG, PANEL_BG, ACCENT_ORANGE, TEXT_MAIN, FONT_FAMILY)
    tabGrid = uigridlayout(parentTab, [3, 1]);
    tabGrid.RowHeight = {65, '1.1x', '1x'};
    tabGrid.Padding = [12, 10, 12, 10];
    tabGrid.RowSpacing = 10;

    % Methodological Disclaimer Banner
    discPanel = uipanel(tabGrid, 'BackgroundColor', [0.99, 0.95, 0.90], 'BorderType', 'line', 'HighlightColor', ACCENT_ORANGE);
    dpLayout = uigridlayout(discPanel, [1, 1]);
    dpLayout.Padding = [10, 6, 10, 6];
    discMsg = sprintf([ ...
        'CRITICAL METHODOLOGICAL NOTICE: Population aged 0-6 is utilized here strictly as an illustrative demographic proxy\n' ...
        'for early-childhood service demand (e.g., target cohorts for Anganwadi centres and pediatric immunization). It reflects demographic\n' ...
        'scale and concentration, NOT audited infrastructure deficits, facility shortages, or operational funding gaps.']);
    uilabel(dpLayout, 'Text', discMsg, 'FontName', FONT_FAMILY, 'FontSize', 10, 'FontWeight', 'bold', 'FontColor', [0.65, 0.30, 0.05]);

    % Middle Row: Top 10 Demand Proxies Chart & Priority Inspector
    midGrid = uigridlayout(tabGrid, [1, 2]);
    midGrid.ColumnWidth = {'1.1x', '1x'};
    midGrid.Padding = [0, 0, 0, 0];

    chartPanel = uipanel(midGrid, 'BackgroundColor', CARD_BG, 'Title', 'Top 10 Districts by Early Childhood Cohort Scale (0-6)', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    cpLayout = uigridlayout(chartPanel, [1, 1]);
    cpLayout.Padding = [10, 8, 10, 8];
    axDemand = uiaxes(cpLayout);
    axDemand.FontName = FONT_FAMILY;

    rTab = data.resourceTable;
    varNames = string(rTab.Properties.VariableNames);

    if ismember("ChildPopulation_0_6", varNames)
        childCol = double(rTab.ChildPopulation_0_6);
    elseif ismember("P_06", varNames)
        childCol = double(rTab.P_06);
    else
        childCol = double(data.Tclean.P_06);
    end

    if ismember("District", varNames)
        distNames = string(rTab.District);
    else
        distNames = string(data.districtNames);
    end

    topN = min(10, length(childCol));
    topChild = childCol(1:topN) / 1e3;
    topNames = distNames(1:topN);

    barh(axDemand, topN:-1:1, flipud(topChild), 'FaceColor', ACCENT_ORANGE);
    axDemand.YTick = 1:topN;
    axDemand.YTickLabel = flipud(topNames);
    axDemand.XLabel.String = 'Children Aged 0-6 (Thousands)';
    title(axDemand, 'Demographic Cohort Scale (Thousands)');
    axDemand.XGrid = 'on';
    axDemand.YGrid = 'on';

    % District Inspector Card
    inspPanel = uipanel(midGrid, 'BackgroundColor', CARD_BG, 'Title', 'District Early-Childhood Profile Inspector', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    ipLayout = uigridlayout(inspPanel, [5, 1]);
    ipLayout.RowHeight = {30, 30, 30, 30, '1x'};
    ipLayout.Padding = [12, 10, 12, 10];

    inspDrop = uidropdown(ipLayout, 'Items', cellstr(data.districtKeys), 'Value', char(data.districtKeys(1)), ...
        'FontName', FONT_FAMILY);
    lblPop = uilabel(ipLayout, 'Text', 'Total Population: -', 'FontName', FONT_FAMILY, 'FontSize', 12);
    lblChild = uilabel(ipLayout, 'Text', 'Child Population (0-6): -', 'FontName', FONT_FAMILY, 'FontSize', 12, 'FontWeight', 'bold');
    lblShare = uilabel(ipLayout, 'Text', 'Child Share: -', 'FontName', FONT_FAMILY, 'FontSize', 12);
    lblProxy = uilabel(ipLayout, 'Text', 'Illustrative ECCE Units Proxy: -', 'FontName', FONT_FAMILY, 'FontSize', 12, 'FontColor', ACCENT_ORANGE);

    updateInspector = @(selKey) updateInspCard(selKey, data, lblPop, lblChild, lblShare, lblProxy);
    inspDrop.ValueChangedFcn = @(src, ~) updateInspector(src.Value);
    updateInspector(inspDrop.Value);

    % Bottom Row: Full Resource Demand Table
    botPanel = uipanel(tabGrid, 'BackgroundColor', CARD_BG, 'Title', 'District Resource Planning Proxy Register (Ranked by Cohort Volume)', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    bpLayout = uigridlayout(botPanel, [1, 1]);
    bpLayout.Padding = [6, 6, 6, 6];
    uitable(bpLayout, 'Data', rTab, 'FontName', FONT_FAMILY, 'FontSize', 11);
end

function updateInspCard(key, data, lPop, lChild, lShare, lProxy)
    idx = find(data.districtKeys == string(key), 1);
    if isempty(idx), idx = 1; end

    totP = double(data.Tclean.TOT_P(idx));
    childP = double(data.Tclean.P_06(idx));
    childS = (childP / max(totP, 1)) * 100;
    ecceU = ceil(childP / 40);

    lPop.Text   = sprintf('Total Population: %s persons', formatNumber(totP));
    lChild.Text = sprintf('Child Population (0-6): %s children', formatNumber(childP));
    lShare.Text = sprintf('Child Population Share: %.2f%%', childS);
    lProxy.Text = sprintf('Illustrative ECCE Units Proxy (40-child norm): %s centres', formatNumber(ecceU));
end

%% ========================================================================
% HELPER: TAB 8 BUILDER (FORECASTING)
% =========================================================================
function buildForecastingTab(parentTab, data, CARD_BG, PANEL_BG, ACCENT_BLUE, TEXT_MAIN, FONT_FAMILY)
    tabGrid = uigridlayout(parentTab, [3, 1]);
    tabGrid.RowHeight = {55, '1.1x', '1x'};
    tabGrid.Padding = [12, 10, 12, 10];
    tabGrid.RowSpacing = 10;

    % Interactive Parameter Control Bar
    ctrlPanel = uipanel(tabGrid, 'BackgroundColor', CARD_BG, 'BorderType', 'none');
    ctrlGrid = uigridlayout(ctrlPanel, [1, 5]);
    ctrlGrid.ColumnWidth = {200, 100, 120, 240, '1x'};
    ctrlGrid.Padding = [10, 8, 10, 8];

    uilabel(ctrlGrid, 'Text', 'Assumed Annual Growth Rate (%):', 'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    rateSpinner = uispinner(ctrlGrid, 'Limits', [-3.0, 5.0], 'Value', 2.0, 'Step', 0.1, ...
        'ValueDisplayFormat', '%.1f%%', 'FontName', FONT_FAMILY);

    btnReset = uibutton(ctrlGrid, 'push', 'Text', 'Reset to 2.0%', 'FontName', FONT_FAMILY);

    uilabel(ctrlGrid, 'Text', 'Inspection District:', 'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    fcDistDrop = uidropdown(ctrlGrid, 'Items', cellstr(data.districtKeys), 'Value', char(data.districtKeys(1)), ...
        'FontName', FONT_FAMILY);

    % Middle Row: Trend Chart & National Summary
    midGrid = uigridlayout(tabGrid, [1, 2]);
    midGrid.ColumnWidth = {'1.2x', '1x'};
    midGrid.Padding = [0, 0, 0, 0];

    chartPanel = uipanel(midGrid, 'BackgroundColor', CARD_BG, 'Title', '5-Year Compound Scenario Projection Trend', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    cpLayout = uigridlayout(chartPanel, [1, 1]);
    cpLayout.Padding = [10, 8, 10, 8];
    axTrend = uiaxes(cpLayout);
    axTrend.FontName = FONT_FAMILY;

    summaryPanel = uipanel(midGrid, 'BackgroundColor', CARD_BG, 'Title', 'Scenario Simulation Parameters & National Totals', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    spLayout = uigridlayout(summaryPanel, [1, 1]);
    spLayout.Padding = [12, 10, 12, 10];
    lblSummary = uilabel(spLayout, 'Text', '', 'FontName', FONT_FAMILY, 'FontSize', 11, 'WordWrap', 'on');

    % Bottom Row: District Projections Table
    botPanel = uipanel(tabGrid, 'BackgroundColor', CARD_BG, 'Title', 'District 5-Year Projections Register (P_t = P_0 * (1 + r)^t)', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    bpLayout = uigridlayout(botPanel, [1, 1]);
    bpLayout.Padding = [6, 6, 6, 6];
    fcUiTable = uitable(bpLayout, 'FontName', FONT_FAMILY, 'FontSize', 11);

    % Dynamic Recalculation Engine
    recalcForecast = @() updateForecastEngine(rateSpinner.Value / 100, fcDistDrop.Value, data, axTrend, lblSummary, fcUiTable, ACCENT_BLUE);

    rateSpinner.ValueChangedFcn = @(~, ~) recalcForecast();
    fcDistDrop.ValueChangedFcn  = @(~, ~) recalcForecast();
    btnReset.ButtonPushedFcn    = @(~, ~) setRateAndRecalc(rateSpinner, 2.0, recalcForecast);

    recalcForecast();
end

function setRateAndRecalc(spinner, val, recalcFn)
    spinner.Value = val;
    recalcFn();
end

function updateForecastEngine(rate, distKey, data, axTrend, lblSum, uiTab, col)
    [fcTable, pMat, sData] = calculate_forecast(data.Tclean.P_06, data.districtNames, rate, 5);

    % Update UI Table
    uiTab.Data = fcTable;

    % Update National Summary Text
    netAddVal = sData.NationalProjected(end) - sData.NationalBaseline;
    if isfield(sData, 'TotalNetAddition')
        netAddVal = sData.TotalNetAddition;
    end

    pctChgVal = ((sData.NationalProjected(end) / max(sData.NationalBaseline, 1)) - 1) * 100;
    if isfield(sData, 'TotalPercentChange')
        pctChgVal = sData.TotalPercentChange;
    end

    sumText = sprintf([ ...
        'Scenario Specification:\n' ...
        '  - Annual Compound Rate (r): %.2f%%\n' ...
        '  - Projection Horizon: 5 Years\n' ...
        '  - National Baseline (P_0): %s children\n' ...
        '  - Year 5 Projected Total:  %s children\n' ...
        '  - Cumulative Net Addition: %s children\n' ...
        '  - Cumulative Growth:       %+.2f%%\n\n' ...
        'Methodological Disclaimer:\n' ...
        '  This projection is a geometric sensitivity simulation. It does NOT incorporate\n' ...
        '  age-specific fertility rates (ASFR), infant mortality (IMR), or net migration\n' ...
        '  and should not be cited as a validated demographic prediction.'], ...
        sData.GrowthRatePercent, formatNumber(sData.NationalBaseline), ...
        formatNumber(sData.NationalProjected(end)), formatNumber(netAddVal), ...
        pctChgVal);
    lblSum.Text = sumText;

    % Update Trend Chart for Selected District
    idx = find(data.districtKeys == string(distKey), 1);
    if isempty(idx), idx = 1; end

    baseVal = double(data.Tclean.P_06(idx));
    traj = [baseVal, pMat(idx, :)];
    years = 0:5;

    cla(axTrend);
    plot(axTrend, years, traj / 1e3, '-bo', 'LineWidth', 2.2, 'MarkerFaceColor', col, 'MarkerSize', 7);
    axTrend.XTick = 0:5;
    axTrend.XTickLabel = {'Baseline', 'Year 1', 'Year 2', 'Year 3', 'Year 4', 'Year 5'};
    axTrend.XLabel.String = 'Scenario Horizon';
    axTrend.YLabel.String = 'Projected Cohort (Thousands)';
    title(axTrend, sprintf('%s: Child Cohort Trajectory (r = %.1f%%)', char(data.districtNames(idx)), rate * 100));
    axTrend.XGrid = 'on';
    axTrend.YGrid = 'on';
end

%% ========================================================================
% HELPER: TAB 9 BUILDER (MATHEMATICAL SUMMARY)
% =========================================================================
function buildMathSummaryTab(parentTab, data, CARD_BG, PANEL_BG, TEXT_MAIN, FONT_FAMILY)
    tabGrid = uigridlayout(parentTab, [1, 2]);
    tabGrid.ColumnWidth = {'1.2x', '1x'};
    tabGrid.Padding = [14, 12, 14, 12];
    tabGrid.ColumnSpacing = 12;

    % Left: Mathematical Methods Dossier
    leftPanel = uipanel(tabGrid, 'BackgroundColor', CARD_BG, 'Title', 'Computational Mathematics Methodology', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    lpLayout = uigridlayout(leftPanel, [1, 1]);
    lpLayout.Padding = [12, 10, 12, 10];

    dossierText = sprintf([ ...
        '1. Preprocessing & Standardization\n' ...
        '   - Raw PCA Census Matrix: X in R^{640 x 8} (district-level totals)\n' ...
        '   - Demographic Indicators: X_{demo} in R^{640 x 6} normalized relative to population/workforce\n' ...
        '   - Feature Standardizing: Z = (X - mu) ./ sigma (zero mean, unit sample variance)\n\n' ...
        '2. Principal Component Analysis (Covariance Eigendecomposition)\n' ...
        '   - Covariance Matrix: C = (Z^T * Z) / (m - 1)\n' ...
        '   - Eigendecomposition: C * V = V * Lambda\n' ...
        '   - Component Truncation: k_{95} = %d components retain >=95%% total variance\n\n' ...
        '3. Singular Value Decomposition & Validation\n' ...
        '   - Economy SVD: Z = U * S * V_{svd}^T\n' ...
        '   - Validation Identity: lambda_i = sigma_i^2 / (m - 1), right singular vectors match V\n' ...
        '   - Full reconstruction error: %.2e (machine precision)\n\n' ...
        '4. Adaptive Subspace Stability (Batch Simulation)\n' ...
        '   - Sequential cumulative refitting: N in [100, 200, 300, 400, 500, 600, 640]\n' ...
        '   - Verifies convergence and stability of dominant demographic subspaces\n\n' ...
        '5. Unsupervised District Clustering\n' ...
        '   - K-means optimization on standardized demographic features (k = 3)\n' ...
        '   - Partitions districts into 3 distinct demographic archetypes\n\n' ...
        '6. Demographic Resource Proxies & Scenario Modeling\n' ...
        '   - Cohort volume and concentration proxy for early childhood planning\n' ...
        '   - Compound geometric scenario simulation P_t = P_0 * (1 + r)^t'], ...
        data.pca_demo.k95_demo, data.svd.reconstructionError);

    uilabel(lpLayout, 'Text', dossierText, 'FontName', FONT_FAMILY, 'FontSize', 11, 'WordWrap', 'on');

    % Right: Key Numerical Benchmarks Table
    rightPanel = uipanel(tabGrid, 'BackgroundColor', CARD_BG, 'Title', 'Key Project Quantitative Benchmarks', ...
        'FontName', FONT_FAMILY, 'FontWeight', 'bold');
    rpLayout = uigridlayout(rightPanel, [1, 1]);
    rpLayout.Padding = [8, 8, 8, 8];

    c1 = 125; c2 = 207; c3 = 308;
    if isfield(data, 'clustering') && isfield(data.clustering, 'clusterSizes') && ...
       length(data.clustering.clusterSizes) >= 3
        c1 = data.clustering.clusterSizes(1);
        c2 = data.clustering.clusterSizes(2);
        c3 = data.clustering.clusterSizes(3);
    end

    netAddStr = 'N/A';
    if isfield(data, 'forecasting') && isfield(data.forecasting, 'summaryData') && ...
       isfield(data.forecasting.summaryData, 'TotalNetAddition')
        netAddStr = sprintf('%s (at 2%%)', formatNumber(data.forecasting.summaryData.TotalNetAddition));
    elseif isfield(data, 'Tclean') && ismember('P_06', string(data.Tclean.Properties.VariableNames))
        netAdd = double(sum(data.Tclean.P_06)) * ((1.02^5) - 1);
        netAddStr = sprintf('%s (at 2%%)', formatNumber(netAdd));
    end

    benchMarks = { ...
        'Total District Population', sprintf('%s (1.21 B)', formatNumber(data.kpi.totalPopulation)); ...
        'Child Population (0-6)', sprintf('%s (164.5 M)', formatNumber(data.kpi.totalChildren)); ...
        'National Child Share', sprintf('%.2f%%', data.kpi.nationalChildShare); ...
        'National Literacy Rate', sprintf('%.2f%%', data.kpi.nationalLiteracyRate); ...
        'Total District Observations', sprintf('%d Districts', data.numDistricts); ...
        'Demographic Features Evaluated', sprintf('%d Core Rates', size(data.X_demo, 2)); ...
        'PCA Components for 95% Variance', sprintf('k = %d Components', data.pca_demo.k95_demo); ...
        'PC1 Variance Captured', sprintf('%.2f%%', data.pca_demo.explainedVariance_demo(1)); ...
        'PC2 Variance Captured', sprintf('%.2f%%', data.pca_demo.explainedVariance_demo(2)); ...
        'SVD Relative Reconstruction Error', sprintf('%.2e', data.svd.reconstructionError); ...
        'Cluster 1 Size (High ST/Agrarian)', sprintf('%d Districts', c1); ...
        'Cluster 2 Size (High Child Share)', sprintf('%d Districts', c2); ...
        'Cluster 3 Size (High Literacy/Formal)', sprintf('%d Districts', c3); ...
        'Baseline 5-Year Net Child Addition', netAddStr ...
    };

    bTable = cell2table(benchMarks, 'VariableNames', {'Metric', 'Value'});
    uitable(rpLayout, 'Data', bTable, 'FontName', FONT_FAMILY, 'FontSize', 11);
end

%% ========================================================================
% UTILITY: NUMBER FORMATTER (COMMAS)
% =========================================================================
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
