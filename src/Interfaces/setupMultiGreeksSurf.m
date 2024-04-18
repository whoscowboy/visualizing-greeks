function setupMultiGreeksSurf
    % Set up the GUI for visualizing multiple Greeks
    fig = figure('Name', 'Multi-Greeks Visualization Control Panel', 'Position', [100, 100, 500, 300], 'NumberTitle', 'off', 'MenuBar', 'none');

    % Define parameters and their default values
    params = struct('StrikePrice', 100, 'RiskFreeRate', 0.05, 'Volatility', 0.20);
    paramNames = fieldnames(params);
    numParams = numel(paramNames);

    % Define limits for sliders
    limits = struct('StrikePrice', [50, 150], 'RiskFreeRate', [0.01, 0.1], 'Volatility', [0.1, 0.5]);

    % Setup sliders, labels, and value displays
    baseY = 250; % Starting vertical position for sliders
    for i = 1:numParams
        paramName = paramNames{i};
        uicontrol('Style', 'text', 'Parent', fig, 'Position', [10, baseY - i*30, 120, 20], ...
                  'String', paramName, 'HorizontalAlignment', 'left');
        slider = uicontrol('Style', 'slider', 'Parent', fig, 'Position', [130, baseY - i*30, 240, 20], ...
                  'Min', limits.(paramName)(1), 'Max', limits.(paramName)(2), 'Value', params.(paramName), ...
                  'Tag', paramName, 'Callback', @updateGreeksPlots);
        uicontrol('Style', 'text', 'Parent', fig, 'Position', [380, baseY - i*30, 50, 20], ...
                  'String', num2str(get(slider, 'Value'), '%.2f'), 'Tag', [paramName 'Value'], 'HorizontalAlignment', 'left');
    end

    % Dropdown for option type selection
    optionTypeDropdown = uicontrol('Style', 'popupmenu', 'Parent', fig, 'Position', [10, baseY - (numParams+1)*30, 100, 20], ...
                                   'String', {'Call', 'Put'}, 'Tag', 'optionTypeDropdown', 'Callback', @updateGreeksPlots);

    % Initial range of stock prices and time to maturity
    stockPrices = linspace(50, 150, 100);
    timeToMaturity = linspace(0.1, 2, 100);
    [S, T] = meshgrid(stockPrices, timeToMaturity);

    % Create separate figures for each Greek with initial empty surf plots
    figDelta = figure('Name', 'Delta Surface', 'NumberTitle', 'off');
    axDelta = axes('Parent', figDelta);
    surfDelta = surf(axDelta, S, T, zeros(size(S)), 'EdgeColor', 'none');
    title('Delta');
    xlabel('Stock Price ($)');
    ylabel('Time to Maturity (years)');
    zlabel('Delta');
    colormap(figDelta, 'winter');

    figGamma = figure('Name', 'Gamma Surface', 'NumberTitle', 'off');
    axGamma = axes('Parent', figGamma);
    surfGamma = surf(axGamma, S, T, zeros(size(S)), 'EdgeColor', 'none');
    title('Gamma');
    xlabel('Stock Price ($)');
    ylabel('Time to Maturity (years)');
    zlabel('Gamma');
    colormap(figGamma, 'autumn');

    figTheta = figure('Name', 'Theta Surface', 'NumberTitle', 'off');
    axTheta = axes('Parent', figTheta);
    surfTheta = surf(axTheta, S, T, zeros(size(S)), 'EdgeColor', 'none');
    title('Theta');
    xlabel('Stock Price ($)');
    ylabel('Time to Maturity (years)');
    zlabel('Theta');
    colormap(figTheta, 'cool');

    % Define the update function
    function updateGreeksPlots(~, ~)
        % Retrieve all parameter values from sliders and the option type
        for j = 1:numParams
            paramName = paramNames{j};
            params.(paramName) = get(findobj('Tag', paramName), 'Value');
            % Update the display for the current value
            valueDisplay = findobj('Tag', [paramName 'Value']);
            set(valueDisplay, 'String', num2str(params.(paramName), '%.2f'));
        end
        selectedOptionType = get(optionTypeDropdown, 'String');
        selectedOptionType = selectedOptionType{get(optionTypeDropdown, 'Value')};

        % Update the surf plot data
        set(surfDelta, 'ZData', arrayfun(@(s, t) mydelta(s, params.StrikePrice, t, params.RiskFreeRate, params.Volatility, selectedOptionType), S, T));
        set(surfGamma, 'ZData', arrayfun(@(s, t) mygamma(s, params.StrikePrice, t, params.RiskFreeRate, params.Volatility), S, T));
        set(surfTheta, 'ZData', arrayfun(@(s, t) mytheta(s, params.StrikePrice, t, params.RiskFreeRate, params.Volatility, selectedOptionType), S, T));
    end

    % Initial update to populate plots
    updateGreeksPlots();
end
