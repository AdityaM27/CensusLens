clc;
clear;
close all;

%% CENSUSLENS - STEP 7: DATA PREPROCESSING

projectRoot = fileparts(fileparts(mfilename("fullpath")));
filePath = fullfile(projectRoot,"data","raw","2011_Census.xlsx");


if ~isfile(filePath)
    error("2011_Census.xlsx not found inside data/raw.");
end

T = readtable(filePath);

disp("Original dataset loaded.");
disp(size(T));

%% 2. Filter district-level Total records

% Select district records and combined rural + urban totals
isDistrict = strcmpi(string(T.Level), "DISTRICT");
isTotal = strcmpi(string(T.TRU), "Total");

Tclean = T(isDistrict & isTotal, :);

disp("Dataset after district-level filtering:");
disp(size(Tclean));

%% 3. Select demographic features

featureNames = {
    'TOT_P'
    'P_06'
    'P_SC'
    'P_ST'
    'P_LIT'
    'TOT_WORK_P'
    'MAINWORK_P'
    'MARGWORK_P'
};

% Extract the numerical feature matrix
X = Tclean{:, featureNames};

%% 4. Check for invalid values

% Retain rows where all selected values are finite
validRows = all(isfinite(X), 2);

X = X(validRows, :);
Tclean = Tclean(validRows, :);

%% 5. Remove constant features if any

featureStd = std(X, 0, 1);
validFeatures = featureStd > 0;

X = X(:, validFeatures);
featureNames = featureNames(validFeatures);

%% 6. Keep region names

regionNames = string(Tclean.Name);

%% 7. Display the results

disp("Preprocessing completed successfully.");

disp("Number of district observations:");
disp(size(X, 1));

disp("Number of features:");
disp(size(X, 2));

disp("Selected features:");
disp(featureNames);

disp("First 10 observations:");
disp(X(1:min(10, size(X, 1)), :));

%% 8. Save the processed data

outputFolder = fullfile("data", "processed");

if ~isfolder(outputFolder)
    mkdir(outputFolder);
end

save(fullfile(outputFolder, "census_processed.mat"), ...
    "X", "Tclean", "regionNames", "featureNames");

disp("Saved census_processed.mat");