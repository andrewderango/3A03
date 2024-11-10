function part_a
    clc;
    clear;
    close all;

    % load data and get t vector
    load('BFVdata_assignment3.mat');
    N = length(BFVdu);
    t = (0:N-1)/BFV_Fs;

    % zero-center to modify signal
    modified_BFVdu = BFVdu - mean(BFVdu);

    % plot original signal and its magnitude spectrum
    figure;
    plot_signal_and_spectrum(t, BFVdu, BFV_Fs, 'Full BFVdu', 1);
    plot_signal_and_spectrum(t(1:N/2), BFVdu(1:N/2), BFV_Fs, 'First Half of BFVdu', 3);
    plot_padded_signal_and_spectrum(t, BFVdu, BFV_Fs, 'Padded BFVdu', 5);

    % plot modified signal and its magnitude spectrum
    figure;
    plot_signal_and_spectrum(t, modified_BFVdu, BFV_Fs, 'Modified BFVdu', 1);
    plot_signal_and_spectrum(t(1:N/2), modified_BFVdu(1:N/2), BFV_Fs, 'First Half of Modified BFVdu', 3);
    plot_padded_signal_and_spectrum(t, modified_BFVdu, BFV_Fs, 'Padded Modified BFVdu', 5);

    % Compare Fourier transforms with zero-padded plots using DTW
    compare_with_dtw(BFVdu, BFV_Fs, 'Original Signal');
    compare_with_dtw(modified_BFVdu, BFV_Fs, 'Modified Signal');
end

function plot_signal_and_spectrum(t, signal, Fs, title_prefix, subplot_index)
    N = length(signal);
    [Mx, ~, f] = fourier_dt(signal, Fs, 'half');
    subplot(3,2,subplot_index);
    plot(t, signal, 'LineWidth', 1.25);
    title(['Time-Domain Signal: ', title_prefix]);
    xlabel('Time (seconds)');
    ylabel('Blood Flow Velocity (m/s)');
    subplot(3,2,subplot_index+1);
    plot(f, Mx, 'LineWidth', 1.5);
    title(['Magnitude Spectrum: ', title_prefix]);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');
    xlim([0 10]);
end

function plot_padded_signal_and_spectrum(t, signal, Fs, title_prefix, subplot_index)
    N = length(signal);
    half_signal = signal(1:N/2);
    padded_signal = [half_signal; zeros(N/2, 1)];
    t_padded = (0:length(padded_signal)-1) / Fs;
    [Mx_padded, ~, f_padded] = fourier_dt(padded_signal, Fs, 'half');
    subplot(3,2,subplot_index);
    plot(t_padded, padded_signal, 'LineWidth', 1.25);
    title(['Time-Domain Signal: ', title_prefix]);
    xlabel('Time (seconds)');
    ylabel('Blood Flow Velocity (m/s)');
    subplot(3,2,subplot_index+1);
    plot(f_padded, Mx_padded, 'LineWidth', 1.5);
    title(['Magnitude Spectrum: ', title_prefix]);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');
    xlim([0 10]);
end

function compare_with_dtw(signal, Fs, signal_name)
    N = length(signal);
    half_signal = signal(1:N/2);
    padded_signal = [half_signal; zeros(N/2, 1)];

    % compute Fourier transforms
    [Mx, ~, ~] = fourier_dt(signal, Fs, 'half');
    [Mx_half, ~, ~] = fourier_dt(half_signal, Fs, 'half');
    [Mx_padded, ~, ~] = fourier_dt(padded_signal, Fs, 'half');

    % compute DTW distances between Fourier transforms
    [dist_no_padding, ~, ~] = dtw(Mx, Mx_half);
    [dist_zero_padding, ~, ~] = dtw(Mx, Mx_padded);

    % display DTW distances
    fprintf('DTW distance (no padding) for %s: %f\n', signal_name, dist_no_padding);
    fprintf('DTW distance (zero padding) for %s: %f\n', signal_name, dist_zero_padding);
end