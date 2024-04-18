function vega = vegaValue(S, K, T, r, sigma)
    % Calculates the Vega of an option
    % S: Stock price
    % K: Strike price
    % T: Time to maturity
    % r: Risk-free rate
    % sigma: Volatility
    
    d1 = (log(S/K) + (r + 0.5*sigma^2)*T) / (sigma*sqrt(T));
    vega = S * normpdf(d1) * sqrt(T);
    
    % Vega is often represented in terms of a 1% change in volatility.
    % To adjust for this, you might multiply by 0.01.
    vega = vega * 0.01; % Adjust to per 1% change in volatility.
end