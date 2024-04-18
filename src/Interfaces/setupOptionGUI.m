function setupOptionGUI
    global inputLabels numOptions;

    % Initialize the number of options and input labels if not already done
    numOptions = 2; % Adjust this to add more options in the future
    inputLabels = {'StockPrice', 'StrikePrice', 'TimeToMaturity', 'RiskFreeRate', 'Volatility'};
    
    % Default values for each input field
    defaultValues = {'100', '100', '1', '0.05', '0.2'}; % Example default values

    % Main GUI figure setup
    fig = figure('Name', 'Options Input', 'Position', [100, 100, 420, 600], 'NumberTitle', 'off', 'MenuBar', 'none');

    startYPos = 550;
    gapY = 30; % Gap between rows
    inputFieldWidth = 100;
    labelWidth = 100;
    height = 20; % Height of input fields and labels

    for i = 1:numOptions
        % Section label for each option
        uicontrol('Style', 'text', 'Parent', fig, 'Position', [10, startYPos - (i-1)*(length(inputLabels)+2)*gapY, 200, height], 'String', ['Option ' num2str(i)], 'HorizontalAlignment', 'left');
        
        for j = 1:length(inputLabels)
            % Create labels
            uicontrol('Style', 'text', 'Parent', fig, 'Position', [10, startYPos - (j)*gapY - (i-1)*(length(inputLabels)+2)*gapY, labelWidth, height], 'String', strrep(inputLabels{j}, '_', ' '), 'HorizontalAlignment', 'left');
            % Create input fields with default values
            uicontrol('Style', 'edit', 'Parent', fig, 'Position', [120, startYPos - (j)*gapY - (i-1)*(length(inputLabels)+2)*gapY, inputFieldWidth, height], 'String', defaultValues{j}, 'Tag', sprintf('Option%d%s', i, inputLabels{j}));
        end
        
        % Dropdown menu for selecting 'Call' or 'Put', defaulting to 'Call'
        uicontrol('Style', 'popupmenu', 'Parent', fig, 'Position', [120, startYPos - (length(inputLabels)+1)*gapY - (i-1)*(length(inputLabels)+2)*gapY, inputFieldWidth, height], 'String', {'Call', 'Put'}, 'Value', 1, 'Tag', sprintf('Option%dType', i), 'BackgroundColor', 'white');
    end

    % Add a "Calculate and Plot" button at the bottom
    uicontrol('Style', 'pushbutton', 'Parent', fig, 'Position', [160, 20, 100, 30], 'String', 'Calculate and Plot', 'Callback', @calculateAndPlotCallback);

    % Button to plot 3D Delta
    % This button now relies on the dynamic calculation within the callback function
    uicontrol('Style', 'pushbutton', 'Parent', fig, 'Position', [270, 20, 100, 30], 'String', 'Plot Delta 3D', ...
        'Callback', @plotDelta3D_Callback);

end