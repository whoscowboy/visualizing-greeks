function runMonteCarloSimulation_Callback(hNumSims, hTimeHorizon)
    % Retrieve the number of simulations and the time horizon from the GUI
    numSims = str2double(get(hNumSims, 'String'));
    timeHorizon = str2double(get(hTimeHorizon, 'String'));
    
    % Validate inputs
    if isnan(numSims) || isnan(timeHorizon) || numSims <= 0 || timeHorizon <= 0
        errordlg('Please ensure all fields are filled out correctly with positive numeric values.', 'Input Error');
        return;
    end
    
    % Fetch other necessary option parameters from the main GUI or set defaults
    S0 = 100; % Current stock price (example default)
    K = 100;  % Strike price (example default)
    r = 0.05; % Risk-free rate (example default)
    sigma = 0.2; % Volatility (example default)
    optionType = 'Call'; % Option type (example default)
    dt = 1/252; % Daily time step, assuming 252 trading days in a year
    numSteps = timeHorizon * 252; % Convert time horizon to trading days
    
    % Perform the Monte Carlo simulation for stock prices
    pricePaths = S0 * exp(cumsum((r - 0.5 * sigma^2) * dt + sigma * sqrt(dt) * randn(numSteps, numSims), 1));
    
    % Precompute Delta for all paths and all time steps
    DeltaMatrix = nan(numSteps, numSims);
    for step = 1:numSteps
        % For each time step, calculate Delta for all paths
        timeToMaturity = timeHorizon - (step-1)/252; % Time to maturity decreases as we move forward in time
        DeltaMatrix(step, :) = mydelta(pricePaths(step, :), K, timeToMaturity, r, sigma, optionType);
    end

    % Prepare the figure for dynamic plotting
    figureHandle = figure('Name', 'Delta Evolution');
    xlabel('Simulation Paths');
    ylabel('Delta');
    
    % Dynamic plotting
    for step = 1:numSteps
        % Update the plot with the new Delta values at the current time step
        plot(1:numSims, DeltaMatrix(step, :));
        title(sprintf('Delta vs. Simulation Paths at Time Step %d', step));
        ylim([0 1]); % Assuming Delta is between 0 and 1
        drawnow; % Force MATLAB to render the plot immediately
    
        % Pause for a brief moment to create animation effect (adjust pause time as needed)
        pause(0.05);
    end

    % After dynamic plotting, create the summary surface plot
    figure;
    surf(1:numSims, (1:numSteps) * dt * 252, DeltaMatrix);
    title('Delta Evolution Over Time Across All Simulated Paths');
    xlabel('Simulation Paths');
    ylabel('Time (Years)');
    zlabel('Delta');
    colorbar;
end

