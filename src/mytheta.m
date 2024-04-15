function theta = mytheta(S, K, T, r, sigma, optionType)
    % Calculates the Theta of an option
    % S: Stock price
    % K: Strike price
    % T: Time to maturity
    % r: Risk-free rate
    % sigma: Volatility
    % optionType: 'Call' or 'Put'

    d1 = (log(S/K) + (r + 0.5*sigma^2)*T) / (sigma*sqrt(T));
    d2 = d1 - sigma*sqrt(T);

    if strcmp(optionType, 'Call')
        theta = -(S * normpdf(d1) * sigma) / (2 * sqrt(T)) - r * K * exp(-r * T) * normcdf(d2);
    elseif strcmp(optionType, 'Put')
        theta = -(S * normpdf(d1) * sigma) / (2 * sqrt(T)) + r * K * exp(-r * T) * normcdf(-d2);
    else
        error('Invalid option type. Choose ''Call'' or ''Put''.');
    end

    % The theta value calculated above represents the change in option price per calendar day.
    % For trading days, you might divide by 252 (the average number of trading days in a year).
    theta = theta / 365; % Adjust to per-day theta for clarity.
end