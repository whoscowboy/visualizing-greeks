function [callPayoff, putPayoff] = optionPayoffs(S, K)
    % Calculates the payoff for call and put options based on stock prices (S) and strike price (K)
    % S: Array of stock prices
    % K: Strike price

    callPayoff = max(S - K, 0);  % Payoff for call option
    putPayoff = max(K - S, 0);   % Payoff for put option
end