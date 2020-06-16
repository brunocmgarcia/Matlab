% Statistics for power analysis

%% Load all fooof data and save all peak_params in a new variable
clear all
cd('C:\Users\bruno\Documents\LR3\4bruno\4bruno')

CGs = {'CG02', 'CG04', 'CG05', 'CG06', 'CG07'};
TPs = {'TP00', 'TP01', 'TP02', 'TP03', 'TP04', 'TP06', 'TP08', 'TP11', 'TP14', 'TP17', 'TP21', 'TP25', 'TP29', 'TP31'};

for cg_i = 1:length(CGs)
    CG = CGs{cg_i};
    cd(['C:\Users\bruno\Documents\LR3\4bruno\4bruno\'  CG '_Ruhe' filesep 'fooofed'])     
    for tp_i = 1:length (TPs)
        TP = TPs{tp_i};
        if isfile(['fooofed_Ruhe_M1_' TP '.mat'])
            all_fooof_stats.(CG).(TP).M1 = load (['fooofed_Ruhe_M1_' TP '.mat']);
        end
        if isfile(['fooofed_Ruhe_STR_' TP '.mat'])
            all_fooof_stats.(CG).(TP).STR = load (['fooofed_Ruhe_STR_' TP '.mat']);
        end
        if isfile(['fooofed_Ruhe_SNR_' TP '.mat'])
            all_fooof_stats.(CG).(TP).SNR = load (['fooofed_Ruhe_SNR_' TP '.mat']);
        end
    end
end
%% average peak_params across animals for each timepoint (TP00-31) in each region
% Peak parameters in order (CF: center frequency of the extracted peak, PW: power of 
% the peak, over and above the aperiodic component, BW: bandwidth of the extracted peak)
for tp_i = 1: length(TPs)
    TP = TPs{tp_i};
    for cg_i = 1:length(CGs)
        CG = CGs{cg_i};
        cd(['C:\Users\bruno\Documents\LR3\4bruno\4bruno\'  CG '_Ruhe\fooofed'])
        if isfile (['fooofed_Ruhe_M1_' TP '.mat']) %check if this TP file exists
            if ~isempty(all_fooof_stats.(CG).(TP).M1.peak_params)
               stats_peak_center.(TP).M1{cg_i}  = all_fooof_stats.(CG).(TP).M1.peak_params(1); %center frequency of peak
               stats_peak_power.(TP).M1{cg_i}  = all_fooof_stats.(CG).(TP).M1.peak_params(2); % power of peak

            else
               stats_peak_center.(TP).M1{cg_i}  = [];
               stats_peak_power.(TP).M1{cg_i}   = [];
            end
            
            if ~isempty(all_fooof_stats.(CG).(TP).STR.peak_params)
               stats_peak_center.(TP).STR{cg_i}  = all_fooof_stats.(CG).(TP).STR.peak_params(1);
               stats_peak_power.(TP).STR{cg_i}   = all_fooof_stats.(CG).(TP).STR.peak_params(2);
            else
               stats_peak_center.(TP).STR{cg_i}  = [];
               stats_peak_power.(TP).STR{cg_i}   = [];
            end
            
            if ~isempty(all_fooof_stats.(CG).(TP).SNR.peak_params)
               stats_peak_center.(TP).SNR{cg_i}  = all_fooof_stats.(CG).(TP).SNR.peak_params(1);
               stats_peak_power.(TP).SNR{cg_i}   = all_fooof_stats.(CG).(TP).SNR.peak_params(2);
            else
               stats_peak_center.(TP).SNR{cg_i}  = [];
               stats_peak_power.(TP).SNR{cg_i}   = [];
            end
        end
    end
    
end

%average results across animals per TP per Region
for tp_i = 1: length(TPs)
    TP = TPs{tp_i};
    stats_peak_center_avg.(TP).M1 = mean(cat(1, stats_peak_center.(TP).M1{:}));
    stats_peak_center_avg.(TP).STR = mean(cat(1, stats_peak_center.(TP).STR{:}));
    stats_peak_center1_avg.(TP).SNR = mean(cat(1, stats_peak_center.(TP).SNR{:}));

    stats_peak_power_avg.(TP).M1 = mean(cat(1, stats_peak_power.(TP).M1{:}));
    stats_peak_power_avg.(TP).STR = mean(cat(1, stats_peak_power.(TP).STR{:}));
    stats_peak_power_avg.(TP).SNR = mean(cat(1, stats_peak_power.(TP).SNR{:}));
end

%% Statistics comparing different time points
%Wilcoxon signed rank test (signrank)
p = signrank (cat(1, stats_peak_center.TP00.M1{:}), cat(1, stats_peak_center.TP31.M1{:}));


%% Plot