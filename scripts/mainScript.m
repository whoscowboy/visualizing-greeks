% mainScript.m - Main script to launch the Options Greeks GUI

% Define global variables for input fields and the number of options
global inputLabels numOptions;
inputLabels = {'StockPrice', 'StrikePrice', 'TimeToMaturity', 'RiskFreeRate', 'Volatility'};
numOptions = 2; % Update to use 2 options

% Call the function to set up the GUI
setupOptionGUI;