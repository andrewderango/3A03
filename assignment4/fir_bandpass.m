% Load the biomedical signals data
data = load('Assignment 4 Biomedical Signals.mat');

VGRF = data.VGRF;
VGRF_Fs = data.VGRF_Fs;

t = (0:length(VGRF)-1) / VGRF_Fs;
figure;
plot(t, VGRF);
title('Original VGRF Signal');
xlabel('Time (s)');
ylabel('Newtons');

% Compute the Fourier transform
[Mx_VGRF, phx_VGRF, f_VGRF] = fourier_dt(VGRF, VGRF_Fs, 'full');

% Plot the magnitude spectrum 
figure;
plot(f_VGRF, Mx_VGRF);
title('Magnitude Spectrum of VGRF Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');




