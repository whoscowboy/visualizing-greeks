function calculateAndPlotCallback(hObject, eventdata)
    global inputLabels numOptions;

    minStockPrice = 50;
    maxStockPrice = 150;
    numPoints = 100;
    stockPrices = linspace(minStockPrice, maxStockPrice, numPoints);

    combinedCallPayoff = zeros(1, numPoints);
    combinedPutPayoff = zeros(1, numPoints);

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
        % Retrieve selected option type ('Call' or 'Put')
        optionTypeHandle = findobj('Tag', sprintf('Option%dType', i));
        optionTypeValue = get(optionTypeHandle, 'Value');
        
        % Since the value is wrapped in a cell, extract the numeric index correctly
        if iscell(optionTypeValue)
            optionTypeValue = optionTypeValue{1};
        end
        
        optionTypeStr = get(optionTypeHandle, 'String');
        selectedOptionType = optionTypeStr{optionTypeValue};  % This should now be 'Call' or 'Put'


        % Calculate Greeks
        if iscell(selectedOptionType)
            disp(['Selected Option Type: ', selectedOptionType{1}]);  % Display the option type if it's in a cell
        else
            disp(['Selected Option Type: ', selectedOptionType]);      % Display the option type if it's not a cell
        end

        delta = arrayfun(@(S) mydelta(S, K, T, r, sigma, selectedOptionType), stockPrices);
        gamma = arrayfun(@(S) mygamma(S, K, T, r, sigma), stockPrices);

         % Calculate rho, theta, and vega
        rho = arrayfun(@(S) myrho(S, K, T, r, sigma, selectedOptionType), stockPrices);
        theta = arrayfun(@(S) mytheta(S, K, T, r, sigma, selectedOptionType), stockPrices);
        vega = arrayfun(@(S) vegaValue(S, K, T, r, sigma), stockPrices);

        % Plotting all Greeks
        figure('Name', ['Option ', num2str(i), ' Greeks Analysis'], 'NumberTitle', 'off');
        subplot(3, 2, 1);
        plot(stockPrices, delta, 'LineWidth', 2);
        title('Delta');
        xlabel('Stock Price ($)');
        ylabel('Delta');

        subplot(3, 2, 2);
        plot(stockPrices, gamma, 'LineWidth', 2);
        title('Gamma');
        xlabel('Stock Price ($)');
        ylabel('Gamma');

        subplot(3, 2, 3);
        plot(stockPrices, rho, 'LineWidth', 2);
        title('Rho');
        xlabel('Stock Price ($)');
        ylabel('Rho');

        subplot(3, 2, 4);
        plot(stockPrices, theta, 'LineWidth', 2);
        title('Theta');
        xlabel('Stock Price ($)');
        ylabel('Theta per Day');

        subplot(3, 2, 5);
        plot(stockPrices, vega, 'LineWidth', 2);
        title('Vega');
        xlabel('Stock Price ($)');
        ylabel('Vega per 1% Volatility');

        grid on;

        % Calculate Payoffs for both call and put
        [callPayoff, putPayoff] = optionPayoffs(stockPrices, K);

        % % Plot Greeks
        % figure('Name', ['Option ', num2str(i), ' Greeks Analysis'], 'NumberTitle', 'off');
        % subplot(2,1,1);
        % plot(stockPrices, delta, 'LineWidth', 2);
        % title(['Delta for Option ', num2str(i), ' (', selectedOptionType, ')']);
        % xlabel('Stock Price ($)');
        % ylabel('Delta');
        % subplot(2,1,2);
        % plot(stockPrices, gamma, 'LineWidth', 2);
        % title(['Gamma for Option ', num2str(i)]);
        % xlabel('Stock Price ($)');
        % ylabel('Gamma');
        % grid on;

        % Plot only the relevant payoff based on the selected option type
        figure('Name', ['Option ', num2str(i), ' Payoff'], 'NumberTitle', 'off');
        if strcmp(selectedOptionType, 'Call')
            plot(stockPrices, callPayoff, 'b-', 'LineWidth', 2);
            title(['Call Option ', num2str(i), ' Payoff']);
            ylabel('Payoff ($)');
            legend('Call Payoff');
        elseif strcmp(selectedOptionType, 'Put')
            plot(stockPrices, putPayoff, 'r-', 'LineWidth', 2);
            title(['Put Option ', num2str(i), ' Payoff']);
            ylabel('Payoff ($)');
            legend('Put Payoff');
        end
        xlabel('Stock Price ($)');
        grid on;

        % Accumulate payoffs for combined plot
        combinedCallPayoff = combinedCallPayoff + callPayoff;
        combinedPutPayoff = combinedPutPayoff + putPayoff;
    end

    % Plot combined payoffs
    figure('Name', 'Combined Payoffs', 'NumberTitle', 'off');
    plot(stockPrices, combinedCallPayoff, 'b-', 'LineWidth', 2); hold on;
    plot(stockPrices, combinedPutPayoff, 'r-', 'LineWidth', 2);
    title('Combined Payoff from All Options');
    xlabel('Stock Price ($)');
    ylabel('Payoff ($)');
    legend('Combined Call Payoff', 'Combined Put Payoff');
    grid on;
    hold off;
