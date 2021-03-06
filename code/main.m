clear
clc
close all
warning off

%% Initialize Parameters
% Frequency from 1 - 64;
freq1 = 14;
freq2 = 15;
% Set Network Density for threshold calcualation
density = 0.10;
% Load positions of nodes obtained from the image
load(fullfile('..','data','nodePos.mat'))

%% Get data samples LHI, LHM, RHI, RHM
[samples_LHM, samples_RHM, samples_LHI, samples_RHI, header] = dataset_load();

%% Initialize Parameters and Run the routine (Data_Load + PDC_Computation + Local and Global Indices + Graphs)
% Channels set to 64
channels = 64;
[LHM_CH_64_f1] = run_routine(samples_LHM, header, channels, freq1, density, 'LHM');
[LHM_CH_64_f2] = run_routine(samples_LHM, header, channels, freq2, density, 'LHM');

[LHI_CH_64_f1] = run_routine(samples_LHI, header, channels, freq1, density, 'LHI');
[LHI_CH_64_f2] = run_routine(samples_LHI, header, channels, freq2, density, 'LHI');

[RHM_CH_64_f1] = run_routine(samples_RHM, header, channels, freq1, density, 'RHM');
[RHM_CH_64_f2] = run_routine(samples_RHM, header, channels, freq2, density, 'RHM');

[RHI_CH_64_f1] = run_routine(samples_RHI, header, channels, freq1, density, 'RHI');
[RHI_CH_64_f2] = run_routine(samples_RHI, header, channels, freq2, density, 'RHI');

% Channels set to 21
channels = 21;

[LHM_CH_21_f1] = run_routine(samples_LHM, header, channels, freq1, density, 'LHM');
[LHM_CH_21_f2] = run_routine(samples_LHM, header, channels, freq2, density, 'LHM');

[LHI_CH_21_f1] = run_routine(samples_LHI, header, channels, freq1, density, 'LHI');
[LHI_CH_21_f2] = run_routine(samples_LHI, header, channels, freq2, density, 'LHI');

[RHM_CH_21_f1] = run_routine(samples_RHM, header, channels, freq1, density, 'RHM');
[RHM_CH_21_f2] = run_routine(samples_RHM, header, channels, freq2, density, 'RHM');

[RHI_CH_21_f1] = run_routine(samples_RHI, header, channels, freq1, density, 'RHI');
[RHI_CH_21_f2] = run_routine(samples_RHI, header, channels, freq2, density, 'RHI');

disp("------------------End of Analysis-------------------");

%%
function [s] = run_routine(samples, header, channels, freq, density, str)
    %%% Written by : Akshay Dhonthi
	%     
    % @params
    %        samples:      Data samples for analysis
    %         header:      Header to get node names for plotting
    %       channels:      Number of channels (64 or 21)
    %           freq:      The choosen frequency to get results 
    %        density:      The density required to set threshold
    %            str:      A string to describe name of the file 
    % @return
    %              s:      A data structure containing all the computed values
    %
    
    disp(['Computing ', str, ' with Frequency: ', num2str(freq), ', Channels: ', num2str(channels), ' and Density: ', num2str(density)]);
    
    % Compute Partial Directed Coherence
    [PDC, PDC_Bin, threshold] = pdc_compute(samples(:,1:channels) , freq, density);

    % Compute Degrees and Density
    [out_degrees, in_degrees, degrees, left_Hemis, right_Hemis, L_Density, R_Density] = graph_nodes_degrees(PDC_Bin, channels);
    
    % Compute Global and Local Efficiency
    [distance_matrix, global_efficiency, local_efficiency_avg, local_efficiency_all] = efficiency(PDC_Bin);
        
    % Plot Graphs
    [graph, L_graph, R_graph] = graph_compute(PDC_Bin, channels, left_Hemis, right_Hemis, header);
    
    % Store all values in a Datastructure
    s.data = samples;    
    s.PDC = PDC;
    s.PDC_Bin = PDC_Bin;
    s.Threshold = threshold;
    
    s.In_degrees = in_degrees;
	s.Out_degrees = out_degrees;
    s.Degrees = degrees;
    
    s.Left_Hemisphere = left_Hemis;
    s.Right_Hemisphere = right_Hemis;    
    s.Left_Hemis_Density = L_Density;
    s.Right_Hemis_Density = R_Density;
    
    s.distance_matrix = distance_matrix;
    s.global_efficiency = global_efficiency;
    s.local_efficiency_avg = local_efficiency_avg;
    s.local_efficiency_all = local_efficiency_all;
    
    s.graph = graph;
    s.Left_Hemis_Graph = L_graph;
    s.Right_Hemis_Graph = R_graph;
    
end