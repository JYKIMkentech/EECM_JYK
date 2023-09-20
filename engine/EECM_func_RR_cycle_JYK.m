function [IntVar] = EECM_func_RR_cycle(Config, IntVar)
%% 모든 사이클 초기화
IntVar.dt = Config.dt; % **NA define in sim config
IntVar.T_cyclelife_amb = Config.T_cyclelife_amb;
IntVar.T_bucket_now = Config.MSC_T_bucket;

T_now = IntVar.T_cyclelife_amb;
SOC_now = Config.SOC0; 
I_now = 0;

[Rss_now] = EECM_func_interp_3D(Config.RR.Temp_grid, Config.RR.Rate_grid, Config.RR.Rss, T_now, I_now, SOC_now, [1,2]);
OCV_now = EECM_func_interp_2D( [SOC_now, T_now], Config.OCV.SOC, Config.OCV.Temp, Config.OCV.OCV );
V_now = OCV_now + I_now*IntVar.Cap_now *Rss_now; % V = OCV + IR ( 현재 I는 c-rate값이므로 capacity를 곱해줘야 A로 환산가능)
Sol = zeros(1);
time = 0;
i_step = 1;
charge_flag = 1; % Charging으로 시작


indx_top = i_step;

%% Simulation
thermal_dyanmics_flag = Config.thermal_dyanmics_flag;