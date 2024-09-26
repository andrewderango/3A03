% Function to test the four properties of system printing results in terminal without a return,
% (system to test [function], name of system [string], to plot or not [boolean])
function testProperties(system, name, enablePlot)
    fprintf('Properties of %s:\n', name);
    
    if testLinearity(system, name, enablePlot) == true
        fprintf('\t\t\tLinear\n');
    else
        fprintf('\t\t\tNon-Linear\n');
    end
    
    if testTimeVariance(system, name, enablePlot) == true
        fprintf('\t\t\tTime Variant\n');
    else
        fprintf('\t\t\tTime Invariant\n');
    end
    
    if testCausality(system, name, enablePlot) == true
        fprintf('\t\t\tCausal\n');
    else
        fprintf('\t\t\tNon-Causal\n');
    end
    
    if testMemory(system, name, enablePlot) == true
        fprintf('\t\t\tHas Memory\n');
    else
        fprintf('\t\t\tMemoryless\n');
    end
    
    fprintf('\n');
end

% Function to test linearity of system returning true or false,
% (system to test [function], name of system [string], to plot or not [boolean])
function result = testLinearity(system, name, enablePlot)
    % Parameters
    iterations = 1000;  % number of tests completed with random signals and scaling factors
    signal_length = 11; % the length of the test input signals
    max_scaling = 100;  % max scaling factor and max amplitude of a*x1 and b*x2
    min_scaling = -100; % min scaling factor and min amplitude of a*x1 and b*x2
    tolerance = 1e-12;  % tolerance for allowable error when equating to account for floating point percision errors

    result = true; % assume true/linear by default
    
    if enablePlot == true
        figure; % create a new figure if plotting is enabled
    end    
    
    n = linspace(1-signal_length/2, signal_length/2, signal_length); % define n vector to be used throughout
    
    for i = 1:iterations
        x1 = rand(1,signal_length); % create random x1 input signal with values between 0 to 1
        x2 = rand(1,signal_length); % create random x2 input signal with values between 0 to 1
        a = randi([min_scaling, max_scaling]); % create random scaling factor a
        b = randi([min_scaling, max_scaling]); % create random scaling factor b
        y1 = system(n,x1);
        y2 = system(n,x2);
        x3 = a * x1 + b * x2; % create x3 as a linear combination of x1 and x2
        y3 = system(n,x3);
        if sum(abs(a * y1 + b * y2 - y3)) > tolerance % compare results within tolerance
            result = false; % proved false/non-linear

            % plotting non-linear case
            if enablePlot == true
                subplot(1,2,1);
                stem(n,x1,'b','DisplayName','x1');
                hold on;
                stem(n,x2,'g','DisplayName','x2');
                stem(n,x3,'r','DisplayName','x3');
                title('System Inputs');
                xlabel('[n]');
                ylabel('Amplitude'); 
                legend;
                annotation('textbox', [0.47,0.78,0.1,0.1], 'String' ,sprintf('Scaling\na = %d\nb = %d',a,b), 'HorizontalAlignment', 'center');
                hold off;
                subplot(1,2,2);
                stem(n,y1,'b','DisplayName','y1');
                hold on;
                stem(n,y2,'g','DisplayName','y2');
                stem(n,y3,'r','DisplayName','y3');
                title('System Outputs');
                xlabel('[n]');
                ylabel('Amplitude');
                legend;
                hold off;
                sgtitle(['Input and Output for ', name, ' Proving Non-Linearity'], 'FontWeight', 'bold');
            end
            return;
        end
        
        % plotting linear case if the last three tests are reached without issues
        if i > iterations-3 && enablePlot == true
            c = i-iterations+3;
            subplot(3,2,2*(c)-1);
            stem(n,x1,'b','DisplayName','x1');
            hold on;
            stem(n,x2,'g','DisplayName','x2');
            stem(n,x3,'r','DisplayName','x3');
            title(['Case ', num2str(c), ': System Inputs']);
            xlabel('[n]');
            ylabel('Amplitude');
            legend;
            annotation('textbox', [0.47,(1.07-0.29*c),0.1,0.1], 'String' ,sprintf('Scaling\na = %d\nb = %d',a,b), 'HorizontalAlignment', 'center');
            hold off;
            subplot(3,2,2*(c));
            stem(n,y1,'b','DisplayName','y1');
            hold on;
            stem(n,y2,'g','DisplayName','y2');
            stem(n,y3,'r','DisplayName','y3');
            title(['Case ', num2str(c), ': System Outputs']);
            xlabel('[n]');
            ylabel('Amplitude');
            legend;
            hold off;
            sgtitle(['Three Cases of Inputs and Outputs for ', name, ' Proving Linearity'], 'FontWeight', 'bold');
        end
    end
