function setupMonteCarloGUI
    % New GUI figure setup for Monte Carlo inputs
    figMC = figure('Name', 'Monte Carlo Simulation Inputs', 'Position', [520, 100, 300, 400], 'NumberTitle', 'off', 'MenuBar', 'none');
    
    % Define positions and sizes for UI components
    startYPos = 350;
    gapY = 25;
    width = 200;
    height = 20;
    
    % Number of simulations input
    uicontrol('Style', 'text', 'Parent', figMC, 'Position', [50, startYPos, width, height], 'String', 'Number of Simulations:', 'HorizontalAlignment', 'left');
    hNumSims = uicontrol('Style', 'edit', 'Parent', figMC, 'Position', [50, startYPos - gapY, width, height], 'String', '1000');
    
    % Time horizon input
    uicontrol('Style', 'text', 'Parent', figMC, 'Position', [50, startYPos - 2*gapY, width, height], 'String', 'Time Horizon (Years):', 'HorizontalAlignment', 'left');
    hTimeHorizon = uicontrol('Style', 'edit', 'Parent', figMC, 'Position', [50, startYPos - 3*gapY, width, height], 'String', '1');
    
    % Button to start the simulation
    uicontrol('Style', 'pushbutton', 'Parent', figMC, 'Position', [50, startYPos - 5*gapY, width, height], 'String', 'Run Simulation', ...
        'Callback', @(src, evt) runMonteCarloSimulation_Callback(hNumSims, hTimeHorizon));
end



