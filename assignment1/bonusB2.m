% Reset
clear;
clc;
close all;

% Call the testProperties function for each system without plots
testProperties(@system0, 'System 0', false);
testProperties(@system1, 'System 1', false);
testProperties(@system2, 'System 2', false);
testProperties(@system3, 'System 3', false);
testProperties(@system_B1, 'System B1', false);
