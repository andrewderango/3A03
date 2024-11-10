clc;
clear;
close all;

% load data
load('BFVdata_assignment3.mat');

% get time vector for plotting
N = length(BFVdu);
t = (0:N-1)/BFV_Fs;

% plot the signal
figure;
subplot(2,1,1);
plot(t, BFVdu, 'LineWidth', 1.25);
title('Entire Signal: BFVdu');
xlabel('Time (seconds)');
ylabel('Blood Flow Velocity (m/s)');

% compute and plot magnitude spectrum
[Mx_BFVdu, phx_BFVdu, f_BFVdu] = fourier_dt(BFVdu, BFV_Fs, 'half');
subplot(2,1,2);
plot(f_BFVdu, Mx_BFVdu, 'LineWidth', 1.5);
title('Magnitude Spectrum: BFVdu');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([0 10]);