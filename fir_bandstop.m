% Load the EEG data
eeg_data = load('Assignment 4 EEG Data.mat');

EEG_Fs = eeg_data.EEG_Fs;
EEGa4 = eeg_data.EEGa4;

t_eeg = (0:length(EEGa4)-1) / EEG_Fs;
figure;
plot(t_eeg, EEGa4);
title('EEGa4 Signal');
xlabel('Time (s)');
ylabel('microV');

[Mx_EEGa4, phx_EEGa4, f_EEGa4] = fourier_dt(EEGa4, EEG_Fs, 'full');

figure;
plot(f_EEGa4, Mx_EEGa4);
title('Magnitude Spectrum of EEGa4 Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
