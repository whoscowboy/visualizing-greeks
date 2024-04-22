function runMeanRevertingMCS_Callback(hNumSims, hTimeHorizon)
    % Retrieve the number of simulations and the time horizon from the GUI
    numSims = str2double(get(hNumSims, 'String'));
    timeHorizon = str2double(get(hTimeHorizon, 'String'));
    
    % Validate inputs
    if isnan(numSims) || isnan(timeHorizon) || numSims <= 0 || timeHorizon <= 0
        errordlg('Please ensure all fields are filled out correctly with positive numeric values.', 'Input Error');
        return;
    end
    
    % Fetch the user's inputs for Option 1
    S0 = str2double(get(findobj('Tag', 'Option1StockPrice'), 'String'));
    K = str2double(get(findobj('Tag', 'Option1StrikePrice'), 'String'));
    T = str2double(get(findobj('Tag', 'Option1TimeToMaturity'), 'String'));
    r = str2double(get(findobj('Tag', 'Option1RiskFreeRate'), 'String'));
    sigma = str2double(get(findobj('Tag', 'Option1Volatility'), 'String'));
    optionTypeHandle = findobj('Tag', 'Option1Type');
    optionTypeValue = get(optionTypeHandle, 'Value');
    optionTypeStr = get(optionTypeHandle, 'String');
    
    if iscell(optionTypeStr)
        optionType = optionTypeStr{optionTypeValue};
    else
        optionType = optionTypeStr(optionTypeValue);
    end

    % Validate the fetched option inputs
    if any(isnan([S0, K, T, r, sigma])) || T <= 0
        errordlg('Please ensure all Option 1 fields are filled out correctly and are positive numeric values.', 'Input Error');
        return;
    end
    
    % Parameters for mean-reversion model
    %in the money 61.8% of the time. so = 100 x = 102 vol 0.2
    % theta = 0.23;
    % mu = S0 * 1.1;


    %in the money 28% of the time. so = 100 x = 102
    theta = 0.1;  % Speed of mean reversion
    mu = S0 * 1.2;       % Long-term mean, setting it dynamically based on user input


    % in the money
    % theta = 0.4;
    % mu = S0 * 1.1;
    % Adjust the time horizon if the user inputs a longer time to maturity than the specified horizon
    dt = 1/252; % Daily time step, assuming 252 trading days in a year
    numSteps = max(timeHorizon, T) * 252; % Convert time horizon to trading days
    
    % Initialize the stock price paths
    pricePaths = zeros(numSteps, numSims);
    pricePaths(1, :) = S0;

    % Perform the Monte Carlo simulation with mean-reversion
    for t = 2:numSteps
        dW = randn(1, numSims);  % Standard normal innovations
        pricePaths(t, :) = pricePaths(t-1, :) + theta * (mu - pricePaths(t-1, :)) * dt + sigma * sqrt(dt) * dW;
    end

    % Calculate Delta for each simulation path and each time step
    DeltaMatrix = nan(numSteps, numSims);
    for step = 1:numSteps
        timeToMaturity = T - dt * (step - 1);
        for sim = 1:numSims
            DeltaMatrix(step, sim) = mydelta(pricePaths(step, sim), K, timeToMaturity, r, sigma, optionType);
        end
    end

    % Prepare the figure for dynamic plotting of Delta
    figureHandle = figure('Name', 'Delta Evolution');
    xlabel('Simulation Paths');
    ylabel('Delta');

    % Dynamic plotting
    for step = 1:numSteps
        plot(1:numSims, DeltaMatrix(step, :));
        title(sprintf('Delta vs. Simulation Paths at Time Step %d', step));
        ylim([0 1]); % Assuming Delta is between 0 and 1
        drawnow; % Force MATLAB to render the plot immediately
        pause(0.005); % Brief pause for animation effect
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


    % Calculate the number of times the option ends in-the-money
    finalPrices = pricePaths(end, :);
    if strcmp(optionType, 'Call')
        itmCount = sum(finalPrices > K);
    elseif strcmp(optionType, 'Put')
        itmCount = sum(finalPrices < K);
    else
        disp('Option type is not recognized. Cannot calculate in-the-money occurrences.');
        return;
    end

    % Print the count to the MATLAB console
    fprintf('Number of times the option ended in-the-money: %d out of %d simulations\n', itmCount, numSims);
end