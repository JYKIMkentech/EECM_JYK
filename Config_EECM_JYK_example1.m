% 구성 요소 확립

Config.cellid = 'example1';
Config.cycle_last = 5;

Config.cycle_initial = 1;
Config.SOC0 = 0;

Config.Vmax = 4.45; % [V]
Config.Vmin = 3.0; % [V]

Config.dt = 30; % [sec] time step for simulation
Config.thermal_dyanmics_flag = 0; % on/off thermal model

% 경로 지정

Config.folder_config = pwd; % path to folder containing config 
Config.folder_model = 'G:\공유 드라이브\Battery Software Lab\EECM\example_1';
Config.folder_engine = [pwd filesep 'engine'];
    % assuming simulation and config are in the same folder,
    % where engine files are in a subfolder.
    addpath(Config.folder_config, Config.folder_engine)

Config.path_RRmodel = [Config.folder_model filesep 'example1_RRmodel.mat'];
Config.path_ocv_chg = [Config.folder_model filesep 'example1_OCV_chg.mat'];
Config.path_ocv_dch = [Config.folder_model filesep 'example1_OCV_dis.mat'];
Config.path_ocv = Config.path_ocv_chg;

% RR sturt 실행

load(Config.path_RRmodel) 
Config.RR = DataBank; % DataBanck의 RR값을 Config struct에 추가
clear Databank

Config.Cap0 = mean(Config.RR.Qmax); % initial cell capacity
Config.RR.SOC_grid = linspace(0,1,201)'; % SOC grid defined % 201개는 임의로 한 것인가? 


% 기존 data로 부터 얻은 (SOC,R)값을 (등간격 201개 SOC, 해당하는 저항으로 interp1, extrap) 하는 과정 

for i = 1:size(Config.RR.Rss,1) % Cell의 세로줄(온도) 만큼 반복
    for j = 1:size(Config.RR.Rss,2) % Cell의 가로줄 (C-rate 만큼 반복)
        y(:,1) = Config.RR.SOC_grid; % y struct안에 1줄에 등간격 SOC, 2줄에 보간된 R 지정
        for k = 2:size(Config.RR.Rss{i,j},2) % 기존 data는 (SOC,R) 밖에 없지만 추가 될 경우에 그 항수만큼 반복 (현재는 K = 2)
            y(:,k) = interp1(Config.RR.Rss{i,j}(:,1), Config.RR.Rss{i,j}(:,k),Config.RR.SOC_grid,'linear','extrap'); % y = (등간격 201개 SOC, 그에 따른 보간된 R) 
        end
        Config.RR.Rss{i,j} = y;
    end
end

% Vref도 반복
for i = 1:size(Config.RR.Vref,1)
    for j = 1:size(Config.RR.Vref,2)
        y = zeros(length(Config.RR.SOC_grid),size(Config.RR.Vref{i,j},2));
        y(:,1) = Config.RR.SOC_grid;
        for k = 2:size(Config.RR.Vref{i,j},2) % for case there is more than one Vref columns
            y(:,k) = interp1(Config.RR.Vref{i,j}(:,1),Config.RR.Vref{i,j}(:,k),y(:,1),'linear','extrap');
        end
        Config.RR.Vref{i,j} = y;
    end
end

% OCV 실행

load(Config.path_ocv) % variable name: 'OCV'
Config.OCV = OCV;
clear OCV










