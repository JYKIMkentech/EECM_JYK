function [IntVar] = EECM_func_RR_cycle(Config, IntVar)
%% Inilization (Every cycle)
IntVar.dt = Config.dt; % **NA define in sim config
IntVar.T_cyclelife_amb = Config.T_cyclelife_amb;
IntVar.T_bucket_now = Config.MSC_T_bucket;

T_now = IntVar.T_cyclelife_amb;
SOC_now = Config.SOC0;
I_now = 0;

[Rss_now] = EECM_func_interp_3D(Config.RR.Temp_grid, Config.RR.Rate_grid, Config.RR.Rss, T_now, I_now, SOC_now, [1,2]);
OCV_now = EECM_func_interp_2D( [SOC_now, T_now], Config.OCV.SOC, Config.OCV.Temp, Config.OCV.OCV );
V_now = OCV_now + I_now*IntVar.Cap_now *Rss_now;
Sol = zeros(1);
time = 0;
i_step = 1;
charge_flag = 1; % start by charging


indx_top = i_step;

%% Simulation
thermal_dyanmics_flag = Config.thermal_dyanmics_flag;