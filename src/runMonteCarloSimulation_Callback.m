function runMonteCarloSimulation_Callback(hNumSims, hTimeHorizon)
    % Retrieve the number of simulations and the time horizon from the GUI
    numSims = str2double(get(hNumSims, 'String'));
    timeHorizon = str2double(get(hTimeHorizon, 'String'));
    
    % Validate inputs
    if isnan(numSims) || isnan(timeHorizon) || numSims <= 0 || timeHorizon <= 0
        errordlg('Please ensure all fields are filled out correctly with positive numeric values.', 'Input Error');
        return;
    end
    
    % Fetch the user's inputs for Option 1
    S0 = str2double(get(findobj('Tag', 'Option1StockPrice'), 'String'));    % Current stock price
    K = str2double(get(findobj('Tag', 'Option1StrikePrice'), 'String'));    % Strike price
    T = str2double(get(findobj('Tag', 'Option1TimeToMaturity'), 'String')); % Time to maturity
    r = str2double(get(findobj('Tag', 'Option1RiskFreeRate'), 'String'));   % Risk-free rate
    sigma = str2double(get(findobj('Tag', 'Option1Volatility'), 'String')); % Volatility
    optionTypeHandle = findobj('Tag', 'Option1Type');
    optionTypeValue = get(optionTypeHandle, 'Value');
    optionTypeStr = get(optionTypeHandle, 'String');
    
    % Check if optionTypeValue is wrapped in a cell and extract the number if it is
    if iscell(optionTypeValue)
        optionTypeValue = optionTypeValue{1};
    end
    
    % Now we can safely use optionTypeValue to index into optionTypeStr
    optionType = optionTypeStr{optionTypeValue};

    % Validate the fetched option inputs
    if any(isnan([S0, K, T, r, sigma]) | T <= 0)
        errordlg('Please ensure all Option 1 fields are filled out correctly and are positive numeric values.', 'Input Error');
        return;
    end
    
    % Adjust the time horizon if the user inputs a longer time to maturity than the specified horizon
    timeHorizon = max(timeHorizon, T);
    dt = 1/252; % Daily time step, assuming 252 trading days in a year
    numSteps = timeHorizon * 252; % Convert time horizon to trading days
    
    % Now, you can use dt to perform the Monte Carlo simulation
    pricePaths = S0 * exp(cumsum((r - 0.5 * sigma^2) * dt + sigma * sqrt(dt) * randn(numSteps, numSims), 1));


    % Time steps of interest
    timeSteps = [30, 60, 120, 252];
    for t = timeSteps
        if t <= numSteps % Check if the time step is within the simulation range
            % Store prices in a struct with dynamic field names
            stockPricesAtTimeSteps.(['TimeStep_' num2str(t)]) = pricePaths(t, :);
        else
            fprintf('Time step %d is beyond the simulation range.\n', t);
        end
    end
    
    % Assign the structure to a base workspace variable
    assignin('base', 'StockPricesAtSelectedTimeSteps', stockPricesAtTimeSteps);




    
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
        pause(0.005);
    end

    % After dynamic plotting, create the summary surface plot
    timeInYears = (0:numSteps-1) * dt;

    % After dynamic plotting, create the summary surface plot
    figure;
    surf(1:numSims, timeInYears, DeltaMatrix);
    title('Delta Evolution Over Time Across All Simulated Paths');
    xlabel('Simulation Paths');
    ylabel('Time (Years)');
    zlabel('Delta');
    colorbar;
    % figure;
    % surf(1:numSims, (1:numSteps) * dt * 252, DeltaMatrix);
    % title('Delta Evolution Over Time Across All Simulated Paths');
    % xlabel('Simulation Paths');
    % ylabel('Time (Years)');
    % zlabel('Delta');
    % colorbar;

    % Calculate the number of times the option ends in-the-money
    finalPrices = pricePaths(end, :);  % Extract the final day stock prices from each simulation path
    if strcmp(optionType, 'Call')
        itmCount = sum(finalPrices > K);  % Count how many final prices are greater than the strike price for calls
    elseif strcmp(optionType, 'Put')
        itmCount = sum(finalPrices < K);  % Count how many final prices are below the strike price for puts
    else
        disp('Option type is not recognized. Cannot calculate in-the-money occurrences.');
        return;
    end

    % Print the count to the MATLAB console
    fprintf('Number of times the option ended in-the-money: %d out of %d simulations\n', itmCount, numSims);
end

