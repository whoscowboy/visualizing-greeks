function [callPayoff, putPayoff] = optionPayoffs(S, K, optionType)
    % Calculates the payoff for call and put options based on stock prices (S) and strike price (K)
    % S: Array of stock prices
    % K: Strike price
    % optionType: 'Call' or 'Put'

    callPayoff = max(S - K, 0);  % Payoff for call option
    putPayoff = max(K - S, 0);   % Payoff for put option
    
    if strcmp(optionType, 'Call')
        putPayoff = zeros(size(S)); % Zero out put payoff if only call is selected
    elseif strcmp(optionType, 'Put')
        callPayoff = zeros(size(S)); % Zero out call payoff if only put is selected
    end
end

