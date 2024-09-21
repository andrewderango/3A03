% Reset
clear;
clc;
close all;

% Parameters
system = @system3;
iterations = 10;
signal_length = 10;
increment_delta = 1;
increment_qty = 3;
n_max = 100;
n_min = -100;
x_max = 100;
x_min = -100;
verbose = 1;

for i = 1:iterations
    if verbose == 2
        fprintf('\n-- ITERATION %d --\n', i);
    end

    n_primary_index = randi([n_min, n_max - signal_length]);
    x = x_min + (x_max - x_min) * rand(1, 10);
    n = n_primary_index : n_primary_index+signal_length-1;
    y_baseline = system(n, x);
    
    if verbose == 2
        fprintf('x = [%s]\n', num2str(x));
        fprintf('n_inc0 = [%s]\n', num2str(n));
        fprintf('y_inc0 = [%s]\n', num2str(y_baseline));
    end
    
    for j = 1:increment_qty-1
        n = n_primary_index+j : n_primary_index+signal_length+j-1;
        y = system(n, x);
        if verbose == 2
            fprintf('n_inc%d = [%s]\n', j, num2str(n));
            fprintf('y_inc%d = [%s]\n', j, num2str(y));
        end
        if ~isequal(y, y_baseline)
            disp('The system is time-variant.')
            return;
        end
    end
    fprintf('Iteration %d: Invariant\n', i);
end

fprintf('\nThe system is time-invariant.\n')