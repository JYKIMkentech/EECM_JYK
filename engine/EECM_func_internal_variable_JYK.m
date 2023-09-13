function [IntVar] = EECM_func_internal_variable(Config) % [Config, IntVar]도 가능

% EECM Engine
% Define internal variables


IntVar.cap_fade_now = 0;
IntVar.cap_fade_now1 = 0;
IntVar.cap_fade_now2 = 0;
IntVar.cap_fade_now3 = 0;

IntVar.Cap_now = Config.Cap0;

IntVar.T_now = Config.T_cyclelife_amb;

IntVar.t_clock = 0; % record the clock time during cycling

IntVar.V_top_rec = [];
IntVar.cap_fade = [];

end