function part_b(verbose)

    % load data
    data = load('EEGdata_assignment3.mat');

    EEG1 = data.EEG1;
    EEG2 = data.EEG2;

    EEG_Fs = data.EEG_Fs;

    % Calculate the first fourier transform
    [Mx1,~,f1] = fourier_dt(EEG1, EEG_Fs, 'full');
    
    figure;
    
    % First subplot with xlim 0-50 Hz
    subplot(2, 1, 1);
    plot(f1, Mx1, 'LineWidth', 1.5);
    title('Magnitude Spectrum of EEG1 (0-50 Hz)');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');
    xlim([0 50]);
    
    % Second subplot with no xlim
    subplot(2, 1, 2);
    plot(f1, Mx1, 'LineWidth', 1.5);
    title('Magnitude Spectrum of EEG1 (Full Range)');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');

    disp("EEG 1 - Band Power");

    disp(' ');

    %Delta band
    band_power_delta = sum(Mx1(f1 >= 0 & f1 < 3).^2)*2;

    band_power_delta_normalized = band_power_delta / (3 - 0);

    disp(['Delta: ', num2str(band_power_delta)]);

    disp(['Delta Normalized: ', num2str(band_power_delta_normalized)]);

    disp(' ');

    %Theta band
    band_power_theta = sum(Mx1(f1 >= 3 & f1 < 8).^2)*2;

    band_power_theta_normalized = band_power_theta / (8 - 3);

    disp(['Theta: ', num2str(band_power_theta)]);

    disp(['Theta Normalized: ', num2str(band_power_theta_normalized)]);

    disp(' ');

    %Alpha band
    band_power_alpha = sum(Mx1(f1 >= 8 & f1 < 13).^2)*2;

    band_power_alpha_normalized = band_power_alpha / (13 - 8);

    disp(['Alpha: ', num2str(band_power_alpha)]);

    disp(['Alpha Normalized: ', num2str(band_power_alpha_normalized)]);

    disp(' ');

    %Beta band
    band_power_beta = sum(Mx1(f1 >= 13 & f1 < 25).^2)*2;

    band_power_beta_normalized = band_power_beta / (25 - 13);

    disp(['Beta: ', num2str(band_power_beta)]);

    disp(['Beta Normalized: ', num2str(band_power_beta_normalized)]);

    disp(' ');

    %Gamma band
    band_power_gamma = sum(Mx1(f1 >= 25 & f1 <= 100).^2)*2;

    band_power_gamma_normalized = band_power_gamma / (100 - 25);

    disp(['Gamma: ', num2str(band_power_gamma)]);

    disp(['Gamma Normalized: ', num2str(band_power_gamma_normalized)]);

    disp(' ');

    %Calculate the second fourier transform

    [Mx2,~,f2] = fourier_dt(EEG2, EEG_Fs, 'full');

    % Plot the magnitude spectrum of EEG2
    figure;
    
    % First subplot with xlim 0-50 Hz
    subplot(2, 1, 1);
    plot(f2, Mx2, 'LineWidth', 1.5);
    title('Magnitude Spectrum of EEG2 (0-50 Hz)');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');
    xlim([0 50]);
    
    % Second subplot with no xlim
    subplot(2, 1, 2);
    plot(f2, Mx2, 'LineWidth', 1.5);
    title('Magnitude Spectrum of EEG2 (Full Range)');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');

    disp("EEG 2 - Band Power");

    disp(' ');

    %Delta band
    band_power_delta2 = sum(Mx2(f2 >= 0 & f2 < 3).^2)*2;

    band_power_delta_normalized2 = band_power_delta2 / (3 - 0);

    disp(['Delta: ', num2str(band_power_delta2)]);

    disp(['Delta Normalized: ', num2str(band_power_delta_normalized2)]);

    disp(' ');

    %Theta band
    band_power_theta2 = sum(Mx2(f2 >= 3 & f2 < 8).^2)*2;

    band_power_theta_normalized2 = band_power_theta2 / (8 - 3);

    disp(['Theta: ', num2str(band_power_theta2)]);

    disp(['Theta Normalized: ', num2str(band_power_theta_normalized2)]);

    disp(' ');

    %Alpha band
    band_power_alpha2 = sum(Mx2(f2 >= 8 & f2 < 13).^2)*2;

    band_power_alpha_normalized2 = band_power_alpha2 / (13 - 8);

    disp(['Alpha: ', num2str(band_power_alpha2)]);

    disp(['Alpha Normalized: ', num2str(band_power_alpha_normalized2)]);

    disp(' ');

    %Beta band
    band_power_beta2 = sum(Mx2(f2 >= 13 & f2 < 25).^2)*2;

    band_power_beta_normalized2 = band_power_beta2 / (25 - 13);

    disp(['Beta: ', num2str(band_power_beta2)]);

    disp(['Beta Normalized: ', num2str(band_power_beta_normalized2)]);

    disp(' ');

    %Gamma band
    band_power_gamma2 = sum(Mx2(f2 >= 25 & f2 <= 100).^2)*2;

    band_power_gamma_normalized2 = band_power_gamma2 / (100 - 25);

    disp(['Gamma: ', num2str(band_power_gamma2)]);

    disp(['Gamma Normalized: ', num2str(band_power_gamma_normalized2)]);

    disp(' ');

    figure;

    % EEG1 Band Powers
    band_labels = {'Delta', 'Theta', 'Alpha', 'Beta', 'Gamma'};
    EEG1_band_powers = [band_power_delta, band_power_theta, band_power_alpha, band_power_beta, band_power_gamma];
    subplot(1, 2, 1);
    bar(1:5, EEG1_band_powers, 'FaceColor', [0.2, 0.6, 0.8]);
    set(gca, 'XTickLabel', band_labels, 'XTick', 1:5, 'YScale', 'log');
    title('EEG1 Band Powers');
    xlabel('Band');
    ylabel('Power');
    ylim([1e-3 max(EEG1_band_powers) * 1.2]);

    % EEG2 Band Powers
    EEG2_band_powers = [band_power_delta2, band_power_theta2, band_power_alpha2, band_power_beta2, band_power_gamma2];
    subplot(1, 2, 2);
    bar(1:5, EEG2_band_powers, 'FaceColor', [0.8, 0.4, 0.4]);
    set(gca, 'XTickLabel', band_labels, 'XTick', 1:5, 'YScale', 'log');
    title('EEG2 Band Powers');
    xlabel('Band');
    ylabel('Power');
    ylim([1e-3 max(EEG2_band_powers) * 1.2]); % Add some space above the max value

    %Normalized Band Powers

    EEG1_normalized_band_powers = [band_power_delta_normalized, band_power_theta_normalized, band_power_alpha_normalized, band_power_beta_normalized, band_power_gamma_normalized];
    subplot(1, 2, 1);
    bar(1:5, EEG1_normalized_band_powers, 'FaceColor', [0.2, 0.6, 0.8]);
    set(gca, 'XTickLabel', band_labels, 'XTick', 1:5, 'YScale', 'log');
    title('EEG1 Normalized Band Powers');
    xlabel('Band');
    ylabel('Power');
    ylim([1e-3 max(EEG1_normalized_band_powers) * 1.2]);

    EEG2_normalized_band_powers = [band_power_delta_normalized2, band_power_theta_normalized2, band_power_alpha_normalized2, band_power_beta_normalized2, band_power_gamma_normalized2];
    subplot(1, 2, 2);
    bar(1:5, EEG2_normalized_band_powers, 'FaceColor', [0.8, 0.4, 0.4]);
    set(gca, 'XTickLabel', band_labels, 'XTick', 1:5, 'YScale', 'log');
    title('EEG2 Normalized Band Powers');
    xlabel('Band');
    ylabel('Power');
    ylim([1e-3 max(EEG2_normalized_band_powers) * 1.2]); % Add some space above the max value

    %Plot the time domain signal
    t = linspace(0, (length(EEG1)-1)/EEG_Fs, length(EEG1));
    
    figure;
    subplot(2, 1, 1);
    plot(t, EEG1, 'LineWidth', 1.5);
    title('EEG1 Time Domain Signal');
    xlabel('Time (s)');
