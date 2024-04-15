function delta = mydelta(S, K, T, r, sigma, optionType)
    % Calculates the Delta of an option
    % S: Stock price
    % K: Strike price
    % T: Time to maturity
    % r: Risk-free rate
    % sigma: Volatility
    % optionType: 'Call' or 'Put'

    d1 = (log(S/K) + (r + 0.5*sigma^2)*T) / (sigma*sqrt(T));

    if strcmp(optionType, 'Call')
        delta = normcdf(d1);
    elseif strcmp(optionType, 'Put')
        delta = normcdf(d1) - 1;
    else
        error('Invalid option type. Choose ''Call'' or ''Put''.');
    end
end