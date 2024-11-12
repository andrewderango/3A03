function part_a
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
    Mx_padded = Mx_padded * 2;
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
    [Mx, ~, f] = fourier_dt(signal, Fs, 'half');
    [Mx_half, ~, f_half] = fourier_dt(half_signal, Fs, 'half');
    [Mx_padded, ~, f_padded] = fourier_dt(padded_signal, Fs, 'half');
    Mx_padded = Mx_padded * 2;

    % compute DTW distances and alignments
    [dist_no_padding, ix_no_padding, iy_no_padding] = dtw(Mx, Mx_half);
    [dist_zero_padding, ix_zero_padding, iy_zero_padding] = dtw(Mx, Mx_padded);

    % display DTW distances
    if strcmp(signal_name, 'Original Signal')
        fileID = fopen('part1_comps.txt', 'w');
    else
        fileID = fopen('part1_comps.txt', 'a');
    end
    fprintf(fileID, 'DTW distance (no padding) for %s: %f\n', signal_name, dist_no_padding);
    fprintf(fileID, 'DTW distance (zero padding) for %s: %f\n', signal_name, dist_zero_padding);
    fclose(fileID);
    disp(['DTW distance (no padding) for ', signal_name, ': ', num2str(dist_no_padding)]);
    disp(['DTW distance (zero padding) for ', signal_name, ': ', num2str(dist_zero_padding)]);

    % plot DTW alignments
    figure;
    subplot(2,1,1);
    plot_dtw_alignment(f, Mx, f_half, Mx_half, ix_no_padding, iy_no_padding, sprintf('DTW Alignment (No Padding) for %s', signal_name));
    subplot(2,1,2);
    plot_dtw_alignment(f, Mx, f_padded, Mx_padded, ix_zero_padding, iy_zero_padding, sprintf('DTW Alignment (Zero Padding) for %s', signal_name));
end

function plot_dtw_alignment(f1, Mx1, f2, Mx2, ix, iy, title_str)
    % ensure indices are within valid range
    ix = min(ix, length(Mx1));
    iy = min(iy, length(Mx2));

    % only keep elements up to the length of both magnitude spectra
    aligned_Mx1 = Mx1(ix);
    aligned_Mx2 = Mx2(iy);
    aligned_f1 = f1(ix);
    aligned_f2 = f2(iy);

    % plot alignment
    plot(aligned_f1, aligned_Mx1, 'b', 'LineWidth', 1.25);
    hold on;
    plot(aligned_f2, aligned_Mx2, 'r', 'LineWidth', 1.25);
    legend('Original Magnitude Spectrum', 'Aligned Half-Length Spectrum');
    title(title_str);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');
    if strcmp(title_str, 'DTW Alignment (No Padding) for Original Signal') || strcmp(title_str, 'DTW Alignment (Zero Padding) for Original Signal')
        xlim([0 10]);
    elseif strcmp(title_str, 'DTW Alignment (No Padding) for Modified Signal') || strcmp(title_str, 'DTW Alignment (Zero Padding) for Modified Signal')
        xlim([0 20]);
    end
    hold off;
end