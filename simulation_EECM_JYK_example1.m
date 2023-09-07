clear; clc; close all

%% Simulation Setting

% cell
cell_id_string = 'example1'; % used for display and labeling

% environment
T_amb = 25; % ambient temperature
N_cycle = 5; % number of cycles to simulate

% cycling
cycling = 'FCPD';
charging = 'CCCV';

% cycles to display
cycle_display = [1,2];

  

%% Configuration

% cell-specific config
config_EECM_V1_example1
    % config cell dynamic and aging models