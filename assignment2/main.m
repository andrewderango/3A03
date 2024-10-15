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
    
    % calling functions for section V,VI, & VII, producing plots and 
    % printing results
    if verifyConvolution(system, systemName)
        fprintf('Convolution with impulse response and direct computation are equivalent for System %s\n', systemName);
    else
        fprintf('Convolution with impulse response and direct computation are NOT equivalent for System %s\n', systemName);
    end
end

% function for section I
% returns the unit impluse response of a system
function h = calcImpulseResponse(system, n)
    delta = zeros(1, length(n));
    delta(n==0) = 1;
    h = system(n, delta);
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