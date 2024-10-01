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
                title([name, ' Inputs']);
                xlabel('n');
                ylabel('Input Amplitude'); 
                legend;
                annotation('textbox', [0.47,0.78,0.1,0.1], 'String' ,sprintf('Scaling\na = %d\nb = %d',a,b), 'HorizontalAlignment', 'center');
                hold off;
                subplot(1,2,2);
                stem(n,y1,'b','DisplayName','y1');
                hold on;
                stem(n,y2,'g','DisplayName','y2');
                stem(n,y3,'r','DisplayName','y3');
                stem(n,a*y1+b*y2,'p','DisplayName','a*y1+b*y2');
                title([name, ' Outputs']);
                xlabel('n');
                ylabel('Output Amplitude');
                legend;
                hold off;
                sgtitle(['Test Case Proving Non-Linearity for ', name], 'FontWeight', 'bold');
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
            title([name, ' Inputs (Test Case ', num2str(c), ')']);
            xlabel('n');
            ylabel('Input Amplitude');
            legend;
            annotation('textbox', [0.47,(1.07-0.29*c),0.1,0.1], 'String' ,sprintf('Scaling\na = %d\nb = %d',a,b), 'HorizontalAlignment', 'center');
            hold off;
            subplot(3,2,2*(c));
            stem(n,y1,'b','DisplayName','y1');
            hold on;
            stem(n,y2,'g','DisplayName','y2');
            stem(n,y3,'r','DisplayName','y3');
            stem(n,a*y1+b*y2,'p','DisplayName','a*y1+b*y2');
            title([name, ' Outputs (Test Case ', num2str(c), ')']);
            xlabel('n');
            ylabel('Output Amplitude');
            legend;
            hold off;
            sgtitle(['Test Cases Suggesting Linearity for ', name], 'FontWeight', 'bold');
        end
    end
end

