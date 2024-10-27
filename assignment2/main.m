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
    n = -10:10;

    % section i: impulse response
    h = calcImpulseResponse(system, n, 0, false, systemName);

    % section ii: step response
    s = calcStepResponse(system, n, 0, false, systemName);

    % section iii: compare step response with cumsum of impulse response
    h_cumsum = calcCumSumImpulseResponse(system, n, false, false, systemName, h, s);

    % section iv: compare impulse response with first diff of step response
    s_diff = calcStepResponseDiff(system, n, false, true, systemName, h, s);
    
    % calling functions for section V,VI, & VII, producing plots and printing results
    verifyConvolution(system, systemName, true);

    formalLogicalTest(system, systemName, h, s, n);

    filterTest(system, systemName, h, 1);

end

% section i: returns the unit impulse response of a system
function h = calcImpulseResponse(system, n, verbose, showPlot, systemName)

    % compute the impulse response
    delta = zeros(1, length(n));
    delta(n == 0) = 1;
    h = system(n, delta);

    % print the impulse response vector if verbose is 1
    if verbose == 1
        fprintf('Impulse response vector for System %s:\n', systemName);
        disp(h);
    end

    % plot h if showPlot is true
    if showPlot
        figure;
        stem(n, h);
        xlabel('n');
        ylabel('h[n]');
        title(['Impulse Response of System ', systemName]);
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
        fprintf('Step response vector for System %s:\n', systemName);
        disp(s);
    end

    % plot s if showPlot is true
    if showPlot
        figure;
        stem(n, s);
        xlabel('n');
        ylabel('s[n]');
        title(['Step Response of System ', systemName]);
        grid on;
    end
end

% section iii: compare unit step response with the cumsum of impulse response
function h_cumsum = calcCumSumImpulseResponse(system, n, verbose, showPlot, systemName, h, s)

    % compute the cumsum of the impulse response
    h_cumsum = cumsum(h);

    % print the comp vectors if verbose is on
    if verbose == 1
        fprintf('Step response vector for System %s:\n', systemName);
        disp(s);
        fprintf('Cumsum of impulse response vector for System %s:\n', systemName);
        disp(h_cumsum);
    end

    % plot s and h_cumsum if showPlot is true
    if showPlot
        figure;
        stem(n, s, 'b', 'DisplayName', 'Step Response', 'Marker', 'o', 'LineStyle', '-');
        hold on;
        stem(n, h_cumsum, 'r', 'DisplayName', 'Cumsum of Impulse Response', 'Marker', 'x', 'LineStyle', '--');
        xlabel('n');
        ylabel('y[n]');
        title(['Step Response and Cumsum of Impulse Response of System ', systemName]);
        legend('Location', 'southoutside');
        grid on;
        hold off;
    end
end

