classdef CensusLensAppCallbacks
% CENSUSLENSAPPCALLBACKS Modular callback handler for MATLAB App Designer
%
% This class provides callback logic for integrating with CensusLensApp.mlapp
% (Option 1). It decouples UI event handling from the visual layout, allowing
% App Designer buttons, dropdowns, spinners, and tabs to call tested methods.
%
% Example App Designer Usage in Code View:
%   methods (Access = private)
%       function StartupFcn(app)
%           app.Data = load_project_data();
%           CensusLensAppCallbacks.populateOverview(app);
%       end
%
%       function DistrictDropDownValueChanged(app, event)
%           CensusLensAppCallbacks.updateDistrictComparison(app);
%       end
%
%       function GrowthRateSpinnerValueChanged(app, event)
%           CensusLensAppCallbacks.updateForecastScenario(app);
%       end
%   end

    methods (Static)

        function populateOverview(app)
            % Populates Overview Tab metrics and tables in App Designer
            data = app.Data;
            if isprop(app, 'TotalPopLabel')
                app.TotalPopLabel.Text = sprintf('%.2f Billion', data.kpi.totalPopulation / 1e9);
            end
            if isprop(app, 'ChildPopLabel')
                app.ChildPopLabel.Text = sprintf('%.2f Million', data.kpi.totalChildren / 1e6);
            end
            if isprop(app, 'ChildShareLabel')
                app.ChildShareLabel.Text = sprintf('%.2f%%', data.kpi.nationalChildShare);
            end
            if isprop(app, 'Top10Table')
                app.Top10Table.Data = data.kpi.top10Table;
            end
        end

        function updateDistrictComparison(app)
            % Updates Demographic comparison when district selection changes
            data = app.Data;
            if ~isprop(app, 'DistrictDropDown') || ~isprop(app, 'CompAxes')
                return;
            end
            selDistrict = string(app.DistrictDropDown.Value);
            idx = find(data.districtKeys == selDistrict, 1);
            if isempty(idx), idx = 1; end

            vals1 = data.X_demo(idx, :) * 100;
            valsNat = mean(data.X_demo, 1) * 100;

            cla(app.CompAxes);
            b = bar(app.CompAxes, [vals1; valsNat]', 'grouped');
            app.CompAxes.XTick = 1:6;
            app.CompAxes.XTickLabel = {'Child', 'Lit', 'SC', 'ST', 'Work', 'Main'};
            app.CompAxes.YLabel.String = 'Rate (%)';
            legend(app.CompAxes, {char(data.districtNames(idx)), 'National Mean'}, 'Location', 'northoutside');
        end

        function updateForecastScenario(app)
            % Dynamic forecasting update when growth rate spinner changes
            data = app.Data;
            if ~isprop(app, 'GrowthRateSpinner') || ~isprop(app, 'ForecastTable')
                return;
            end
            rate = app.GrowthRateSpinner.Value / 100;
            [fcTab, ~, ~] = calculate_forecast(data.Tclean.P_06, data.districtNames, rate, 5);
            app.ForecastTable.Data = fcTab;
        end

        function plotPCA(app)
            % Renders PCA Score Plot in App Designer
            data = app.Data;
            if ~isprop(app, 'PCAAxes'), return; end
            cla(app.PCAAxes);
            Y = data.pca_demo.Y_demo;
            labels = data.clustering.labels;
            colors = [0.15 0.55 0.85; 0.90 0.40 0.20; 0.20 0.70 0.40];
            hold(app.PCAAxes, 'on');
            for c = 1:3
                m = (labels == c);
                scatter(app.PCAAxes, Y(m, 1), Y(m, 2), 20, colors(c, :), 'filled');
            end
            hold(app.PCAAxes, 'off');
            app.PCAAxes.XLabel.String = 'PC 1 (Literacy vs Child Dependency)';
            app.PCAAxes.YLabel.String = 'PC 2 (Tribal Concentration)';
            app.PCAAxes.XGrid = 'on';
            app.PCAAxes.YGrid = 'on';
        end

    end

end
