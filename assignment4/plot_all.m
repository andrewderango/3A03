function plot_all(signal, Fs, signal_name, signal_units, ...
                  IIR_filter_obj, IIR_filter_name, ...
                  FIR_filter_obj, FIR_filter_name, part)
    % Function will plot all required plots for each signal and filter.
    % Unless otherwise mentioned, first row is time domain, second is 
    % magnitude spectrum, third is phase spectrum.

%-------------------------------------------------------------------------%
    
    % plotting non-filtered signal
    figure;
    sgtitle([signal_name, ' Signal Before Filtering'], 'FontWeight', 'bold');

    % determine time axis
    t = (0:length(signal)-1) / Fs;

    % plot time domain signal prefiltering
    subplot(3,1,1);
    plot(t, signal, 'r');
    title(['Time Domain ', signal_name, ' Signal']);
    xlabel('Time (s)');
    ylabel(signal_units);

    % calculate Fourier transform prefiltering
    [Mx, phx, f] = fourier_dt(signal, Fs, 'half');

    % plot frequency domain magnitude spectrum prefiltering
    subplot(3,1,2);
    plot(f, db(Mx), 'r');
    title(['Magnitude Spectrum of ', signal_name, ' Signal']);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');

    % plot frequency domain phase spectrum prefiltering
    subplot(3,1,3);
    plot(f, phx, 'r');
    title(['Phase Spectrum of ', signal_name, ' Signal']);
    xlabel('Frequency (Hz)');
    ylabel('Phase (radians)');
    
%-------------------------------------------------------------------------%    
    
    % plot the comparison between original and IIR filtered signal
    figure;
    sgtitle([signal_name, ' Signal Compared Before and After ', ...
            IIR_filter_name], 'FontWeight', 'bold');
    
    % filter the signal
    IIR_filtered_signal = filter(IIR_filter_obj, signal);
    
    % plot time domain signal postfiltering
    subplot(3,1,1);
    plot(t, signal, 'r');
    hold on;
    plot(t, IIR_filtered_signal, 'g');
    hold off;
    title(['Time Domain ', signal_name, ' Signal']);
    xlabel('Time (s)');
    ylabel(signal_units);
    legend('Original', IIR_filter_name);

    % calculate Fourier transform postfiltering
    [IIR_Mx, IIR_phx, IIR_f] = fourier_dt(IIR_filtered_signal, Fs, 'half');

    % plot frequency domain magnitude spectrum postfiltering
    subplot(3,1,2);
    plot(f, db(Mx), 'r');
    hold on;
    plot(IIR_f, db(IIR_Mx), 'g');
    hold off;
    title(['Magnitude Spectrum of ', signal_name, ' Signal']);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');

    % plot frequency domain phase spectrum postfiltering
    subplot(3,1,3);
    plot(f, phx, 'r');
    hold on;
    plot(IIR_f, IIR_phx, 'g');
    hold off;
    title(['Phase Spectrum of ', signal_name, ' Signal']);
    xlabel('Frequency (Hz)');
    ylabel('Phase (radians)');
    
%-------------------------------------------------------------------------%

    % plot the comparison between original and FIR filtered signal
    figure;
    sgtitle([signal_name, ' Signal Compared Before and After ', ...
            FIR_filter_name], 'FontWeight', 'bold');
    
    % filter the signal
    FIR_filtered_signal = filter(FIR_filter_obj, signal);
    
    % plot time domain signal postfiltering
    subplot(3,1,1);
    plot(t, signal, 'r');
    hold on;
    plot(t, FIR_filtered_signal, 'b');
    hold off;
    title(['Time Domain ', signal_name, ' Signal']);
    xlabel('Time (s)');
    ylabel(signal_units);
    legend('Original', FIR_filter_name);

    % calculate Fourier transform postfiltering
    [FIR_Mx, FIR_phx, FIR_f] = fourier_dt(FIR_filtered_signal, Fs, 'half');

    % plot frequency domain magnitude spectrum postfiltering
    subplot(3,1,2);
    plot(f, db(Mx), 'r');
    hold on;
    plot(FIR_f, db(FIR_Mx), 'b');
    hold off;
    title(['Magnitude Spectrum of ', signal_name, ' Signal']);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');

    % plot frequency domain phase spectrum postfiltering
    subplot(3,1,3);
    plot(f, phx, 'r');
    hold on;
    plot(FIR_f, FIR_phx, 'b');
    hold off;
    title(['Phase Spectrum of ', signal_name, ' Signal']);
    xlabel('Frequency (Hz)');
    ylabel('Phase (radians)');
    
%-------------------------------------------------------------------------%
    
    % plot the comparison between original and IIR filtered signal
    figure;
    sgtitle(['Filtered ', signal_name, ' Signal Comparing ', ...
            IIR_filter_name, ' to ', FIR_filter_name], 'FontWeight', 'bold');

    % plot time domain signal postfiltering
    subplot(3,1,1);
    plot(t, IIR_filtered_signal, 'g');
    hold on;
    plot(t, FIR_filtered_signal, 'b');
    hold off;
    title(['Time Domain ', signal_name, ' Signal']);
    xlabel('Time (s)');
    ylabel(signal_units);
    legend(IIR_filter_name, FIR_filter_name);

    % plot frequency domain magnitude spectrum postfiltering
    subplot(3,1,2);
    plot(IIR_f, db(IIR_Mx), 'g');
    hold on;
    plot(FIR_f, db(FIR_Mx), 'b');
    hold off;
    title(['Magnitude Spectrum of ', signal_name, ' Signal']);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');

    % plot frequency domain phase spectrum postfiltering
    subplot(3,1,3);
    plot(IIR_f, IIR_phx, 'g');
    hold on;
    plot(FIR_f, FIR_phx, 'b');
    hold off;
    title(['Phase Spectrum of ', signal_name, ' Signal']);
    xlabel('Frequency (Hz)');
    ylabel('Phase (radians)');

%-------------------------------------------------------------------------%
    
    % plot specific EEG comparison zoomed in on magnitude spectrum
    if (part == 1)
        figure;
        sgtitle('Comparing Magnitude Spectrum of Original and Filtered EEG Signals around 50 Hz');
        
        % compare IIR filtered and original signal
        subplot(2,1,1);
        plot(f, db(Mx), 'r');
        hold on;
        plot(IIR_f, db(IIR_Mx), 'g');
        hold off;
        xlim([45 55]);
        title(['Zoomed In Magnitude Spectrum Comparing Original and ', ...
               IIR_filter_name, ' Signals']);
        xlabel('Frequency (Hz)');
        ylabel('Magnitude (dB)');
        legend('Original', IIR_filter_name);
        
        % compare FIR filtered and original signal
        subplot(2,1,2);
        plot(f, db(Mx), 'r');
        hold on;
        plot(FIR_f, db(FIR_Mx), 'b');
        hold off;
        xlim([45 55]);
        title(['Zoomed In Magnitude Spectrum Comparing Original and ', ...
               FIR_filter_name, ' Signals']);
        xlabel('Frequency (Hz)');
        ylabel('Magnitude (dB)');
        legend('Original', FIR_filter_name);
    end
end