% section iv: compare impulse response with first diff of step response
function s_diff = calcStepResponseDiff(system, n, verbose, showPlot, systemName, h, s)

    % compute the first difference of the step response
    s_diff = diff([0, s]);

    % print the comp vectors if verbose is on
    if verbose == 1
        fprintf('Step response vector for System %s:\n', systemName);
        disp(s);
        fprintf('Cumsum of impulse response vector for System %s:\n', systemName);
        disp(h_cumsum);
    end

    % plot h and s_diff if showPlot is on
    if showPlot
        figure;
        stem(n, h, 'b', 'DisplayName', 'Impulse Response', 'Marker', 'o', 'LineStyle', '-');
        hold on;
        stem(n, s_diff, 'r', 'DisplayName', 'First Difference of Step Response', 'Marker', 'x', 'LineStyle', '--');
        xlabel('n');
        ylabel('y[n]');
        title(['Impulse Response and First Difference of Step Response of System ', systemName]);
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
function result = verifyConvolution(system, systemName, showPlot)
    tolerance = 1e-12;  % tolerance for checking equivalence
    result = true;      % assume true unless proven false
    
    file = load('ECG_assignment2.mat');
    x = file.x;                         % gets the input signal from the file
    y1 = calcECGResponse(system);       % computes output signal directly
    n = 0:length(x)-1;
    h = calcImpulseResponse(system, n, 0, false, systemName); % impulse response for system
    y2 = conv(h,x);                     % computes output signal by convolution
    minLength = min(length(y1), length(y2));
    y1 = y1(1:minLength);               % makes both arrays the same length as the shorter one
    y2 = y2(1:minLength);
    if any(abs(y1 - y2) > tolerance)         % checks equivalence
        result = false;
    end
    
    if (showPlot == true)
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
    end

    file = load('respiration_assignment2.mat');
    x = file.x;                             % gets the input signal from the file
    y1 = calcRespirationResponse(system);   % computes output signal directly
    n = 0:length(x)-1;
    h = calcImpulseResponse(system, n, 0, false, systemName);     % impulse response for system
    y2 = conv(h,x);                         % computes ouput signal by convolution
    minLength = min(length(y1), length(y2));
    y1 = y1(1:minLength);                   % makes both arrays teh same length as teh shorter one
    y2 = y2(1:minLength);
    if any(abs(y1 - y2) > tolerance)             % checks equivalence
        result = false;
    end    
    

    % plots both respiration output signals for visual comparison

    if (showPlot == true)
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
end

% function for Bonus 1

function formalLogicalTest(system, systemName, h, s, n) 

    tolerance = 1e-12;

    %Logical Test III
    fprintf('Performing Logical Test III for %s:\n', systemName);

    h_cumsum = cumsum(h);

    s = calcStepResponse(system, n, 0, false, systemName);

    if ~any(abs(h_cumsum - s) > tolerance )
        fprintf('The cumsum of the unit impulse response is equivalent to the unit step function response for system %s\n\n', systemName);
    end

    %Logical Test IV
    fprintf('Performing Logical Test IV for %s:\n', systemName);

    s_diff = calcStepResponseDiff(system, n, 0, false, systemName, h, s);

    if ~any(abs(h - s_diff) > tolerance)
        fprintf('The first difference of the unit step response and the impulse response are equivalent for system %s\n\n', systemName);
    end

    %Logical Test VII

    fprintf('Performing Logical Test VII for %s:\n', systemName);

    result = verifyConvolution(system, systemName, false);

    if result
        fprintf('Convolution with impulse response and direct computation are equivalent for System %s\n\n', systemName);
    else
        fprintf('Convolution with impulse response and direct computation are NOT equivalent for System %s\n\n', systemName);
    end


end

function filterTest(system, systemName, h, verbose)

    % Compute the Fourier Transform of the impulse response
    fTransformImpulse = fft(h);

    %Number of points
    N = 21; 
    delta_t = 1;
    Fs = 1 / delta_t; 
    
    % Frequencies only up to the nyquist frequency
    f = (0:N/2)*(Fs/N);

    % Take only the first half of the FFT result (positive frequencies)
    fTransformImpulse_positive = fTransformImpulse(1:N/2+1);

    %Get high and low frequency responses
    low_freq_response = max(abs(fTransformImpulse_positive(1:round(N/10))));
    high_freq_response = max(abs(fTransformImpulse_positive(round(N/2-N/10):end)));

    %Check to see what kind of filter
    if low_freq_response > high_freq_response
        fprintf('System %s is a low-pass filter\n', systemName);
    elseif high_freq_response > low_freq_response
        fprintf('System %s is a high-pass filter\n', systemName);
    else
        fprintf('System %s is a band-pass filter\n', systemName);
    end

    if (verbose == 1)
        figure;
        plot(f, abs(fTransformImpulse_positive));
        title(['Frequency Response of System', systemName]);
        xlabel('Normalized Frequency');
        ylabel('Magnitude');
        grid on;
    end
end


