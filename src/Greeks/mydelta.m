function delta = mydelta(S, K, T, r, sigma, optionType)
    % Trimming spaces or invisible characters
    optionType = strtrim(optionType);
    
    %Black-Scholes
    %callPrice = S * normcdf(d1) - K * exp(-r * T) * normcdf(d2);
    
    % Calculates the Delta of an option
    % Check optionType using a case-insensitive comparison
    if strcmpi(optionType, 'Call')
        d1 = (log(S./K) + (r + 0.5.*sigma.^2).*T) ./ (sigma.*sqrt(T));
        delta = normcdf(d1);
    elseif strcmpi(optionType, 'Put')
        d1 = (log(S./K) + (r + 0.5.*sigma.^2).*T) ./ (sigma.*sqrt(T));
        delta = normcdf(d1) - 1;
    else
        error(['Invalid option type "', optionType, '". Choose ''Call'' or ''Put''.']);
    end
end