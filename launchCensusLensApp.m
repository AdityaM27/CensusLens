function fig = launchCensusLensApp()
% LAUNCHCENSUSLENSAPP Launches the complete CensusLens demographic intelligence application
%
% Usage:
%   launchCensusLensApp()
%   fig = launchCensusLensApp()
%
% This function initializes MATLAB paths, verifies project dependencies,
% and opens the CensusLens Dashboard.

    % Determine project root
    projectRoot = fileparts(mfilename("fullpath"));
    srcDir = fullfile(projectRoot, "src");
    
    if ~isfolder(srcDir)
        error("Source directory not found: %s", srcDir);
    end
    
    addpath(srcDir);
    
    disp("==================================================");
    disp("          LAUNCHING CENSUSLENS SUITE              ");
    disp("==================================================");
    disp("Project Root: " + projectRoot);
    disp("Initializing CensusLens Dashboard...");
    
    % Launch the dashboard
    f = CensusLensDashboard();
    
    disp("CensusLens application launched successfully.");
    
    if nargout > 0
        fig = f;
    end

end
