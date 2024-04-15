function [callPrice, putPrice] = optionPricingModel(S, K, T, r, sigma)
    % Calculates the price of European call and put options using the Black-Scholes model.
    % S: Current stock price (can be an array)
    % K: Strike price
    % T: Time to maturity (in years)
    % r: Risk-free interest rate
    % sigma: Volatility of the underlying asset

    d1 = (log(S./K) + (r + 0.5.*sigma.^2).*T) ./ (sigma.*sqrt(T));
    d2 = d1 - sigma .* sqrt(T);

    % Adjusted for element-wise operations
    callPrice = S .* normcdf(d1) - K .* exp(-r .* T) .* normcdf(d2);
    putPrice = K .* exp(-r .* T) .* normcdf(-d2) - S .* normcdf(-d1);
end

