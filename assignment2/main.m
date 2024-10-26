% Reset
clear;
clc;
close all;

% list of systems to be tested and their names for use in for loop
systemList = {@ltisystemA, @ltisystemB, @ltisystemC};
systemNames = ['A', 'B', 'C'];

% for loop running each test for each system
for index = 1:length(systemList)
    system = systemList{index};
    systemName = systemNames(index);

    % section i: impulse response
    h = calcImpulseResponse(system, -10:10, false, false, systemName);

    % section ii: step response
    s = calcStepResponse(system, -10:10, false, false, systemName);

    % section iii: compare step response with cumsum of impulse response
    h_cumsum = calcCumSumImpulseResponse(system, -10:10, true, true, systemName, h, s);
    
    % calling functions for section V,VI, & VII, producing plots and printing results
    % if verifyConvolution(system, systemName)
    %     fprintf('Convolution with impulse response and direct computation are equivalent for System %s\n', systemName);
    % else
    %     fprintf('Convolution with impulse response and direct computation are NOT equivalent for System %s\n', systemName);
    % end
end

% section i: returns the unit impulse response of a system
function h = calcImpulseResponse(system, n, verbose, showPlot, systemName)

    % compute the impulse response
    delta = zeros(1, length(n));
    delta(n == 0) = 1;
    h = system(n, delta);

    % print the impulse response vector if verbose is 1
    if verbose == 1
        fprintf('Impulse response vector for %s:\n', systemName);
        disp(h);
    end

    % plot h if showPlot is true
    if showPlot
        figure;
        stem(n, h);
        xlabel('n');
        ylabel('h[n]');
        title(['Impulse Response of ', systemName]);
        grid on;
    end
end

% section ii: returns the unit step response of a system
function s = calcStepResponse(system, n, verbose, showPlot, systemName)

    % compute the step response
    u = zeros(1, length(n));
    u(n >= 0) = 1;
    s = system(n, u);

    % print the step response vector if verbose is 1
    if verbose == 1
        fprintf('Step response vector for %s:\n', systemName);
        disp(s);
    end

    % plot s if showPlot is true
    if showPlot
        figure;
        stem(n, s);
        xlabel('n');
        ylabel('s[n]');
        title(['Step Response of ', systemName]);
        grid on;
    end
end

% section iii: compare unit step response with the cumsum of impulse response
function h_cumsum = calcCumSumImpulseResponse(system, n, verbose, showPlot, systemName, h, s)

    % compute the cumsum of the impulse response
    h_cumsum = cumsum(h);

    % print the step response vector if verbose is 1
    if verbose == 1
        fprintf('Step response vector for %s:\n', systemName);
        disp(s);
        fprintf('Cumsum of impulse response vector for %s:\n', systemName);
        disp(h_cumsum);
    end

    % plot s and h_cumsum if showPlot is true
    if showPlot
        figure;
        stem(n, s, 'b', 'DisplayName', 'Step Response', 'Marker', 'o', 'LineStyle', '-');
        hold on;
        stem(n, h_cumsum, 'r', 'DisplayName', 'Cumsum of Impulse Response', 'Marker', 'x', 'LineStyle', '--');
        xlabel('n');
        ylabel('Response');
        title(['Step Response and Cumsum of Impulse Response of ', systemName]);
        legend('Location', 'southoutside');
        grid on;
        hold off;
    end
end

% function for section V
% returns the output signal of the system with the ECG input signal
function y = calcECGResponse(system)
    file = load('ECG_assignment2.mat');
    x = file.x;         % gets the input signal from the file
    n = 0:length(x)-1;  % time steps from 0 to the length of the array
    y = system(n, x);   % return output signal
end

% function for section VI
% returns the output signal of the system with the respiration input signal
function y = calcRespirationResponse(system)
    file = load('respiration_assignment2.mat');
    x = file.x;         % gets the input signal from the file
    n = 0:length(x)-1;  % time steps from 0 to the length of the array
    y = system(n, x);   % return output signal
end

% function for section VII
function result = verifyConvolution(system, systemName)
    tolerance = 1e-12;  % tolerance for checking equivalence
    result = true;      % assume true unless proven false
    
    file = load('ECG_assignment2.mat');
    x = file.x;                         % gets the input signal from the file
    y1 = calcECGResponse(system);       % computes output signal directly
    n = 0:length(x)-1;
    h = calcImpulseResponse(system, n); % impulse response for system
    y2 = conv(h,x);                     % computes output signal by convolution
    minLength = min(length(y1), length(y2));
    y1 = y1(1:minLength);               % makes both arrays the same length as the shorter one
    y2 = y2(1:minLength);
    if any(y1 - y2 > tolerance)         % checks equivalence
        result = false;
    end
    
    % plots both ECG output signals for visual comparison
    figure;
    subplot(2,2,1);
    plot(n,y1,'r','DisplayName','ECG_Direct_Computation');
    hold on;
    title('ECG Output Signal by Direct Computation');
    xlabel('n');
    ylabel('Amplitude'); 
    hold off;
    subplot(2,2,2);
    plot(n,y2,'r','DisplayName','ECG_Convolution');
    hold on;
    title('ECG Output Signal by Impulse Convolution');
    xlabel('n');
    ylabel('Amplitude');
    hold off;
    sgtitle(['Comparison between Direct Computation and Impulse Convolution for the ECG signal and Respiration Signal with System ', systemName], 'FontWeight', 'bold');
    
    file = load('respiration_assignment2.mat');
    x = file.x;                             % gets the input signal from the file
    y1 = calcRespirationResponse(system);   % computes output signal directly
    n = 0:length(x)-1;
    h = calcImpulseResponse(system, n);     % impulse response for system
    y2 = conv(h,x);                         % computes ouput signal by convolution
    minLength = min(length(y1), length(y2));
    y1 = y1(1:minLength);                   % makes both arrays teh same length as teh shorter one
    y2 = y2(1:minLength);
    if any(y1 - y2 > tolerance)             % checks equivalence
        result = false;
    end    
    
    % plots both respiration output signals for visual comparison
    subplot(2,2,3);
    plot(n,y1,'b','DisplayName','Respiration_Direct_Computation');
    hold on;
    title('Respiration Output Signal by Direct Computation');
    xlabel('n');
    ylabel('Amplitude'); 
    hold off;
    subplot(2,2,4);
    plot(n,y2,'b','DisplayName','Respiration_Convolution');
    hold on;
    title('Respiration Output Signal by Impulse Convolution');
    xlabel('n');
    ylabel('Amplitude');
    hold off;
end