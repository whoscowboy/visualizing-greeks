function plotDelta3D(S, K, T, r, sigma, optionType)
    % Creates a 3D plot of Delta against stock price and time to maturity.
    % S: Stock price (vector)
    % K: Strike price (scalar)
    % T: Time to maturity (vector)
    % r: Risk-free interest rate (scalar)
    % sigma: Volatility of the underlying asset (scalar)
    % optionType: 'Call' or 'Put' (string)

    [S_grid, T_grid] = meshgrid(S, T); % Create 2D grids for stock price and time to maturity

    % Calculate Delta for each (S,T) pair
    Delta_grid = arrayfun(@(s, t) mydelta(s, K, t, r, sigma, optionType), S_grid, T_grid);

    % Now create the 3D surface plot
    figure;
    surf(S_grid, T_grid, Delta_grid); % Create a 3D surface plot
    title(['Delta vs. Stock Price and Time to Maturity for ', optionType, ' Option']);
    xlabel('Stock Price ($)');
    ylabel('Time to Maturity (Years)');
    zlabel('Delta');
    colorbar; % Adds a color bar to indicate the value of Delta
    view(-60, 30); % Adjust the viewing angle for better perception
end
