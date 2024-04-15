function delta = mydelta(S, K, T, r, sigma, optionType)
    % Trimming spaces or invisible characters
    optionType = strtrim(optionType);

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



% function delta = mydelta(S, K, T, r, sigma, optionType)
%     % Calculates the Delta of an option
%     % S: Stock price
%     % K: Strike price
%     % T: Time to maturity
%     % r: Risk-free rate
%     % sigma: Volatility
%     % optionType: 'Call' or 'Put'
% 
%     d1 = (log(S/K) + (r + 0.5*sigma^2)*T) / (sigma*sqrt(T));
% 
%     if strcmp(optionType, 'Call')
%         delta = normcdf(d1);
%     elseif strcmp(optionType, 'Put')
%         delta = normcdf(d1) - 1;
%     else
%         error('Invalid option type. Choose ''Call'' or ''Put''.');
%     end
% end