function part_b

    %load data
    data = load('EEGdata_assignment3.mat');

    EEG1 = data.EEG1;
    EEG2 = data.EEG2;

    EEG_Fs = data.EEG_Fs;

    %Calculate the first fourier transform
    [Mx1,~,f1] = fourier_dt(EEG1, EEG_Fs, 'half');

    % Plot the magnitude spectrum of EEG1
    figure;
    plot(f1, Mx1, 'LineWidth', 1.5);
    title('Magnitude Spectrum of EEG1');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');
    
    %manually restrict the x-axis to 0-50 Hz
    xlim([0 50]);

    disp("EEG 1 - Band Power");

    %Delta band
    band_power_delta = sum(Mx1(f1 >= 0 & f1 < 3));

    band_power_delta_normalized = band_power_delta / (3 - 0);

    disp(['Delta: ', num2str(band_power_delta)]);

    disp(['Delta Normalized: ', num2str(band_power_delta_normalized)]);

    %Theta band
    band_power_theta = sum(Mx1(f1 >= 3 & f1 < 8));

    band_power_theta_normalized = band_power_theta / (5 - 3);

    disp(['Theta: ', num2str(band_power_theta)]);

    disp(['Theta Normalized: ', num2str(band_power_theta_normalized)]);

    %Alpha band
    band_power_alpha = sum(Mx1(f1 >= 8 & f1 < 13));

    band_power_alpha_normalized = band_power_alpha / (13 - 8);

    disp(['Alpha: ', num2str(band_power_alpha)]);

    disp(['Alpha Normalized: ', num2str(band_power_alpha_normalized)]);

    %Beta band
    band_power_beta = sum(Mx1(f1 >= 13 & f1 < 25));

    band_power_beta_normalized = band_power_beta / (25 - 13);

    disp(['Beta: ', num2str(band_power_beta)]);

    disp(['Beta Normalized: ', num2str(band_power_beta_normalized)]);

    %Gamma band
    band_power_gamma = sum(Mx1(f1 >= 25 & f1 <= 100));

    band_power_gamma_normalized = band_power_gamma / (100 - 25);

    disp(['Gamma: ', num2str(band_power_gamma)]);

    disp(['Gamma Normalized: ', num2str(band_power_gamma_normalized)]);

    %Calculate the second fourier transform

    [Mx2,~,f2] = fourier_dt(EEG2, EEG_Fs, 'half');

    % Plot the magnitude spectrum of EEG2
    figure;
    plot(f2, Mx2, 'LineWidth', 1.5);
    title('Magnitude Spectrum of EEG2');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');

    %manually restrict the x-axis to 0-50 Hz
    xlim([0 50]);

    disp(' ');
    disp("EEG 2 - Band Power");

    %Delta band
    band_power_delta = sum(Mx2(f2 >= 0 & f2 < 3));

    band_power_delta_normalized = band_power_delta / (3 - 0);

    disp(['Delta: ', num2str(band_power_delta)]);

    disp(['Delta Normalized: ', num2str(band_power_delta_normalized)]);

    %Theta band
    band_power_theta = sum(Mx2(f2 >= 3 & f2 < 8));

    band_power_theta_normalized = band_power_theta / (5 - 3);

    disp(['Theta: ', num2str(band_power_theta)]);

    disp(['Theta Normalized: ', num2str(band_power_theta_normalized)]);

    %Alpha band
    band_power_alpha = sum(Mx2(f2 >= 8 & f2 < 13));

    band_power_alpha_normalized = band_power_alpha / (13 - 8);

    disp(['Alpha: ', num2str(band_power_alpha)]);

    disp(['Alpha Normalized: ', num2str(band_power_alpha_normalized)]);

    %Beta band
    band_power_beta = sum(Mx2(f2 >= 13 & f2 < 25));

    band_power_beta_normalized = band_power_beta / (25 - 13);

    disp(['Beta: ', num2str(band_power_beta)]);

    disp(['Beta Normalized: ', num2str(band_power_beta_normalized)]);

    %Gamma band
    band_power_gamma = sum(Mx2(f2 >= 25 & f2 <= 100));

    band_power_gamma_normalized = band_power_gamma / (100 - 25);

    disp(['Gamma: ', num2str(band_power_gamma)]);

    disp(['Gamma Normalized: ', num2str(band_power_gamma_normalized)]);
    
end