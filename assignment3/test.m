load('EEGdata_assignment3.mat');
[Mx1,~,f1] = fourier_dt(EEG1, EEG_Fs, 'half');
[Mx2,~,f2] = fourier_dt(EEG1, EEG_Fs, 'full'); % note I took in lecture said that it had to be the full spectrum not half

disp(mean(EEG1.^2)); % way they say to do it in the slides Week 7 Slide 42
disp(sum(Mx1.^2));
disp(sum(Mx2.^2)); % way they say to do it in the slides Week 7 Slide 42
disp(sum(Mx1));
disp(sum(Mx2));