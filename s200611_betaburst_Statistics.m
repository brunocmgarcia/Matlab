%Statistics for burst characteristics


%% Load betaburst variable for all animals and save in a new variable
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

%% average length, area... across animals for each timepoint (TP00-31) in each region

%% Statistics comparing different time points

%% Plot

%QQ Plot to check for normality. If yes: paired t test. If not: Wilcoxon
%rank sum test (function in matlab: ranksum)