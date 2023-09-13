function [Config] = EECM_func_cycling_protocol(Config,cycling,charging,T_amb)

% Define cycling protocol
% 충방전 protocol 조건 

%% Transfer variables to Config field
Config.mode = 'simulation'; % or 'fitting'
Config.input_type = 'cycling_protocol'; % or 'load profile'
    % Protocols
    Config.cycling_protocol = cycling;
    Config.charging_protocol = charging;

Config.T_cyclelife_amb = T_amb; % ambient temperature

%% Temperatures
    % setting the step temperatures (temporally same)
    Config.T_charging = Config.T_cyclelife_amb; % ambient temperature로 고정
    Config.T_rest = Config.T_cyclelife_amb;
    Config.T_discharge = Config.T_cyclelife_amb;
    Config.T_rest_after_C = Config.T_cyclelife_amb;
    Config.T_rest_after_D = Config.T_cyclelife_amb;



%% Cycling Protocol
if strcmp(Config.cycling_protocol,'FCPD') % Four cycle per day 
    Config.t_rest_after_C = 10*60;
    Config.t_rest_after_D = 10*60;
    Config.disch_C_rate = 1;
    Config.t_discharge = 3600/(Config.disch_C_rate)+3600;

elseif strcmp(Config.cycling_protocol,'OCPD') % One cycle per day
    Config.t_rest_after_C = 12*3600;
    Config.t_rest_after_D = 4*3600;
    Config.t_discharge = 6*3600;
    Config.disch_C_rate = 0.5;
    Config.t_discharge = 3600/(Config.disch_C_rate)+3600;

% elseif to add later: delayed charging

end


%% Charging Protocol

if strcmp(Config.charging_protocol,'CCCV') % multi-step이 아닌 조건
    Config.MSC_T_bucket = [-inf, inf];
    Config.MSC_V_orig = [Config.Vmin, Config.Vmax];
    Config.MSC_I_orig = [2          , 1/20];


elseif strcmp(Config.charging_protocol,'2T2CCCV') % multi-step인 조건
    Config.MSC_T_bucket = [-inf, 20; 20 inf];
    Config.MSC_V_orig = [Config.Vmin, 3.5, 4.0 Config.Vmax];
    Config.MSC_I_orig = [0.7, 0.7, 0.4, 1/50; ...
                         2.0, 1.0, 0.4, 1/50];

end





end