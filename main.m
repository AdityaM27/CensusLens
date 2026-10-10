%% CENSUSLENS: DEMOGRAPHIC INTELLIGENCE & RESOURCE DEMAND SUITE
% Entry Point Script for MATLAB R2024 / Windows
%
% To run the application, simply execute this script:
%   >> main
% Or directly call:
%   >> launchCensusLensApp

clc;
clear;
close all;

% Set up paths
projectRoot = fileparts(mfilename("fullpath"));
addpath(fullfile(projectRoot, "src"));

disp("===============================================================");
disp("                         CENSUSLENS                            ");
disp("            Demographic Intelligence & Analytics               ");
disp("           Computational Mathematics Laboratory                ");
disp("===============================================================");
disp("Project Root: " + projectRoot);
disp("Starting application dashboard...");

% Launch the interactive dashboard
try
    launchCensusLensApp();
catch ME
    warning("Direct dashboard launch encountered an issue: %s", ME.message);
    disp("You can run tests via: run_tests");
    disp("You can run data validation via: validate_data");
end