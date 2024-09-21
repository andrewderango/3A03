% Reset
clear;
clc;
close all;

% Parameters
system = @system2; % handle for the system to be tested
iterations = 10; % how many different x and initial n vectors will be generated to test their outputs against time-shifts
signal_length = 10; % the length of the test input signals
increment_delta = 1; % how much the increments are increased by when time-shifts are done on the n vector
increment_qty = 3; % how many times the n vector is time shifted per iteration
n_max = 100; % the upper bound in n vector randomization 
n_min = -100; % the lower bound in n vector randomization
x_max = 100; % the upper bound in x vector randomization 
x_min = -100; % the lower bound in x vector randomization
verbose = 0; % the level of verbose (2 = high verbosity, 0 = low verbosity; only print conclusion)

for i = 1:iterations

    % print the current iteration number
    if verbose == 2
        fprintf('\n-- ITERATION %d --\n', i);
    end

    % generate the randomized sequential initial n vector, and the randomized x vector
    n_primary_index = randi([n_min, n_max - signal_length]);
    x = x_min + (x_max - x_min) * rand(1, 10);
    n = n_primary_index : n_primary_index+signal_length-1;
    y_baseline = system(n, x); % the output of the system given x and the initial n
    
    % print values
    if verbose == 2
        fprintf('x = [%s]\n', num2str(x));
        fprintf('n_inc0 = [%s]\n', num2str(n));
        fprintf('y_inc0 = [%s]\n', num2str(y_baseline));
    end
    
    % perform time shifts on n, compare new outputs to y_baseline
    for j = 1:increment_qty
        n = n_primary_index+j : n_primary_index+signal_length+j-1; % perform time shift of n
        y = system(n, x); % find new output given time shifted n
        if verbose == 2
            fprintf('n_inc%d = [%s]\n', j, num2str(n));
            fprintf('y_inc%d = [%s]\n', j, num2str(y));
        end
        if ~isequal(y, y_baseline) % compare new output and output from initial n
            disp('The system is time-variant.')
            return; % have sufficient evidence for time variance
        end
    end
    if ~verbose == 0
        fprintf('Iteration %d: Invariant\n', i);
    end
end

% if the return line was not run, then all the time shifts rendered the same output y vectors
fprintf('\nThe system is time-invariant.\n')