end

% Function to test time variance of system returning true or false,
% (system to test [function], name of system [string], to plot or not [boolean])
function result = testTimeVariance(system, name, enablePlot)
    % Parameters
    iterations = 10; % how many different x and initial n vectors will be generated to test their outputs against time-shifts
    signal_length = 10; % the length of the test input signals
    increment_delta = 1; % how much the increments are increased by when time-shifts are done on the n vector
    increment_qty = 3; % how many times the n vector is time shifted per iteration
    n_max = 100; % the upper bound in n vector randomization 
    n_min = -100; % the lower bound in n vector randomization
    x_max = 100; % the upper bound in x vector randomization 
    x_min = -100; % the lower bound in x vector randomization
    verbose = 0; % the level of verbose (2 = high verbosity, 0 = low verbosity; don't print anything)

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
            n = n_primary_index+j*increment_delta : n_primary_index+signal_length+j*increment_delta-1; % perform time shift of n
            y = system(n, x); % find new output given time shifted n
            if verbose == 2
                fprintf('n_inc%d = [%s]\n', j, num2str(n));
                fprintf('y_inc%d = [%s]\n', j, num2str(y));
            end
            if ~isequal(y, y_baseline) % compare new output and output from initial n
                result = true;
                return; % have sufficient evidence for time variance
            end
        end
        % if the return line was not run, then all the time shifts rendered the same output y vectors
        result = false;
    end
end

% Function to test causality of system returning true or false,
% (system to test [function], name of system [string], to plot or not [boolean])
function result = testCausality(system, name, enablePlot)

    result = true;

    n = 0:10;

    arr_len = 11;
    
    for i= 1:11
    
        impulse_step_zeros = zeros(1, i-1);
    
        impulse_step_values = ones(1, 11-i+1);
    
    
        %Append the two row vectors together, creating an "impulse step"
        impulse_step = [impulse_step_zeros, impulse_step_values];
    
        %get the output to see if future values determine current output
        y1 = system(n, impulse_step);
    
        %Creates a row vector of all zeros
        zero_vector = zeros(1, arr_len);
    
        %Creates a unit impulse
        zero_vector(i) = 1;
    
        %Gets the impulse response
        y2 = system(n, zero_vector);
    
        %Compares the two values if they are not equal the system is non-causal
        if y1(i) ~= y2(i)
            %fprintf("The system is non-causal: y1(%d) = %.2f, y2(%d) = %.2f\n", i, y1(i), i, y2(i));
            result = false;
            return;
        end
    
    end

end

% Function to test memory of system returning true or false,
% (system to test [function], name of system [string], to plot or not [boolean])
function result = testMemory(system, name, enablePlot)
    n = 0:10;
    arr_len = 11;
    x1 = ones(1, arr_len);

    y1 = system(n, x1);

    result = false;

    for i= 1:11

        x2 = zeros(1, arr_len);
    
        x2(i) = 1;
    
        y2 = system(n, x2);
    
        if y1(i) ~= y2(i)
            %fprintf("The system has memory: y1(%d) = %.2f, y2(%d) = %.2f\n", i, y1(i), i, y2(i));
            result = true;
            return;
    
        end

    end

end