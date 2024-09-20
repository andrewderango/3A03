function y = system0(n,x)
% SYSTEM0 Implements a specific discrete-time system for Assignment #1 of
% IBEHS 3A03: Biomedical Signals and Systems in Fall 2024
%
% y = system0(n,x)
%
%     n is a vector of time step values for the input signal
%     x is a vector describing the D-T input signal x[n]
%
%     y is a vector describing the D-T output signal y[n]

% solves the difference equation y[n] = 0.25 x[n] + 0.5 x[n-1] + 0.25 x[n-2] recursively for the input signal x[n]
% with zero initial conditions, i.e., the input signal x[n] = 0 before the start of the given input array x

% coefficients for difference equation
b0 = 0.25; % first b coefficient
b1 = 0.5;   % second b coefficient
b2 = 0.25; % third b coefficient

B = 2; % number of b coefficients minus 1; corresponds to how many time steps the difference equation looks back

[rows,cols] = size(n); % size of input signal x[n]

if rows>cols % determine whether x[n] is a column array or a row array

    x_tmp = [zeros(B,1); x]; % append zero initial conditions to x[n]

else

    x_tmp = [zeros(1,B) x]; % append zero initial conditions to x[n]

end

y = zeros(size(x)); % array for output signal y[n]

for i = 1+B:max(rows,cols)+B % do recursion; indexing is offset by an amount B,
                                                % so that the difference equation can look back in
                                                % time B time steps at the start

    y(i-B) = b0*x_tmp(i)+b1*x_tmp(i-1)+b2*x_tmp(i-2); % solve difference equation

end

% linear
% time-invariant
% causal
% memory

end
