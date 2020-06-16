%Statistics for burst characteristics


%% Load betaburst variables for all animals and save in a new variable
clear all
cd('C:\Users\bruno\Documents\LR3\4bruno\4bruno')

CGs = {'CG02', 'CG04', 'CG05', 'CG06', 'CG07'};
TPs = {'TP00', 'TP01', 'TP02', 'TP03', 'TP04', 'TP06', 'TP08', 'TP11', 'TP14', 'TP17', 'TP21', 'TP25', 'TP29', 'TP31'};

for cg_i = 1:length(CGs)
    CG = CGs{cg_i};
    cd(['C:\Users\bruno\Documents\LR3\4bruno\4bruno\'  CG '_Ruhe'])
    all_data_stats.(CG) = [];
    for tp_i = 1: length(TPs)
        TP = TPs{tp_i};
        all_data_stats.(CG).(TP) = struct('M1',[], 'STR', [], 'SNR', []);
        cd(['C:\Users\bruno\Documents\LR3\4bruno\4bruno\'  CG '_Ruhe'])
        if exist ([CG '_' TP '_Ruhe_burst'], 'dir')
            cd(['C:\Users\bruno\Documents\LR3\4bruno\4bruno\'  CG '_Ruhe\' CG '_'  TP '_Ruhe_burst'])
            burst_M1  = load([CG  '_'  TP  '_Ruhe_M1_betaburst.mat']);
            burst_STR = load([CG  '_'  TP  '_Ruhe_STR_betaburst.mat']);
            burst_SNR = load([CG  '_'  TP  '_Ruhe_SNR_betaburst.mat']);
            all_data_stats.(CG).(TP).M1 = burst_M1.betaburst;
            all_data_stats.(CG).(TP).STR = burst_STR.betaburst;
            all_data_stats.(CG).(TP).SNR = burst_SNR.betaburst;
        end
    end
end
clearvars burst_M1 burst_STR burst_SNR cg_i tp_i TP CG

%% Combine burst length, start and area across animals for each timepoint (TP00-31) in each region

for tp_i = 1: length(TPs)
    TP = TPs{tp_i};
    for cg_i = 1:length(CGs)
        CG = CGs{cg_i};
        cd(['C:\Users\bruno\Documents\LR3\4bruno\4bruno\'  CG '_Ruhe'])
        if exist ([CG '_' TP '_Ruhe_burst'], 'dir')
            stats_burst_length.(TP).M1{cg_i} = all_data_stats.(CG).(TP).M1.NumBlockLength;
            stats_burst_length.(TP).STR{cg_i} = all_data_stats.(CG).(TP).STR.NumBlockLength;
            stats_burst_length.(TP).SNR{cg_i} = all_data_stats.(CG).(TP).SNR.NumBlockLength;
            
            stats_burst_start.(TP).M1{cg_i} = all_data_stats.(CG).(TP).M1.NumBlockStart;
            stats_burst_start.(TP).STR{cg_i} = all_data_stats.(CG).(TP).STR.NumBlockStart;
            stats_burst_start.(TP).SNR{cg_i} = all_data_stats.(CG).(TP).SNR.NumBlockStart;
            
            stats_burst_area.(TP).M1{cg_i} = all_data_stats.(CG).(TP).M1.AreaUnderCurve;
            stats_burst_area.(TP).STR{cg_i} = all_data_stats.(CG).(TP).STR.AreaUnderCurve;
            stats_burst_area.(TP).SNR{cg_i} = all_data_stats.(CG).(TP).SNR.AreaUnderCurve;
        end
    end
end


%% Statistics comparing different time points
% QQ plot (check for normal distribution. If yes: paired t test. If not: Wilcoxon rank sum test 

%Length QQ plots
figure ('Name','Length M1 TP00');
qqplot_length_m1  = qqplot(cell2mat(stats_burst_length.TP00.M1(1,:)));
figure ('Name','Length STR TP00');
qqplot_length_str = qqplot(cell2mat(stats_burst_length.TP00.STR(1,:)));
figure ('Name','Length SNR TP00');
qqplot_length_snr = qqplot(cell2mat(stats_burst_length.TP00.SNR(1,:)));

%Start QQ plots
figure ('Name','Start M1 TP00');
qqplot_start_m1  = qqplot(cell2mat(stats_burst_start.TP00.M1(1,:)));
figure ('Name','Start STR TP00');
qqplot_start_str = qqplot(cell2mat(stats_burst_start.TP00.STR(1,:)));
figure ('Name','Start SNR TP00');
qqplot_start_snr = qqplot(cell2mat(stats_burst_start.TP00.SNR(1,:)));

%Area QQ plots
figure ('Name','Length M1 TP00');
qqplot_area_m1  = qqplot(cell2mat(stats_burst_area.TP00.M1(1,:)));
figure ('Name','Length STR TP00');
qqplot_area_str = qqplot(cell2mat(stats_burst_area.TP00.STR(1,:)));
figure ('Name','Length SNR TP00');
qqplot_area_snr = qqplot(cell2mat(stats_burst_area.TP00.SNR(1,:)));


% One-sample Kolmogorov-Smirnov test (for normality, if =1 then it rejects the null hypothesis that the data is normally distributed)
%ktest for length
kstest_length_m1  = kstest (cell2mat(stats_burst_length.TP00.M1(1,:))); 
kstest_length_str = kstest (cell2mat(stats_burst_length.TP00.STR(1,:)));
kstest_length_snr = kstest (cell2mat(stats_burst_length.TP00.SNR(1,:)));

%ktest for start
kstest_start_m1  = kstest (cell2mat(stats_burst_start.TP00.M1(1,:))); 
kstest_start_str = kstest (cell2mat(stats_burst_start.TP00.STR(1,:)));
kstest_start_snr = kstest (cell2mat(stats_burst_start.TP00.SNR(1,:)));

%ktest for area
kstest_area_m1  = kstest (cell2mat(stats_burst_area.TP00.M1(1,:))); 
kstest_area_str = kstest (cell2mat(stats_burst_area.TP00.STR(1,:)));
kstest_area_snr = kstest (cell2mat(stats_burst_area.TP00.SNR(1,:)));

% Wilcoxon Rank sum test 
for tp_i = 1: length(TPs)
    TP = TPs{tp_i};
    %ranksum for burst length
    p_ranksum.length.M1.(TP) = ranksum ((cell2mat(stats_burst_length.TP00.M1(1,:))) , (cell2mat(stats_burst_length.(TP).M1(1,:)))); 
    p_ranksum.length.STR.(TP) = ranksum ((cell2mat(stats_burst_length.TP00.STR(1,:))) , (cell2mat(stats_burst_length.(TP).STR(1,:)))); 
    p_ranksum.length.SNR.(TP) = ranksum ((cell2mat(stats_burst_length.TP00.SNR(1,:))) , (cell2mat(stats_burst_length.(TP).SNR(1,:)))); 
    
    %ranksum for burst start
    p_ranksum.start.M1.(TP) = ranksum ((cell2mat(stats_burst_start.TP00.M1(1,:))) , (cell2mat(stats_burst_start.(TP).M1(1,:))));
    p_ranksum.start.STR.(TP) = ranksum ((cell2mat(stats_burst_start.TP00.STR(1,:))) , (cell2mat(stats_burst_start.(TP).STR(1,:)))); 
    p_ranksum.start.SNR.(TP) = ranksum ((cell2mat(stats_burst_start.TP00.SNR(1,:))) , (cell2mat(stats_burst_start.(TP).SNR(1,:)))); 
    
    %ranksum for burst area
    p_ranksum.area.M1.(TP) = ranksum ((cell2mat(stats_burst_area.TP00.M1(1,:))) , (cell2mat(stats_burst_area.(TP).M1(1,:))));
    p_ranksum.area.STR.(TP) = ranksum ((cell2mat(stats_burst_area.TP00.STR(1,:))) , (cell2mat(stats_burst_area.(TP).STR(1,:)))); 
    p_ranksum.area.SNR.(TP) = ranksum ((cell2mat(stats_burst_area.TP00.SNR(1,:))) , (cell2mat(stats_burst_area.(TP).SNR(1,:)))); 
end

%% Plot
%Length
m1_length  = figure ('Name', 'M1 Length');
for tp_i = 1: length(TPs)
    TP = TPs{tp_i};
    m1_mean_length (tp_i)= (mean (cell2mat(stats_burst_length.(TP).M1(1,:))));
    bar (m1_mean_length)
    %if p_ranksum.length.M1.(TP) < 0.05
        
    hold on
end
xticklabels(TPs);
hold off

str_length  = figure ('Name', 'STR Length');
for tp_i = 1: length(TPs)
    TP = TPs{tp_i};
    str_mean_length (tp_i)= (mean (cell2mat(stats_burst_length.(TP).STR(1,:))));
    bar (str_mean_length)
    hold on
end
xticklabels(TPs);
hold off 

snr_length  = figure ('Name', 'SNR Length');
for tp_i = 1: length(TPs)
    TP = TPs{tp_i};
    snr_mean_length (tp_i)= (mean (cell2mat(stats_burst_length.(TP).SNR(1,:))));
    bar (snr_mean_length)
    hold on
end
xticklabels(TPs);
hold off

%Start
m1_start  = figure ('Name', 'M1 Start');
for tp_i = 1: length(TPs)
    TP = TPs{tp_i};
    m1_mean_start (tp_i)= (mean (cell2mat(stats_burst_start.(TP).M1(1,:))));
    bar (m1_mean_start)
    hold on
end
xticklabels(TPs);
hold off

str_start  = figure ('Name', 'STR Start');
for tp_i = 1: length(TPs)
    TP = TPs{tp_i};
    str_mean_start (tp_i)= (mean (cell2mat(stats_burst_start.(TP).STR(1,:))));
    bar (str_mean_start)
    hold on
end
xticklabels(TPs);
hold off 

snr_start  = figure ('Name', 'SNR Start');
for tp_i = 1: length(TPs)
    TP = TPs{tp_i};
    snr_mean_start (tp_i)= (mean (cell2mat(stats_burst_start.(TP).SNR(1,:))));
    bar (snr_mean_start)
    hold on
end
xticklabels(TPs);
hold off

%Area
m1_area  = figure ('Name', 'M1 Area');
for tp_i = 1: length(TPs)
    TP = TPs{tp_i};
    m1_mean_area (tp_i)= (mean (cell2mat(stats_burst_area.(TP).M1(1,:))));
    bar (m1_mean_area)
    hold on
end
xticklabels(TPs);
hold off

str_area  = figure ('Name', 'STR Area');
for tp_i = 1: length(TPs)
    TP = TPs{tp_i};
    str_mean_area (tp_i)= (mean (cell2mat(stats_burst_area.(TP).STR(1,:))));
    bar (str_mean_area)
    hold on
end
xticklabels(TPs);
hold off 

snr_area  = figure ('Name', 'SNR Area');
for tp_i = 1: length(TPs)
    TP = TPs{tp_i};
    snr_mean_area (tp_i)= (mean (cell2mat(stats_burst_area.(TP).SNR(1,:))));
    bar (snr_mean_area)
    hold on
end
xticklabels(TPs);
hold off
