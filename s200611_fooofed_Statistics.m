% Statistics for power analysis

%% Load all fooof data and save all peak_params in a new variable
clear all
cd('C:\Users\bruno\Documents\LR3\4bruno\4bruno')

CGs = {'CG02', 'CG04', 'CG05', 'CG06', 'CG07'};
TPs = {'TP00', 'TP01', 'TP02', 'TP03', 'TP04', 'TP06', 'TP08', 'TP11', 'TP14', 'TP17', 'TP21', 'TP25', 'TP29', 'TP31'};

for cg_i = 1:length(CGs)
    CG = CGs{cg_i};
    cd(['C:\Users\bruno\Documents\LR3\4bruno\4bruno\'  CG '_Ruhe' filesep 'pwelch_results'])     
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
for cg_i = 1:length(CGs)
        CG = CGs{cg_i};
        cd(['C:\Users\bruno\Documents\LR3\4bruno\4bruno\'  CG '_Ruhe\fooofed'])
        for tp_i = 1: length(TPs)
            TP = TPs{tp_i};
            if isfile (['fooofed_Ruhe_M1_' TP '.mat']) %check if this TP file exists
                if ~isempty(all_fooof_stats.(CG).(TP).M1.peak_params)
                    stats_max_center.(CG).M1{tp_i}  = all_fooof_stats.(CG).(TP).M1.peak_params(1); %center frequency of peak
                    stats_max_power.(CG).M1{tp_i}  = all_fooof_stats.(CG).(TP).M1.peak_params(2); % power of peak
                else
                    stats_max_center.(CG).M1{tp_i}  = [];
                    stats_max_power.(CG).M1{tp_i}   = [];
                end
                
                if ~isempty(all_fooof_stats.(CG).(TP).STR.peak_params)
                    stats_max_center.(CG).STR{tp_i}  = all_fooof_stats.(CG).(TP).STR.peak_params(1);
                    stats_max_power.(CG).STR{tp_i}   = all_fooof_stats.(CG).(TP).STR.peak_params(2);
                else
                    stats_max_center.(CG).STR{tp_i}  = [];
                    stats_max_power.(CG).STR{tp_i}   = [];
                end
                
                if isfield(all_fooof_stats.(CG).(TP), 'SNR') && ~isempty(all_fooof_stats.(CG).(TP).SNR.peak_params)
                    stats_max_center.(CG).SNR{tp_i}  = all_fooof_stats.(CG).(TP).SNR.peak_params(1);
                    stats_max_power.(CG).SNR{tp_i}   = all_fooof_stats.(CG).(TP).SNR.peak_params(2);
                else
                    stats_max_center.(CG).SNR{tp_i}  = [];
                    stats_max_power.(CG).SNR{tp_i}   = [];
                end
            end
        end
end


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
            
            if isfield(all_fooof_stats.(CG).(TP), 'SNR') && ~isempty(all_fooof_stats.(CG).(TP).SNR.peak_params)
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
    stats_peak_center_avg.(TP).SNR = mean(cat(1, stats_peak_center.(TP).SNR{:}));

    stats_peak_power_avg.(TP).M1 = mean(cat(1, stats_peak_power.(TP).M1{:}));
    stats_peak_power_avg.(TP).STR = mean(cat(1, stats_peak_power.(TP).STR{:}));
    stats_peak_power_avg.(TP).SNR = mean(cat(1, stats_peak_power.(TP).SNR{:}));
end

%% Statistics comparing different time points
% % One-sample Kolmogorov-Smirnov test 
% %(for normality, if =1 then it rejects the null hypothesis that the data is normally distributed)
%ktest for power
kstest_power_m1  = kstest (cell2mat(stats_peak_power.TP00.M1(1, :))); 
kstest_power_str = kstest (cell2mat(stats_peak_power.TP00.STR(1, :)));
kstest_power_snr = kstest (cell2mat(stats_peak_power.TP00.SNR(1, :)));

%ktest for center
kstest_center_m1  = kstest (cell2mat(stats_peak_center.TP00.M1(1, :))); 
kstest_center_str = kstest (cell2mat(stats_peak_center.TP00.STR(1, :)));
kstest_center_snr = kstest (cell2mat(stats_peak_center.TP00.SNR(1, :)));

for tp_i = 1: length(TPs)
    TP = TPs{tp_i};
    if ~strcmp (TP, 'TP06') 
        if ~strcmp (TP, 'TP17')
            %No Ruhe_CG02_TP17 and no Ruhe_CG04_TP17 data files, so these were not analysed.
            %Since the signrank function requires equal number of elements to
            %comparison the statistics for these 2 TP are not possible (at
            %least for now, maybe there is a way - have to look for it)
            
%             %signrank for median peak power
%             p_signrank.peak_power.M1.(TP) = signrank (cell2mat(stats_peak_power.TP00.M1(1, :)), cell2mat(stats_peak_power.(TP).M1(1, :)));
%             p_signrank.peak_power.STR.(TP) = signrank (cell2mat(stats_peak_power.TP00.STR(1, :)), cell2mat(stats_peak_power.(TP).STR(1, :)));
%             p_signrank.peak_power.SNR.(TP) = signrank (cell2mat(stats_peak_power.TP00.SNR(1, :)), cell2mat(stats_peak_power.(TP).SNR(1, :)));
            
            %signrank for median peak center
            p_signrank.peak_center.M1.(TP) = ttest (cell2mat(stats_peak_center.TP00.M1(1, :)), cell2mat(stats_peak_center.(TP).M1(1, :)));
            p_signrank.peak_center.STR.(TP) = ttest (cell2mat(stats_peak_center.TP00.STR(1, :)), cell2mat(stats_peak_center.(TP).STR(1, :)));
            p_signrank.peak_center.SNR.(TP) = ttest (cell2mat(stats_peak_center.TP00.SNR(1, :)), cell2mat(stats_peak_center.(TP).SNR(1, :)));
        end
    end
end

%% Plot

%Plot peak center avg M1 
for tp_i = 1:length(TPs)
    TP = TPs{tp_i};
    center_m1(tp_i) = stats_peak_center_avg.(TP).M1;
end
figure ('Name', 'Peak Center Frequency - M1')
bar (center_m1)
xticklabels(TPs);
ylabel('Frequency (Hz)')

%Plot peak center avg STR 
for tp_i = 1:length(TPs)
    TP = TPs{tp_i};
    center_str(tp_i) = stats_peak_center_avg.(TP).STR;
end
figure ('Name', 'Peak Center Frequency - STR')
bar (center_str)
xticklabels(TPs);
ylabel('Frequency (Hz)')

%Plot peak center avg SNR 
for tp_i = 1:length(TPs)
    TP = TPs{tp_i};
    center_snr(tp_i) = stats_peak_center_avg.(TP).SNR;
end
figure ('Name', 'Peak Center Frequency - SNR')
bar (center_snr)
xticklabels(TPs);
ylabel('Frequency (Hz)')



%Plot peak power avg M1 
for tp_i = 1:length(TPs)
    TP = TPs{tp_i};
    power_m1(tp_i) = stats_peak_power_avg.(TP).M1;
end
figure ('Name', 'Peak Power - M1')
bar (power_m1)
xticklabels(TPs);

%Plot peak power avg STR 
for tp_i = 1:length(TPs)
    TP = TPs{tp_i};
    power_str(tp_i) = stats_peak_power_avg.(TP).STR;
end
figure ('Name', 'Peak Power - STR')
bar (power_str)
xticklabels(TPs);

%Plot peak power avg SNR 
for tp_i = 1:length(TPs)
    TP = TPs{tp_i};
    power_snr(tp_i) = stats_peak_power_avg.(TP).SNR;
end
figure ('Name', 'Peak Power - SNR')
bar (power_snr)
xticklabels(TPs);

%Plot overlap fooofed power spectra
figure1= figure ('Name', 'M1 Power - CG04');
% for cg_i = 1:length(CGs)
% newcolors = {'#F00','#F01','#F20','#F30','#F40','#F50','#F60','#F70','#F80','#F90','#F10','#F11','#F12','#F13'};
% colororder(newcolors)
%         CG = CGs{cg_i};
for tp_i = 1: length(TPs)
    TP = TPs{tp_i};
    if ~strcmp (TP, 'TP06')
        plot (all_fooof_stats.CG04.(TP).M1.freqs, all_fooof_stats.CG04.(TP).M1.fooofed, 'Color', [0.9 0.1 0.1] );
        hold on
    end
end
hold off
legend(TPs)

% end

