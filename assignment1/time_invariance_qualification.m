% Reset
clear;
clc;
close all;

% Parameters
system = @system2; % handle for the system to be tested
iterations = 10; % how many different x and initial n vectors will be generated to test their outputs against time-shifts
signal_length = 10; % the length of the test input signals
increment_delta = 15; % how much the increments are increased by when time-shifts are done on the n vector
increment_qty = 2; % how many times the n vector is time shifted per iteration
n_max = 100; % the upper bound in n vector randomization 
n_min = -100; % the lower bound in n vector randomization
x_max = 100; % the upper bound in x vector randomization 
x_min = -100; % the lower bound in x vector randomization
show_plots = true; % boolean of whether to show the plots
verbose = 2; % the level of verbose (2 = high verbosity, 0 = low verbosity; only print conclusion)

% function to plot a time-variant iteration
function plotTimeVariantIteration(all_n, all_y, increment_qty)
    figure;
    hold on;
    plot(all_n{1}, all_y{1}, '-o', 'DisplayName', 'Baseline (No Shift)');
    for k = 1:increment_qty
        plot(all_n{k + 1}, all_y{k + 1}, '-o', 'DisplayName', ['Shift ', num2str(k)]);
    end
    title('Time-Variant Iteration');
    xlabel('n');
    ylabel('System Output y');
    legend('show');
    hold off;
end

% function to plot a time-invariant iteration
function plotTimeInvariantIteration(all_n, all_y, increment_qty)
    figure;
    hold on;
    plot(all_n{1}, all_y{1}, '-o', 'DisplayName', 'Baseline (No Shift)');
    for k = 1:increment_qty
        plot(all_n{k + 1}, all_y{k + 1}, '-o', 'DisplayName', ['Shift ', num2str(k)]);
    end
    title('Time-Invariant Iteration');
    xlabel('n');
    ylabel('System Output y');
    legend('show');
    hold off;
end

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
    
    % store the values for plotting at the end
    all_n = cell(increment_qty+1, 1);
    all_y = cell(increment_qty+1, 1);
    all_n{1} = n; % n vector for baseline
    all_y{1} = y_baseline; % y vector for baseline

    % perform time shifts on n, compare new outputs to y_baseline
    for j = 1:increment_qty
        n = n_primary_index+j*increment_delta : n_primary_index+signal_length+j*increment_delta-1; % perform time shift of n
        y = system(n, x); % find new output given time shifted n
        
        all_n{j + 1} = n; % store for plotting
        all_y{j + 1} = y; % store for plotting

        if verbose == 2
            fprintf('n_inc%d = [%s]\n', j, num2str(n));
            fprintf('y_inc%d = [%s]\n', j, num2str(y));
        end
        if ~isequal(y, y_baseline) % compare new output and output from initial n
            disp('The system is time-variant.')
            if show_plots
                plotTimeVariantIteration(all_n, all_y, increment_qty); % if time variant, then show the plot
            end
            return; % have sufficient evidence for time variance
        end
    end
    if ~verbose == 0
        fprintf('Iteration %d: Invariant\n', i);
    end
end

% if the return line was not run, then all the time shifts rendered the same output y vectors
fprintf('\nThe system is time-invariant.\n')

% plot the first iteration where the system is time-invariant
if show_plots
    plotTimeInvariantIteration(all_n, all_y, increment_qty);
end