function bonus
    load('BFVdata_assignment3.mat');
    load('EEGdata_assignment3.mat');

    % define spectrogram parameters for BFVdu
    window_BFV = 400;               % window length
    noverlap_BFV = 0.75*window_BFV; % overlap between windows
    nfft_BFV = 2*window_BFV;        % number of FFT points

    % generate and plot the spectrogram for BFVdu  
    figure;
    spectrogram(BFVdu, window_BFV, noverlap_BFV, nfft_BFV, BFV_Fs, 'yaxis');
    title('Spectrogram of BFVdu Signal');
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    colorbar;

    % define spectrogram parameters for the EEG signals
    window_EEG = 4000;               % window length
    noverlap_EEG = 0.75*window_EEG; % overlap between windows
    nfft_EEG = 1024;        % number of FFT points

    % generate and plot the spectrogram for EEG1 and EEG2
    figure;
    subplot(2,1,1);
    spectrogram(EEG1, window_EEG, noverlap_EEG, nfft_EEG, EEG_Fs, 'yaxis');
    title('Spectrogram of EEG1 Signal');
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    ylim([0 100]);
    colorbar;
    subplot(2,1,2);
    spectrogram(EEG2, window_EEG, noverlap_EEG, nfft_EEG, EEG_Fs, 'yaxis');
    title('Spectrogram of EEG2 Signal');
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    ylim([0 100]);
    colorbar;
end