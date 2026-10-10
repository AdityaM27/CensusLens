clc;
clear;
close all;

projectRoot = fileparts(fileparts(mfilename("fullpath")));
filePath = fullfile(projectRoot,"data","raw","2011_Census.xlsx");

% Check whether the file exists
if ~isfile(filePath)
    error("Census file not found. Check the filename and folder.");
end

% Read the XLSX file
T = readtable(filePath);

% Display the first few rows
disp("First 10 rows of the dataset:");
disp(head(T, 10));

% Display column names
disp("Column names:");
disp(T.Properties.VariableNames);

% Display dataset dimensions
disp("Dataset dimensions:");
disp(size(T));

% Display variable types and summary
summary(T);

fprintf("Total rows: %d\n",height(T));
fprintf("Total Columns: %d\n",width(T));

disp(T(1:min(10,height(T)),1:5));

% Identify numeric columns
numericCols = varfun(@isnumeric, T, ...
    'OutputFormat', 'uniform');

fprintf('Total variables: %d\n', width(T));
fprintf('Numeric variables: %d\n', sum(numericCols));

disp('Numeric column names:');
disp(T.Properties.VariableNames(numericCols));

% Display data types of all variables
disp('Variable data types:');
disp(varfun(@class, T, 'OutputFormat', 'table'));