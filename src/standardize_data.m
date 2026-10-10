function [Z, mu, sigma] = standardize_data(X)

    % Calculate feature means
    mu = mean(X, 1);

    % Calculate sample standard deviations
    sigma = std(X, 0, 1);

    % Check for constant or invalid features
    if any(~isfinite(sigma)) || any(sigma == 0)
        error("Invalid or constant feature detected.");
    end

    % Standardize each feature
    Z = (X - mu) ./ sigma;

end