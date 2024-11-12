Fs = 10e3; % Sampling frequency in Hz
N = 800; % Number of samples for signal x
% N = 1001; % Number of samples for signal x

F0 = 2e3; % Sinuosoid frequency  in Hz
% F0 = 3.001e3; % Sinuosoid frequency  in Hz
A0 = 1;   % Amplitude of sinusoid
t = (0:N-1)/Fs; % Time array
x = A0*cos(2*pi*F0*t); % cosine signal with amplitude of A0 and frequency F0
% x = A0*sin(2*pi*F0*t); % sine signal with amplitude of A0 and frequency F0
% x = A0*exp(1i*2*pi*F0*t); % complex exponential signal with amplitude of A0 and frequency F0
% x = A0*ones(size(t)); % constant (dc) signal with amplitude of A0

[Mx_half,phx_half,f_half] = fourier_dt(x,Fs,'half');

figure
subplot(2,1,1)
plot(t,x)
title('Time-domain signal')
ylabel('x(t)')
xlabel('t (s)')

figure
subplot(2,1,1)
plot(f_half,Mx_half)
ylabel('|X(f)|')
title('One-sided spectrum')
subplot(2,1,2)
plot(f_half,phx_half)
ylabel('\angleX(f)')
xlabel('f (Hz)')

[Mx_full,phx_full,f_full] = fourier_dt(x,Fs,'full');

figure
subplot(2,1,1)
plot(f_full,Mx_full)
ylabel('|X(f)|')
title('Two-sided spectrum')
subplot(2,1,2)
plot(f_full,phx_full)
ylabel('\angleX(f)')
xlabel('f (Hz)')
