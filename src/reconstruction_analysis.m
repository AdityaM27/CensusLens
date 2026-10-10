clc;
clear;

% Load processed data
load(fullfile("data", "processed", "census_processed.mat"));

% Standardize data
[Z, mu, sigma] = standardize_data(X);

% Calculate SVD
[U, S, V] = svd(Z, "econ");

% Number of available components
r = numel(diag(S));

% Prepare output variables
componentCounts = (1:r)';
relativeErrors = zeros(r, 1);

% Original matrix norm
originalNorm = norm(Z, "fro");

% Calculate errors for different component counts
for k = 1:r

    Uk = U(:, 1:k);
    Sk = S(1:k, 1:k);
    Vk = V(:, 1:k);

    Zk = Uk * Sk * Vk';

    relativeErrors(k) = ...
        norm(Z - Zk, "fro") / originalNorm;

end

% Display results
results = table( ...
    componentCounts, ...
    relativeErrors, ...
    'VariableNames', {'Components', 'RelativeError'});

disp(results);

% Plot reconstruction error
figure;

plot(componentCounts, relativeErrors, "-o");

xlabel("Number of Retained Components");
ylabel("Relative Reconstruction Error");

title("CensusLens: Reconstruction Error");
grid on;