% Check if the structured data with stock prices is available in the workspace
if evalin('base', 'exist(''StockPricesAtSelectedTimeSteps'', ''var'')')
    % Retrieve the structured data from the workspace
    stockPricesAtTimeSteps = evalin('base', 'StockPricesAtSelectedTimeSteps');
    
    % Define the time steps you are interested in
    timeSteps = fieldnames(stockPricesAtTimeSteps);
    
    % Create a figure to hold all plots
    figure;
    hold on;
    
    % Loop through each time step and plot the stock prices and their trendline
    for i = 1:length(timeSteps)
        subplot(2, 2, i);  % Adjust the subplot grid as needed based on the number of time steps
        prices = stockPricesAtTimeSteps.(timeSteps{i});
        plot(prices, 'o-');  % Plot the stock prices
        title(['Stock Prices at Time Step ' timeSteps{i}(9:end)]);
        xlabel('Simulation Index');
        ylabel('Stock Price');
        
        % Add a trendline
        p = polyfit(1:1000, prices, 1);  % Linear fit
        yfit = polyval(p, 1:1000);
        hold on;
        plot(1:1000, yfit, 'r-');  % Plot the trendline
        legend('Stock Prices', 'Trendline');
    end
    
    hold off;
else
    disp('Stock price data from Monte Carlo simulation is not available.');
end
