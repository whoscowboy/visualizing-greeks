function gamma = mygamma(S, K, T, r, sigma)
    % Calculates the Gamma of an option
    % S: Stock price
    % K: Strike price
    % T: Time to maturity
    % r: Risk-free rate
    % sigma: Volatility
    
    d1 = (log(S/K) + (r + 0.5*sigma^2)*T) / (sigma*sqrt(T));
    gamma = normpdf(d1) / (S * sigma * sqrt(T));
end