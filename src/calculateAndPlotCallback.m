function calculateAndPlotCallback(hObject, eventdata)
    global inputLabels numOptions;

    % Define the range for stock prices
    minStockPrice = 50;
    maxStockPrice = 150;
    numPoints = 100;
    stockPrices = linspace(minStockPrice, maxStockPrice, numPoints);

    % Prepare to accumulate payoffs for combined plotting
    combinedCallPayoff = zeros(1, numPoints);
    combinedPutPayoff = zeros(1, numPoints);

    % Loop through each option to gather inputs and calculate Greeks
    for i = 1:numOptions
        % Fetch input values for each option
        S = str2double(get(findobj('Tag', sprintf('Option%dStockPrice', i)), 'String'));
        K = str2double(get(findobj('Tag', sprintf('Option%dStrikePrice', i)), 'String'));
        T = str2double(get(findobj('Tag', sprintf('Option%dTimeToMaturity', i)), 'String'));
        r = str2double(get(findobj('Tag', sprintf('Option%dRiskFreeRate', i)), 'String'));
        sigma = str2double(get(findobj('Tag', sprintf('Option%dVolatility', i)), 'String'));

        % Validate parameters
        if any(isnan([S, K, T, r, sigma]))
            errordlg(sprintf('Invalid input for Option %d. Please ensure all fields are filled out correctly.', i), 'Input Error');
            return;
        end

        % Retrieve and validate option type
        optionTypeHandle = findobj('Tag', sprintf('Option%dType', i));
        optionTypeValue = get(optionTypeHandle, 'Value');
        optionTypeStr = get(optionTypeHandle, 'String');
        selectedOptionType = optionTypeStr{optionTypeValue};

        % Calculate Greeks and display in a new figure
        figure('Name', ['Option ', num2str(i), ' Greeks Analysis'], 'NumberTitle', 'off');
        plotGreeks('Delta', stockPrices, arrayfun(@(S) mydelta(S, K, T, r, sigma, selectedOptionType), stockPrices));
        plotGreeks('Gamma', stockPrices, arrayfun(@(S) mygamma(S, K, T, r, sigma), stockPrices));
        plotGreeks('Rho', stockPrices, arrayfun(@(S) myrho(S, K, T, r, sigma, selectedOptionType), stockPrices));
        plotGreeks('Theta', stockPrices, arrayfun(@(S) mytheta(S, K, T, r, sigma, selectedOptionType), stockPrices));
        plotGreeks('Vega', stockPrices, arrayfun(@(S) vegaValue(S, K, T, r, sigma), stockPrices));

        % Calculate payoffs for both call and put
        [callPayoff, putPayoff] = optionPayoffs(stockPrices, K);

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

function plotGreeks(greekName, stockPrices, values)
    % Generic function to plot Greeks. Assumes that the Greeks
    % are already calculated and passed as parameters.
    subplot(3, 2, find(strcmp({'Delta', 'Gamma', 'Rho', 'Theta', 'Vega'}, greekName)));
    plot(stockPrices, values, 'LineWidth', 2);
    title(greekName);
    xlabel('Stock Price ($)');
    ylabel(greekName);
    grid on;
end