end
% function calculateAndPlotCallback(hObject, eventdata)
%     global inputLabels numOptions;
% 
%     % Define the stock price range for plotting
%     minStockPrice = 50;
%     maxStockPrice = 150;
%     numPoints = 100;
%     stockPrices = linspace(minStockPrice, maxStockPrice, numPoints);
% 
%     combinedCallPayoff = zeros(1, numPoints);
%     combinedPutPayoff = zeros(1, numPoints);
% 
%     % Loop through each option to gather inputs, validate, calculate Greeks, and plot
%     for i = 1:numOptions
%         % Fetching input values for each option
%         S = str2double(get(findobj('Tag', sprintf('Option%dStockPrice', i)), 'String'));
%         K = str2double(get(findobj('Tag', sprintf('Option%dStrikePrice', i)), 'String'));
%         T = str2double(get(findobj('Tag', sprintf('Option%dTimeToMaturity', i)), 'String'));
%         r = str2double(get(findobj('Tag', sprintf('Option%dRiskFreeRate', i)), 'String'));
%         sigma = str2double(get(findobj('Tag', sprintf('Option%dVolatility', i)), 'String'));
% 
%         [callPayoff, putPayoff] = optionPayoffs(stockPrices, K);
% 
%         combinedCallPayoff = combinedCallPayoff + callPayoff;
%         combinedPutPayoff = combinedPutPayoff + putPayoff;
% 
%         % Validate the fetched parameters
%         if any(isnan([S, K, T, r, sigma]))
%             errordlg(sprintf('Invalid input for Option %d. Please ensure all fields are filled out correctly.', i), 'Input Error');
%             return;
%         end
% 
%         % Retrieve selected option type ('Call' or 'Put')
%         optionTypeHandle = findobj('Tag', sprintf('Option%dType', i));
%         optionTypeValue = get(optionTypeHandle, 'Value');
%         optionTypeStr = get(optionTypeHandle, 'String');
%         selectedOptionType = optionTypeStr{optionTypeValue}; % 'Call' or 'Put'
% 
%         % Calculate Greeks based on the selected type
%         delta = arrayfun(@(S) mydelta(S, K, T, r, sigma, selectedOptionType), stockPrices);
%         gamma = arrayfun(@(S) mygamma(S, K, T, r, sigma), stockPrices); % Gamma doesn't change with option type
% 
%         % Calculate and Plot Payoffs
%         [callPayoff, putPayoff] = optionPayoffs(stockPrices, K);
% 
%         % New plotting section for payoffs
%         figure('Name', ['Option ', num2str(i), ' Payoff Diagram'], 'NumberTitle', 'off');
%         plot(stockPrices, callPayoff, 'b-', 'LineWidth', 2); hold on;
%         plot(stockPrices, putPayoff, 'r-', 'LineWidth', 2);
%         title(['Payoff for Option ', num2str(i)]);
%         xlabel('Stock Price ($)');
%         ylabel('Payoff ($)');
%         legend('Call Payoff', 'Put Payoff');
%         grid on;
% 
%         % Plotting the results
%         figure('Name', ['Option ', num2str(i), ' Greeks Analysis'], 'NumberTitle', 'off');
%         subplot(2,1,1); % Delta plot
%         plot(stockPrices, delta, 'LineWidth', 2);
%         title(['Delta for Option ', num2str(i), ' (', selectedOptionType, ')']);
%         xlabel('Stock Price ($)');
%         ylabel('Delta');
% 
%         subplot(2,1,2); % Gamma plot
%         plot(stockPrices, gamma, 'LineWidth', 2);
%         title(['Gamma for Option ', num2str(i)]);
%         xlabel('Stock Price ($)');
%         ylabel('Gamma');
% 
%         grid on;
%     end
% 
%     % Plot combined payoffs
%     figure('Name', 'Combined Payoffs', 'NumberTitle', 'off');
%     plot(stockPrices, combinedCallPayoff, 'b-', 'LineWidth', 2); hold on;
%     plot(stockPrices, combinedPutPayoff, 'r-', 'LineWidth', 2);
%     title('Combined Payoff from All Options');
%     xlabel('Stock Price ($)');
%     ylabel('Payoff ($)');
%     legend('Combined Call Payoff', 'Combined Put Payoff');
%     grid on;
%     hold off;
% end

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