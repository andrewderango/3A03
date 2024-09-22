% Reset
clear;
clc;
close all;

Sys0 = solve(@system0);
display (Sys0);
Sys1 = solve(@system1);
display (Sys1);
Sys2 = solve(@system2);
display (Sys2);
Sys3 = solve(@system3);
display (Sys3);
SysB1 = solve(@system_B1);
display (SysB1);

function numSuccess = solve(func)
    numSuccess = 0;
    n = linspace(-10, 10, 21);
    for i = 1:1000
        x1 = rand(1,21);
        x2 = rand(1,21);
        a = randi([-100,100]);
        b = randi([-100,100]);
        y1 = func(n,x1);
        y2 = func(n,x2);
        x3 = a * x1 + b * x2;
        y3 = func(n,x3);
        if sum(abs(a * y1 + b * y2 - y3)) < 1e-12
            %fprintf('Linear for #%d\n', i);
            numSuccess = numSuccess + 1;
        end
    end
end
