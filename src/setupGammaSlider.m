function setupGammaSlider
    % Set up the GUI for Gamma visualization
    fig = figure('Name', 'Gamma Visualization', 'Position', [100, 100, 500, 400], 'NumberTitle', 'off', 'MenuBar', 'none');

    % Define parameters and their default values
    params = struct('StockPrice', 100, 'StrikePrice', 100, 'TimeToMaturity', 1, ...
                    'RiskFreeRate', 0.05, 'Volatility', 0.20);
    paramNames = fieldnames(params);
    numParams = numel(paramNames);

    % Define limits for sliders
    limits = struct('StockPrice', [50, 150], 'StrikePrice', [50, 150], ...
                    'TimeToMaturity', [0.1, 3], 'RiskFreeRate', [0.01, 0.1], ...
                    'Volatility', [0.1, 0.5]);

    % Setup sliders and labels
    for i = 1:numParams
        paramName = paramNames{i};
        uicontrol('Style', 'text', 'Parent', fig, 'Position', [10, 380 - i*30, 120, 20], ...
                  'String', paramName, 'HorizontalAlignment', 'left');
        uicontrol('Style', 'slider', 'Parent', fig, 'Position', [130, 380 - i*30, 240, 20], ...
                  'Min', limits.(paramName)(1), 'Max', limits.(paramName)(2), 'Value', params.(paramName), ...
                  'Tag', paramName, 'Callback', @updateGammaPlot);
    end

    % Dropdown for option type
    uicontrol('Style', 'popupmenu', 'Parent', fig, 'Position', [130, 380 - (numParams+1)*30, 100, 20], ...
              'String', {'Call', 'Put'}, 'Callback', @updateGammaPlot);

    % Axes for plotting Gamma
    ax = axes('Parent', fig, 'Position', [0.3, 0.2, 0.65, 0.5]);
    title(ax, 'Gamma Plot');
    xlabel(ax, 'Stock Price');
    ylabel(ax, 'Gamma');

    % Initial plot
    updateGammaPlot();

    function updateGammaPlot(hObject, eventdata)
        % Retrieve all parameter values from sliders and dropdown
        for j = 1:numParams
            paramName = paramNames{j};
            params.(paramName) = get(findobj('Tag', paramName), 'Value');
        end
        
        % Get the dropdown menu and retrieve the value
        optionMenu = findobj(fig, 'Style', 'popupmenu');
        optionTypeValue = get(optionMenu, 'Value');
        
        % Define the option types in a cell array and select the appropriate one
        optionTypes = {'Call', 'Put'};
        if optionTypeValue > 0 && optionTypeValue <= length(optionTypes)
            optionType = optionTypes{optionTypeValue};
        else
            optionType = 'Invalid'; % Fallback in case of an invalid value
        end
    
        % Calculate and plot Gamma
        stockPrices = linspace(params.StockPrice * 0.5, params.StockPrice * 1.5, 100);
        gammas = arrayfun(@(S) mygamma(S, params.StrikePrice, params.TimeToMaturity, ...
                        params.RiskFreeRate, params.Volatility), stockPrices);
        
        plot(ax, stockPrices, gammas, 'b-', 'LineWidth', 2);
        grid on;
        legend(ax, ['Gamma for ', optionType, ' Option'], 'Location', 'best');
    end

end