n = 0:10;
arr_len = 11;
x1 = ones(1, arr_len);

y1 = system1(n,x1);

%{
for i= 1:11

    x2 = zeros(1, arr_len);

    x2(i) = 1;

    y2 = system1(n, x2);

    if y1(i) ~= y2(i)
        
        fprintf("The system has memory: y1(%d) = %.2f, y2(%d) = %.2f\n", i, y1(i), i, y2(i));

    end
    
    fprintf("The outputs at this position: y1(%d) = %.2f, y2(%d) = %.2f\n", i, y1(i), i, y2(i));

end
%}

%Causality Test Yay!

n = 0:10;

for i= 1:11

    impulse_step_zeros = zeros(1, i-1);

    impulse_step_values = ones(1, 11-i+1);


    %Append the two row vectors together, creating an "impulse step"
    impulse_step = [impulse_step_zeros, impulse_step_values];

    %get the output to see if future values determine current output
    y1 = system1(n, impulse_step);

    %Creates a row vector of all zeros
    zero_vector = zeros(1, arr_len);

    %Creates a unit impulse
    zero_vector(i) = 1;

    %Gets the impulse response
    y2 = system1(n, zero_vector);

    %Compares the two values if they are not equal the system is non-causal
    if y1(i) ~= y2(i)
        fprintf("The system is non-causal: y1(%d) = %.2f, y2(%d) = %.2f\n", i, y1(i), i, y2(i));
    end

     fprintf("The outputs at this position: y1(%d) = %.2f, y2(%d) = %.2f\n", i, y1(i), i, y2(i));

end

%{
figure;
stem(n, y, 'filled');
xlabel('Time Index n');
ylabel('Output Signal y[n]');
title('Output of system1');
grid on;

%}
