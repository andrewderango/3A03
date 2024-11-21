function plot_all(signal, Fs, signal_name, signal_units, filter_obj, filter_name)
    % Function will plot all 6 of the required plots for each signal and filter.
    % Plots the original signal on the left and filtered signal on the right.
    % First row is time domain, second is magnitude spectrum, third is phase spectrum.

    figure;
    sgtitle([signal_name, ' Signal Before and After Filtering with the ' filter_name], 'FontWeight', 'bold');

    % determine time axis
    t = (0:length(signal)-1) / Fs;

    % plot time domain signal prefiltering
    subplot(3,2,1);
    plot(t, signal);
    title(['Original ', signal_name, ' Signal']);
    xlabel('Time (s)');
    ylabel(signal_units);

    % calculate Fourier transform prefiltering
    [Mx, phx, f] = fourier_dt(signal, Fs, 'full');

    % plot frequency domain magnitude spectrum prefiltering
    subplot(3,2,3);
    plot(f, db(Mx));
    title(['Magnitude Spectrum of Original ', signal_name, ' Signal']);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');

    % plot frequency domain phase spectrum prefiltering
    subplot(3,2,5);
    plot(f, phx);
    title(['Phase Spectrum of Original ', signal_name, ' Signal']);
    xlabel('Frequency (Hz)');
    ylabel('Phase (radians)');

    % filter the signal
    filtered_signal = filter(filter_obj, signal);

    % plot time domain signal postfiltering
    subplot(3,2,2);
    plot(t, filtered_signal);
    title(['Filtered ', signal_name, ' Signal']);
    xlabel('Time (s)');
    ylabel(signal_units);

    % calculate Fourier transform postfiltering
    [f_Mx, f_phx, f_f] = fourier_dt(filtered_signal, Fs, 'full');

    % plot frequency domain magnitude spectrum postfiltering
    subplot(3,2,4);
    plot(f_f, db(f_Mx));
    title(['Magnitude Spectrum of Filtered ', signal_name, ' Signal']);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');

    % plot frequency domain phase spectrum postfiltering
    subplot(3,2,6);
    plot(f_f, f_phx);
    title(['Phase Spectrum of Filtered ', signal_name, ' Signal']);
    xlabel('Frequency (Hz)');
    ylabel('Phase (radians)');
end