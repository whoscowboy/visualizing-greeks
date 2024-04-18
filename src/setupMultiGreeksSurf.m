function setupMultiGreeksSurf
    % Set up the GUI for visualizing multiple Greeks
    fig = figure('Name', 'Multi-Greeks Visualization', 'Position', [100, 100, 1200, 500], 'NumberTitle', 'off', 'MenuBar', 'none');

    % Define parameters and their default values
    params = struct('StrikePrice', 100, 'RiskFreeRate', 0.05, 'Volatility', 0.20);
    paramNames = fieldnames(params);
    numParams = numel(paramNames);

    % Define limits for sliders
    limits = struct('StrikePrice', [50, 150], 'RiskFreeRate', [0.01, 0.1], 'Volatility', [0.1, 0.5]);

    % Setup sliders, labels, and value displays
    for i = 1:numParams
        paramName = paramNames{i};
        uicontrol('Style', 'text', 'Parent', fig, 'Position', [10, 460 - i*30, 120, 20], ...
                  'String', paramName, 'HorizontalAlignment', 'left');
        slider = uicontrol('Style', 'slider', 'Parent', fig, 'Position', [130, 460 - i*30, 240, 20], ...
                  'Min', limits.(paramName)(1), 'Max', limits.(paramName)(2), 'Value', params.(paramName), ...
                  'Tag', paramName, 'Callback', @updateGreeksPlots);
        % Display for current value next to each slider
        uicontrol('Style', 'text', 'Parent', fig, 'Position', [380, 460 - i*30, 50, 20], ...
                  'String', num2str(get(slider, 'Value'), '%.2f'), 'Tag', [paramName 'Value'], 'HorizontalAlignment', 'left');
    end

    % Dropdown for option type selection
    optionTypeDropdown = uicontrol('Style', 'popupmenu', 'Parent', fig, 'Position', [10, 400, 100, 20], ...
                                   'String', {'Call', 'Put'}, 'Callback', @updateGreeksPlots);

    % Create axes for each Greek
    axDelta = axes('Parent', fig, 'Position', [0.05, 0.1, 0.3, 0.8]);
    title(axDelta, 'Delta Surface Plot');
    xlabel(axDelta, 'Stock Price');
    ylabel(axDelta, 'Time to Maturity');
    zlabel(axDelta, 'Delta');

    axGamma = axes('Parent', fig, 'Position', [0.37, 0.1, 0.3, 0.8]);
    title(axGamma, 'Gamma Surface Plot');
    xlabel(axGamma, 'Stock Price');
    ylabel(axGamma, 'Time to Maturity');
    zlabel(axGamma, 'Gamma');

    axTheta = axes('Parent', fig, 'Position', [0.69, 0.1, 0.3, 0.8]);
    title(axTheta, 'Theta Surface Plot');
    xlabel(axTheta, 'Stock Price');
    ylabel(axTheta, 'Time to Maturity');
    zlabel(axTheta, 'Theta');

    % Initial plot update
    updateGreeksPlots(fig, []);

    function updateGreeksPlots(~, ~)
        % Retrieve all parameter values from sliders and the option type
        for j = 1:numParams
            paramName = paramNames{j};
            params.(paramName) = get(findobj('Tag', paramName), 'Value');
            % Update the display for the current value
            valueDisplay = findobj('Tag', [paramName 'Value']);
            set(valueDisplay, 'String', num2str(params.(paramName), '%.2f'));
        end
        optionType = get(optionTypeDropdown, 'String');
        selectedOptionType = optionType{get(optionTypeDropdown, 'Value')};
    
        % Define the range of stock prices and time to maturity
        stockPrices = linspace(50, 150, 100);
        timeToMaturity = linspace(0.1, 2, 100);
    
        % Prepare a meshgrid for the variables
        [S, T] = meshgrid(stockPrices, timeToMaturity);
    
        % Calculate Greek values across the grid
        DeltaValues = arrayfun(@(s, t) mydelta(s, params.StrikePrice, t, params.RiskFreeRate, params.Volatility, selectedOptionType), S, T);
        GammaValues = arrayfun(@(s, t) mygamma(s, params.StrikePrice, t, params.RiskFreeRate, params.Volatility), S, T);
        ThetaValues = arrayfun(@(s, t) mytheta(s, params.StrikePrice, t, params.RiskFreeRate, params.Volatility, selectedOptionType), S, T);
    
        % Update surf plots
        surf(axDelta, S, T, DeltaValues, 'EdgeColor', 'none', 'FaceColor', 'r');
        surf(axGamma, S, T, GammaValues, 'EdgeColor', 'none', 'FaceColor', 'g');
        surf(axTheta, S, T, ThetaValues, 'EdgeColor', 'none', 'FaceColor', 'b');
    end

end
