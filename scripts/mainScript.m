% mainScript.m - Main script to launch the Options Greeks GUI

% Define global variables for input fields and the number of options
global inputLabels numOptions;
inputLabels = {'StockPrice', 'StrikePrice', 'TimeToMaturity', 'RiskFreeRate', 'Volatility'};
numOptions = 2; % Update to use 2 options

% Call the function to set up the GUI
%setupOptionGUI;
setupGammaSlider;


% Define global variables for input fields and the number of options
global inputLabels numOptions;
inputLabels = {'StockPrice', 'StrikePrice', 'TimeToMaturity', 'RiskFreeRate', 'Volatility'};
numOptions = 2; % Update to use 2 options

% Call the function to set up the main GUI
%setupOptionGUI;

% Add a button to open the Monte Carlo simulation window
uicontrol('Style', 'pushbutton', 'String', 'Monte Carlo Simulation', ...
          'Position', [10, 10, 150, 30], 'Callback', @openMonteCarloGUI);

showStockPrices;
% Define the callback function for opening the Monte Carlo simulation window
function openMonteCarloGUI(hObject, eventdata)
    setupMonteCarloGUI(); % This function should be in a separate file or within the script
end