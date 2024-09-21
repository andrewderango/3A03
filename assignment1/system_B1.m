function y = system_B1(n,x)
    % SYSTEM_B1 Implements a specific discrete-time system for Assignment #1 of
    % IBEHS 3A03: Biomedical Signals and Systems in Fall 2024, for bonus
    % question 1
    %
    % y = system_B1(n,x)
    %
    %     n is a vector of time step values for the input signal
    %     x is a vector describing the D-T input signal x[n]
    %
    %     y is a vector describing the D-T output signal y[n]
    
    % solves the difference equation y[n] = sin(n * x[n-1]) recursively for the input signal x[n]
    % with zero initial conditions, i.e., the input signal x[n] = 0 before the start of the given input array x
    
    y = zeros(size(x)); % initialize array for output signal y[n]
    y(1) = 0; % unknown x[n-1] but must be 0 because n=0 and sin(0)=0
    
    for i = 2:length(n) % start at 2 to skip IC (always first index)
        y(i) = sin(n(i) * x(i-1)); % solve difference equation
    end
    
    % nonlinear
    % time-variant
    % causal
    % memory

end
