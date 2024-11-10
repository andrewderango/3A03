clc;
clear;
close all;

% load data and get t vector
load('BFVdata_assignment3.mat');
N = length(BFVdu);
t = (0:N-1)/BFV_Fs;

% PART A1
% plot raw signal with its magnitude spectrum
[Mx_BFVdu, phx_BFVdu, f_BFVdu] = fourier_dt(BFVdu, BFV_Fs, 'half');
figure;
subplot(2,1,1);
plot(t, BFVdu, 'LineWidth', 1.25);
title('Time-Domain Signal: Full BFVdu');
xlabel('Time (seconds)');
ylabel('Blood Flow Velocity (m/s)');
subplot(2,1,2);
plot(f_BFVdu, Mx_BFVdu, 'LineWidth', 1.5);
title('Magnitude Spectrum: Full BFVdu');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([0 10]);

% PART A2
% plot first half of signal with its magnitude spectrum
half_BFVdu = BFVdu(1:N/2);
[Mx_half_BFVdu, phx_half_BFVdu, f_half_BFVdu] = fourier_dt(half_BFVdu, BFV_Fs, 'half');
figure;
subplot(2,1,1);
plot(t(1:N/2), half_BFVdu, 'LineWidth', 1.25);
title('Time-Domain Signal: Half 1 of BFVdu');
xlabel('Time (seconds)');
ylabel('Blood Flow Velocity (m/s)');
subplot(2,1,2);
plot(f_half_BFVdu, Mx_half_BFVdu, 'LineWidth', 1.5);
title('Magnitude Spectrum: Half 1 of BFVdu');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([0 10]);

% PART A3
% plot first half of signal with zero-padding with its magnitude spectrum
padded_BFVdu = [half_BFVdu; zeros(1, N/2)'];
t_padded = (0:length(padded_BFVdu)-1) / BFV_Fs;
[Mx_padded_BFVdu, phx_padded_BFVdu, f_padded_BFVdu] = fourier_dt(padded_BFVdu, BFV_Fs, 'half');
figure;
subplot(2,1,1);
plot(t_padded, padded_BFVdu, 'LineWidth', 1.25);
title('Time-Domain Signal: Padded BFVdu');
xlabel('Time (seconds)');
ylabel('Blood Flow Velocity (m/s)');
subplot(2,1,2);
plot(f_padded_BFVdu, Mx_padded_BFVdu, 'LineWidth', 1.5);
title('Magnitude Spectrum: Padded BFVdu');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([0 10]);