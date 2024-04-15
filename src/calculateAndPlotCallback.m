
function calculateAndPlotCallback(hObject, eventdata)
    global inputLabels numOptions;

    % Define the stock price range for plotting
    minStockPrice = 50;
    maxStockPrice = 150;
    numPoints = 100;
    stockPrices = linspace(minStockPrice, maxStockPrice, numPoints);

    % Loop through each option to gather inputs, validate, calculate Greeks, and plot
    for i = 1:numOptions
        % Fetching input values for each option
        S = str2double(get(findobj('Tag', sprintf('Option%dStockPrice', i)), 'String'));
        K = str2double(get(findobj('Tag', sprintf('Option%dStrikePrice', i)), 'String'));
        T = str2double(get(findobj('Tag', sprintf('Option%dTimeToMaturity', i)), 'String'));
        r = str2double(get(findobj('Tag', sprintf('Option%dRiskFreeRate', i)), 'String'));
        sigma = str2double(get(findobj('Tag', sprintf('Option%dVolatility', i)), 'String'));

        % Validate the fetched parameters
        if any(isnan([S, K, T, r, sigma]))
            errordlg(sprintf('Invalid input for Option %d. Please ensure all fields are filled out correctly.', i), 'Input Error');
            return;
        end

        % Retrieve selected option type ('Call' or 'Put')
        optionTypeHandle = findobj('Tag', sprintf('Option%dType', i));
        optionTypeValue = get(optionTypeHandle, 'Value');
        optionTypeStr = get(optionTypeHandle, 'String');
        selectedOptionType = optionTypeStr{optionTypeValue}; % 'Call' or 'Put'

        % Calculate Greeks based on the selected type
        delta = arrayfun(@(S) mydelta(S, K, T, r, sigma, selectedOptionType), stockPrices);
        gamma = arrayfun(@(S) mygamma(S, K, T, r, sigma), stockPrices); % Gamma doesn't change with option type
        
        % Plotting the results
        figure('Name', ['Option ', num2str(i), ' Greeks Analysis'], 'NumberTitle', 'off');
        subplot(2,1,1); % Delta plot
        plot(stockPrices, delta, 'LineWidth', 2);
        title(['Delta for Option ', num2str(i), ' (', selectedOptionType, ')']);
        xlabel('Stock Price ($)');
        ylabel('Delta');

        subplot(2,1,2); % Gamma plot
        plot(stockPrices, gamma, 'LineWidth', 2);
        title(['Gamma for Option ', num2str(i)]);
        xlabel('Stock Price ($)');
        ylabel('Gamma');

        grid on;
    end
end

function plotGreeks(greekName, stockPrices, values)
    % Generic function to plot Greeks. This function assumes that the Greeks
    % are already calculated and passed as parameters.
    % 'stockPrices' is the range of stock prices, and 'values' contains the Greek values to plot.
    figure;
    plot(stockPrices, values);
    title([greekName ' vs. Stock Price']);
    xlabel('Stock Price ($)');
    ylabel(greekName);
    legend('Call', 'Put', 'Location', 'Best');
    grid on;
end