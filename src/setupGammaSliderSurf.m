function setupGammaSliderSurf
    % Set up the GUI for Gamma visualization
    fig = figure('Name', 'Gamma Visualization Surf', 'Position', [100, 100, 700, 600], 'NumberTitle', 'off', 'MenuBar', 'none');

    % Define parameters and their default values
    params = struct('StrikePrice', 100, 'RiskFreeRate', 0.05, 'Volatility', 0.20);
    paramNames = fieldnames(params);
    numParams = numel(paramNames);

    % Define limits for sliders
    limits = struct('StrikePrice', [50, 150], 'RiskFreeRate', [0.01, 0.1], 'Volatility', [0.1, 0.5]);

    % Setup sliders, labels, and value displays
    for i = 1:numParams
        paramName = paramNames{i};
        uicontrol('Style', 'text', 'Parent', fig, 'Position', [10, 560 - i*30, 120, 20], ...
                  'String', paramName, 'HorizontalAlignment', 'left');
        slider = uicontrol('Style', 'slider', 'Parent', fig, 'Position', [130, 560 - i*30, 240, 20], ...
                  'Min', limits.(paramName)(1), 'Max', limits.(paramName)(2), 'Value', params.(paramName), ...
                  'Tag', paramName, 'Callback', @updateGammaSurfPlot);
        % Display for current value next to each slider
        uicontrol('Style', 'text', 'Parent', fig, 'Position', [380, 560 - i*30, 50, 20], ...
                  'String', num2str(get(slider, 'Value'), '%.2f'), 'Tag', [paramName 'Value'], 'HorizontalAlignment', 'left');
    end

    % Axes for plotting Gamma surf
    ax = axes('Parent', fig, 'Position', [0.1, 0.1, 0.85, 0.45]);
    title(ax, 'Gamma Surface Plot');
    xlabel(ax, 'Stock Price');
    ylabel(ax, 'Time to Maturity');
    zlabel(ax, 'Gamma');

    % Initial plot
    updateGammaSurfPlot(fig, params);

    function updateGammaSurfPlot(~, ~)
        % Retrieve all parameter values from sliders
        for j = 1:numParams
            paramName = paramNames{j};
            params.(paramName) = get(findobj('Tag', paramName), 'Value');
            % Update the display for the current value
            valueDisplay = findobj('Tag', [paramName 'Value']);
            set(valueDisplay, 'String', num2str(params.(paramName), '%.2f'));
        end
        
        % Define the range of stock prices and time to maturity
        stockPrices = linspace(50, 150, 100);
        timeToMaturity = linspace(0.1, 2, 100);

        % Prepare a meshgrid for the variables
        [S, T] = meshgrid(stockPrices, timeToMaturity);

        % Calculate Gamma values across the grid
        GammaValues = arrayfun(@(s, t) mygamma(s, params.StrikePrice, t, params.RiskFreeRate, params.Volatility), S, T);

        % Create the surf plot
        surf(ax, S, T, GammaValues, 'EdgeColor', 'none');
        xlabel(ax, 'Stock Price');
        ylabel(ax, 'Time to Maturity');
        zlabel(ax, 'Gamma');
        colorbar; % Adds a color bar to indicate Gamma values
        grid on;
    end
end

% function gamma = mygamma(S, K, T, r, sigma)
%     % Gamma calculation function
%     d1 = (log(S/K) + (r + 0.5*sigma^2)*T) / (sigma*sqrt(T));
%     gamma = normpdf(d1) / (S * sigma * sqrt(T));
% end
