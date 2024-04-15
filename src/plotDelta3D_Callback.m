function plotDelta3D_Callback(hObject, eventdata)
    % Fetch inputs for the first option
    S = str2double(get(findobj('Tag', 'Option1StockPrice'), 'String'));
    K = str2double(get(findobj('Tag', 'Option1StrikePrice'), 'String'));
    T = str2double(get(findobj('Tag', 'Option1TimeToMaturity'), 'String'));
    r = str2double(get(findobj('Tag', 'Option1RiskFreeRate'), 'String'));
    sigma = str2double(get(findobj('Tag', 'Option1Volatility'), 'String'));
    optionTypeHandle = findobj('Tag', 'Option1Type');
    optionTypeValue = get(optionTypeHandle, 'Value');
    optionTypeStr = get(optionTypeHandle, 'String');
    optionType = optionTypeStr{optionTypeValue};

    % Validate the fetched option inputs
    if any(isnan([S, K, T, r, sigma]))
        errordlg('Please ensure all fields for Option 1 are filled out correctly.', 'Input Error');
        return;
    end

    % Define dynamic ranges for S and T based on input values
    S_range = linspace(S * 0.5, S * 1.5, 100); % +/- 50% of entered StockPrice
    T_range = linspace(0.1, T + 1, 100);       % From 0.1 to entered TimeToMaturity plus 1 year

    % Call the plotting function
    plotDelta3D(S_range, K, T_range, r, sigma, optionType);
end