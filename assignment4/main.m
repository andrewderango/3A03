% Reset
clear;
clc;
close all;

% EEG Signal

EEG_file = load('Assignment 4 EEG Data.mat');
EEG_filter_FIR = load('testFilter.mat');
EEG_filter_IIR = load('testFilter.mat');

plot_all(EEG_file.EEGa4, EEG_file.EEG_Fs,'EEG', 'Voltage (μV)', EEG_filter_FIR.testFilter, 'FIR Bandstop Filter');
plot_all(EEG_file.EEGa4, EEG_file.EEG_Fs,'EEG', 'Voltage (μV)', EEG_filter_IIR.testFilter, 'IIR Bandstop Filter');

% VGRF Signal

VGRF_file = load('Assignment 4 Biomedical Signals.mat');
VGRF_filter_FIR = load('testFilter.mat');
VGRF_filter_IIR = load('testFilter.mat');

plot_all(VGRF_file.VGRF, VGRF_file.VGRF_Fs,'VGRF', 'Force (N)', VGRF_filter_FIR.testFilter, 'FIR Bandpass Filter');
plot_all(VGRF_file.VGRF, VGRF_file.VGRF_Fs,'VGRF', 'Force (N)', VGRF_filter_IIR.testFilter, 'IIR Bandpass Filter');

% BFVdu Signal

BFVdu_file = load('BFVdata_assignment4.mat');
BFVdu_filter_FIR = load('testFilter.mat');
BFVdu_filter_IIR = load('testFilter.mat');

plot_all(BFVdu_file.BFVdu, BFVdu_file.BFV_Fs,'BFVdu', 'Blood Flow Velocity (m/s)', BFVdu_filter_FIR.testFilter, 'FIR Bandpass Filter');
plot_all(BFVdu_file.BFVdu, BFVdu_file.BFV_Fs,'BFVdu', 'Blood Flow Velocity (m/s)', BFVdu_filter_IIR.testFilter, 'IIR Bandpass Filter');