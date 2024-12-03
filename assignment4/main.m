% Reset
clear;
clc;
close all;

% EEG Signal

EEG_file = load('EEGdata_assignment4.mat');
EEG_filter_FIR = load('EGG_FIR.mat');
EEG_filter_IIR = load('EGG_IIR.mat');

plot_all(EEG_file.EEGa4, EEG_file.EEG_Fs,'EEG', 'Voltage (μV)', ...
EEG_filter_IIR.EGG_IIR, 'IIR Bandstop Filter', ...
EEG_filter_FIR.EGG_FIR, 'FIR Bandstop Filter', 1);

% VGRF Signal

VGRF_file = load('VGRFdata_assignment4.mat');
VGRF_filter_FIR = load('VGRF_FIR.mat');
VGRF_filter_IIR = load('VGRF_IIR.mat');

plot_all(VGRF_file.VGRF, VGRF_file.VGRF_Fs,'VGRF', 'Force (N)', ...
VGRF_filter_IIR.VGRF_IIR, 'IIR Bandpass Filter', ...
VGRF_filter_FIR.VGRF_FIR, 'FIR Bandpass Filter', 2);

% BFVdu Signal

BFVdu_file = load('BFVdata_assignment4.mat');
BFVdu_filter_FIR = load('BFVdu_FIR.mat');
BFVdu_filter_IIR = load('BFVdu_IIR.mat');

plot_all(BFVdu_file.BFVdu, BFVdu_file.BFV_Fs,'BFVdu', 'Blood Flow Velocity (m/s)', ...
BFVdu_filter_IIR.BFVdu_IIR, 'IIR Bandpass Filter', ...
BFVdu_filter_FIR.BFVdu_FIR, 'FIR Bandpass Filter', 3);
