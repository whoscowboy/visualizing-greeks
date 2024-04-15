function rho = myrho(S, K, T, r, sigma, optionType)
    % Calculates the Rho of an option
    % S: Stock price
    % K: Strike price
    % T: Time to maturity
    % r: Risk-free rate
    % sigma: Volatility
    % optionType: 'Call' or 'Put'
    
    d1 = (log(S/K) + (r + 0.5*sigma^2)*T) / (sigma*sqrt(T));
    d2 = d1 - sigma*sqrt(T);
    
    if strcmp(optionType, 'Call')
        rho = T * K * exp(-r * T) * normcdf(d2);
    elseif strcmp(optionType, 'Put')
        rho = -T * K * exp(-r * T) * normcdf(-d2);
    else
        error('Invalid option type. Choose ''Call'' or ''Put''.');
    end
end