<<<<<<< HEAD
    ylabel('Voltage (microV)');
=======
    ylabel('Voltage (μV)');
>>>>>>> 4386241f0cf6f6c1a1fd504d40fd4d47a9cf9fe8
    
    subplot(2, 1, 2);
    plot(t, EEG2, 'LineWidth', 1.5);
    title('EEG2 Time Domain Signal');
    xlabel('Time (s)');
<<<<<<< HEAD
    ylabel('Voltage (microV)');
=======
    ylabel('Voltage (μV)');
>>>>>>> 4386241f0cf6f6c1a1fd504d40fd4d47a9cf9fe8
    

   
    %Optional plotting for each signal band power
    if strcmp(verbose, 'true')
        
        figure;
        % Plotting for EEG1
        subplot(5, 1, 1);
        plot(f1, Mx1, 'LineWidth', 1.5);
        xlim([0 3]);
        title('EEG1 - Delta Band (0-3 Hz)');
        xlabel('Frequency (Hz)');
        ylabel('Magnitude');

        subplot(5, 1, 2);
        plot(f1, Mx1, 'LineWidth', 1.5);
        xlim([3 8]);
        title('EEG1 - Theta Band (3-8 Hz)');
        xlabel('Frequency (Hz)');
        ylabel('Magnitude');

        subplot(5, 1, 3);
        plot(f1, Mx1, 'LineWidth', 1.5);
        xlim([8 13]);
        title('EEG1 - Alpha Band (8-13 Hz)');
        xlabel('Frequency (Hz)');
        ylabel('Magnitude');

        subplot(5, 1, 4);
        plot(f1, Mx1, 'LineWidth', 1.5);
        xlim([13 25]);
        title('EEG1 - Beta Band (13-25 Hz)');
        xlabel('Frequency (Hz)');
        ylabel('Magnitude');

        subplot(5, 1, 5);
        plot(f1, Mx1, 'LineWidth', 1.5);
        xlim([25 100]);
        title('EEG1 - Gamma Band (25-100 Hz)');
        xlabel('Frequency (Hz)');
        ylabel('Magnitude');

        % Plotting for EEG2
        figure;
        subplot(5, 1, 1);
        plot(f2, Mx2, 'LineWidth', 1.5);
        xlim([0 3]);
        title('EEG2 - Delta Band (0-3 Hz)');
        xlabel('Frequency (Hz)');
        ylabel('Magnitude');

        subplot(5, 1, 2);
        plot(f2, Mx2, 'LineWidth', 1.5);
        xlim([3 8]);
        title('EEG2 - Theta Band (3-8 Hz)');
        xlabel('Frequency (Hz)');
        ylabel('Magnitude');

        subplot(5, 1, 3);
        plot(f2, Mx2, 'LineWidth', 1.5);
        xlim([8 13]);
        title('EEG2 - Alpha Band (8-13 Hz)');
        xlabel('Frequency (Hz)');
        ylabel('Magnitude');

        subplot(5, 1, 4);
        plot(f2, Mx2, 'LineWidth', 1.5);
        xlim([13 25]);
        title('EEG2 - Beta Band (13-25 Hz)');
        xlabel('Frequency (Hz)');
        ylabel('Magnitude');

        subplot(5, 1, 5);
        plot(f2, Mx2, 'LineWidth', 1.5);
        xlim([25 100]);
        title('EEG2 - Gamma Band (25-100 Hz)');
        xlabel('Frequency (Hz)');
        ylabel('Magnitude');

    end
end