% function to test time variance of system, returning true or false
function result = testTimeVariance(system, name, enablePlot)

    % nested function to plot a time-variant iteration
    function plotTimeVariantIteration(name, all_n, all_x, all_y, increment_qty, increment_delta)
    
        % generate fig
        figure;
        hold on;
        sgtitle(['Test Case Proving Time Variance for ', name], 'FontWeight', 'bold');
        
        % plot inputs (x)
        subplot(1,2,1);
        hold on;
        stem(all_n{1}, all_x{1}, 'DisplayName', 'x[n]', 'LineStyle', '-');
        for k = 1:increment_qty
            stem(all_n{k + 1}, all_x{k + 1}, 'DisplayName', ['x[n-', num2str(k * increment_delta), ']'], 'LineStyle', '-'); % plot the time shifts
        end
        title([name, ' Inputs']);
        xlabel('n');
        ylabel('Input Amplitude');
        legend('show');
        hold off;
    
        % plot outputs (y)
        subplot(1,2,2);
        hold on;
        stem(all_n{1}, all_y{1}, 'DisplayName', 'y[n]', 'LineStyle', '-');
        for k = 1:increment_qty
            stem(all_n{k + 1}, all_y{k + 1}, 'DisplayName', ['y[n-', num2str(k * increment_delta), ']'], 'LineStyle', '-'); % plot the time shifts
        end
        title([name, ' Outputs']);
        xlabel('n');
        ylabel('Output Amplitude');
        legend('show');
        hold off;
    end

    % nested function to plot a time-invariant iteration
    function plotTimeInvariantIteration(name, invariant_cases_n, invariant_cases_x, invariant_cases_y, increment_qty, increment_delta)
        
        % generate fig
        figure;
        hold on;
        sgtitle(['Test Cases Suggesting Time Invariance for ', name], 'FontWeight', 'bold');
        
        for k = 1:3

            % plot inputs (x)
            subplot(3, 2, (k-1) * 2 + 1);
            hold on;
            stem(invariant_cases_n{k}{1}, invariant_cases_x{k}{1}, 'DisplayName', 'x[n]', 'LineStyle', '-');
            for l = 2:increment_qty % only print the first shifts for visual clarity
                stem(invariant_cases_n{k}{l}, invariant_cases_x{k}{l}, 'DisplayName', ['x[n-', num2str((l-1) * increment_delta), ']'], 'LineStyle', '-');
                title([name, ' Inputs (Test Case ', num2str(k), ')']);
                xlabel('n');
                ylabel('Input Amplitude');
            end
            legend('show');
            hold off;
    
            % plot outputs (y)
            subplot(3, 2, (k-1) * 2 + 2);
            hold on;
            stem(invariant_cases_n{k}{1}, invariant_cases_y{k}{1}, 'DisplayName', 'y[n]', 'LineStyle', '-');
            for l = 2:increment_qty % only print the first shifts for visual clarity
                stem(invariant_cases_n{k}{l}, invariant_cases_y{k}{l}, 'DisplayName', ['y[n-', num2str((l-1) * increment_delta), ']'], 'LineStyle', '-');
                title([name, ' Outputs (Test Case ', num2str(k), ')']);
                xlabel('n');
                ylabel('Output Amplitude');
            end
            legend('show');
            hold off;
        end
    end

    % parameters
    iterations = 10; % how many different x and initial n vectors will be generated to test their outputs against time-shifts
    signal_length = 10; % the length of the test input signals
    increment_delta = 15; % how much the increments are increased by when time-shifts are done on the n vector
    increment_qty = 2; % how many times the n vector is time shifted per iteration
    n_max = 100; % the upper bound in n vector randomization 
    n_min = -100; % the lower bound in n vector randomization
    x_max = 100; % the upper bound in x vector randomization 
    x_min = -100; % the lower bound in x vector randomization
    verbose = 0; % the level of verbose (2 = high verbosity, 0 = low verbosity; only print conclusion)

    % store the values for plotting, long-term storage
    invariant_cases_n = cell(3, 1);
    invariant_cases_x = cell(3, 1);
    invariant_cases_y = cell(3, 1);

    for i = 1:iterations
    
        % print the current iteration number
        if verbose == 2
            fprintf('\n-- ITERATION %d --\n', i);
        end
    
        % generate the randomized sequential initial n vector, and the randomized x vector
        n_primary_index = randi([n_min, n_max - signal_length]);
        x = x_min + (x_max - x_min) * rand(1, signal_length);
        n = n_primary_index : n_primary_index + signal_length - 1;
        y_baseline = system(n, x); % the output of the system given x and the initial n
        
        % print values
        if verbose == 2
            fprintf('x = [%s]\n', num2str(x));
            fprintf('n_inc0 = [%s]\n', num2str(n));
            fprintf('y_inc0 = [%s]\n', num2str(y_baseline));
        end
        
        % store the values for plotting, current iteration
        all_n = cell(increment_qty + 1, 1);
        all_x = cell(increment_qty + 1, 1);
        all_y = cell(increment_qty + 1, 1);

        % fill in the first elements from the baseline inputs and outputs
        all_n{1} = n;
        all_x{1} = x;
        all_y{1} = y_baseline;
    
        % perform time shifts on n, compare new outputs to y_baseline
        for j = 1:increment_qty
            n_shifted = n_primary_index + j * increment_delta : n_primary_index + signal_length + j * increment_delta - 1; % perform time shift of n
            y_shifted = system(n_shifted, x); % find new output given time shifted n
            
            all_n{j + 1} = n_shifted; % store for plotting
            all_x{j + 1} = x; % x does not change
            all_y{j + 1} = y_shifted; % store for plotting
    
            if verbose == 2
                fprintf('n_inc%d = [%s]\n', j, num2str(n_shifted));
                fprintf('y_inc%d = [%s]\n', j, num2str(y_shifted));
            end
            if ~isequal(y_shifted, y_baseline) % compare new output and output from initial n
                result = true;
                if enablePlot
                    plotTimeVariantIteration(name, all_n, all_x, all_y, increment_qty, increment_delta); % if time variant, then show the plot
                end
                return; % have sufficient evidence for time variance
            end
        end

        if i > iterations - 3
            invariant_cases_n{3 - iterations + i} = all_n;
            invariant_cases_x{3 - iterations + i} = all_x;
            invariant_cases_y{3 - iterations + i} = all_y;
        end
        
        if verbose ~= 0
            fprintf('Iteration %d: Invariant\n', i);
        end
    end
    
    % if the return line was not run, then all the time shifts rendered the same output y vectors
    result = false;
    
    % plot the first iteration where the system is time-invariant
    if enablePlot
        plotTimeInvariantIteration(name, invariant_cases_n, invariant_cases_x, invariant_cases_y, increment_qty, increment_delta);
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

            %Printing the non-causal case if the two values are not equal

            if enablePlot == true
                figure;
            
                subplot(2,2,1);
                stem(n, impulse_step, 'b', 'DisplayName', 'x1');
                hold on; 
                stem(n(i), impulse_step(i), 'ro', 'DisplayName', 'Non-causal value'); 
                text(n(i), impulse_step(i), ['(', num2str(n(i)), ', ', num2str(impulse_step(i)), ')'], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
                hold off;
                title(['Input 1 for ',name]);
                xlabel('n');
                ylabel('Input Amplitude'); 
                ylim([min([impulse_step, y1, y2, zero_vector]), max([impulse_step, y1, y2, zero_vector])]); 
                legend;
            
                subplot(2, 2, 2);
                stem(n, y1, 'b', 'DisplayName', 'y1'); 
                hold on;
                stem(n(i), y1(i), 'ro', 'DisplayName', 'Non-causal value'); 
                text(n(i), y1(i), ['(', num2str(n(i)), ', ', num2str(y1(i)), ')'], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
                hold off;
                title(['Output 1 for ',name]);
                xlabel('n');
                ylabel('Output Amplitude');
                ylim([min([impulse_step, y1, y2, zero_vector]), max([impulse_step, y1, y2, zero_vector])]);
                legend;

                subplot(2,2,3);
                stem(n, zero_vector, 'b', 'DisplayName', 'x2');
                hold on;
                stem(n(i), zero_vector(i), 'ro', 'DisplayName', 'Non-causal value'); 
                text(n(i), zero_vector(i), ['(', num2str(n(i)), ', ', num2str(zero_vector(i)), ')'], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
                hold off;
                title(['Input 2 for ',name]);
                xlabel('n');
                ylabel('Input Amplitude'); 
                ylim([min([impulse_step, y1, y2, zero_vector]), max([impulse_step, y1, y2, zero_vector])]);
                legend;
            
                subplot(2, 2, 4);
                stem(n, y2, 'b', 'DisplayName', 'y2'); 
                hold on;
                stem(n(i), y2(i), 'ro', 'DisplayName', 'Non-causal value'); 
                text(n(i), y2(i), ['(', num2str(n(i)), ', ', num2str(y2(i)), ')'], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
                hold off;
                title(['Output 2 for ',name]);
                xlabel('n');
                ylabel('Output Amplitude');
                ylim([min([impulse_step, y1, y2, zero_vector]), max([impulse_step, y1, y2, zero_vector])]);
                legend;
            
                sgtitle(['Test Case Proving Non-Causality for ', name], 'FontWeight', 'bold');
            end

            return;
        end
    
    end

    if enablePlot == true

        i = 2;

        impulse_step_zeros = zeros(1, i-1);
        impulse_step_values = ones(1, 11-i+1);
        impulse_step = [impulse_step_zeros, impulse_step_values];
    
        y1 = system(n, impulse_step);
    
        zero_vector = zeros(1, arr_len);
        zero_vector(i) = 1;
    
        y2 = system(n, zero_vector);

        figure;
        subplot(2,2,1);
        stem(n, impulse_step, 'b', 'DisplayName', 'x1');
        hold on; 
        stem(n(i), impulse_step(i), 'ro', 'DisplayName', 'Example causal value'); 
        text(n(i), impulse_step(i), ['(', num2str(n(i)), ', ', num2str(impulse_step(i)), ')'], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
        hold off;
        title(['Input 1 for ',name]);
        xlabel('n');
        ylabel('Input Amplitude'); 
        ylim([min([impulse_step, y1, y2, zero_vector]), max([impulse_step, y1, y2, zero_vector])]); 
        legend;
    
        subplot(2, 2, 2);
        stem(n, y1, 'b', 'DisplayName', 'y1'); 
        hold on;
        stem(n(i), y1(i), 'ro', 'DisplayName', 'Example causal value'); 
        text(n(i), y1(i), ['(', num2str(n(i)), ', ', num2str(y1(i)), ')'], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
        hold off;
        title(['Output 1 for ',name]);
        xlabel('n');
        ylabel('Output Amplitude');
        ylim([min([impulse_step, y1, y2, zero_vector]), max([impulse_step, y1, y2, zero_vector])]);
        legend;

        subplot(2,2,3);
        stem(n, zero_vector, 'b', 'DisplayName', 'x2');
        hold on;
        stem(n(i), zero_vector(i), 'ro', 'DisplayName', 'Example causal value'); 
        text(n(i), zero_vector(i), ['(', num2str(n(i)), ', ', num2str(zero_vector(i)), ')'], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
        hold off;
        title(['Input 2 for ',name]);
        xlabel('n');
        ylabel('Input Amplitude'); 
        ylim([min([impulse_step, y1, y2, zero_vector]), max([impulse_step, y1, y2, zero_vector])]);
        legend;
    
        subplot(2, 2, 4);
        stem(n, y2, 'b', 'DisplayName', 'y2'); 
        hold on;
        stem(n(i), y2(i), 'ro', 'DisplayName', 'Example causal value'); 
        text(n(i), y2(i), ['(', num2str(n(i)), ', ', num2str(y2(i)), ')'], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
        hold off;
        title(['Output 2 for ',name]);
        xlabel('n');
        ylabel('Output Amplitude');
        ylim([min([impulse_step, y1, y2, zero_vector]), max([impulse_step, y1, y2, zero_vector])]);
        legend;
    
        sgtitle(['Test Case Suggesting Causality for ', name], 'FontWeight', 'bold');

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
            result = true;

            if enablePlot == true
                figure;

                % Plot Input 1 (x1)
                subplot(2,2,1);
                stem(n, x1, 'b', 'DisplayName', 'x1');
                hold on;
                stem(n(i), x1(i), 'ro', 'DisplayName', 'Memory value');
                text(n(i), x1(i), ['(', num2str(n(i)), ', ', num2str(x1(i)), ')'], ...
                     'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 8);
                hold off;
                title(['Input 1 for ', name]);
                xlabel('n');
                ylabel('Input Amplitude');
                ylim([min([x1, y1, y2]), max([x1, y1, y2])]);
                legend;

                % Plot Output 1 (y1)
                subplot(2,2,2);
                stem(n, y1, 'b', 'DisplayName', 'y1');
                hold on;
                stem(n(i), y1(i), 'ro', 'DisplayName', 'Memory value');
                text(n(i), y1(i), ['(', num2str(n(i)), ', ', num2str(y1(i)), ')'], ...
                     'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 8);
                hold off;
                title(['Output 1 for ', name]);
                xlabel('n');
                ylabel('Output Amplitude');
                ylim([min([x1, y1, y2]), max([x1, y1, y2])]);
                legend;

                 % Plot Input 2 (x2)
                 subplot(2,2,3);
                 stem(n, x2, 'b', 'DisplayName', 'x2');
                 hold on;
                 stem(n(i), x2(i), 'ro', 'DisplayName', 'Memory value');
                 text(n(i), x2(i), ['(', num2str(n(i)), ', ', num2str(x2(i)), ')'], ...
                      'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 8);
                 hold off;
                 title(['Input 2 for ', name]);
                 xlabel('n');
                 ylabel('Input Amplitude');
                 ylim([min([x1, y1, y2]), max([x1, y1, y2])]);
                 legend;

                % Plot Output 2 (y2)
                subplot(2,2,4);
                stem(n, y2, 'b', 'DisplayName', 'y2');
                hold on;
                stem(n(i), y2(i), 'ro', 'DisplayName', 'Memory value');
                text(n(i), y2(i), ['(', num2str(n(i)), ', ', num2str(y2(i)), ')'], ...
                     'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 8);
                hold off;
                title(['Output 2 for ', name]);
                xlabel('n');
                ylabel('Output Amplitude');
                ylim([min([x1, y1, y2]), max([x1, y1, y2])]);
                legend;

                sgtitle(['Test Case Proving Memory for ', name], 'FontWeight', 'bold');
            end
            return;
        end
    end

    if enablePlot == true
        i = 2;

        x2 = zeros(1, arr_len);
        x2(i) = 1;
    
        y2 = system(n, x2);

        figure;

        % Plot Input 1 (x1)
        subplot(2,2,1);
        stem(n, x1, 'b', 'DisplayName', 'x1');
        hold on;
        stem(n(i), x1(i), 'ro', 'DisplayName', 'Memoryless value');
        text(n(i), x1(i), ['(', num2str(n(i)), ', ', num2str(x1(i)), ')'], ...
            'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 8);
        hold off;
        title(['Input 1 for ', name]);
        xlabel('n');
        ylabel('Input Amplitude');
        ylim([min([x1, y1, y2]), max([x1, y1, y2])]);
        legend;

        % Plot Output 1 (y1)
        subplot(2,2,2);
        stem(n, y1, 'b', 'DisplayName', 'y1');
        hold on;
        stem(n(i), y1(i), 'ro', 'DisplayName', 'Memoryless value');
        text(n(i), y1(i), ['(', num2str(n(i)), ', ', num2str(y1(i)), ')'], ...
            'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 8);
        hold off;
        title(['Output 1 for ', name]);
        xlabel('n');
        ylabel('Output Amplitude');
        ylim([min([x1, y1, y2]), max([x1, y1, y2])]);
        legend;

        % Plot Input 2 (x2)
        subplot(2,2,3);
        stem(n, x2, 'b', 'DisplayName', 'x2');
        hold on;
        stem(n(i), x2(i), 'ro', 'DisplayName', 'Memoryless value');
        text(n(i), x2(i), ['(', num2str(n(i)), ', ', num2str(x2(i)), ')'], ...
            'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 8);
        hold off;
        title(['Input 2 for ', name]);
        xlabel('n');
        ylabel('Input Amplitude');
        ylim([min([x1, y1, y2]), max([x1, y1, y2])]);
        legend;

        % Plot Output 2 (y2)
        subplot(2,2,4);
        stem(n, y2, 'b', 'DisplayName', 'y2');
        hold on;
        stem(n(i), y2(i), 'ro', 'DisplayName', 'Memoryless value');
        text(n(i), y2(i), ['(', num2str(n(i)), ', ', num2str(y2(i)), ')'], ...
            'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 8);
        hold off;
        title(['Output 2 for ', name]);
        xlabel('n');
        ylabel('Output Amplitude');
        ylim([min([x1, y1, y2]), max([x1, y1, y2])]);
        legend;

        sgtitle(['Test Case Suggesting Memoryless for ', name], 'FontWeight', 'bold');

    end

end
