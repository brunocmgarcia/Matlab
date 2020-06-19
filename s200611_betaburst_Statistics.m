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
            if ~strcmp(CG,'CG06')
                burst_SNR = load([CG  '_'  TP  '_Ruhe_SNR_betaburst.mat']);
            end
            all_data_stats.(CG).(TP).M1 = burst_M1.betaburst;
            all_data_stats.(CG).(TP).STR = burst_STR.betaburst;
            if ~strcmp(CG,'CG06')
                all_data_stats.(CG).(TP).SNR = burst_SNR.betaburst;
            end
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
        if strcmp(CG,'CG06') %there were no good channels for SNR in CG06, so this is just to take this into account
            if exist ([CG '_' TP '_Ruhe_burst'], 'dir')
                stats_burst_length.(TP).M1{cg_i} = all_data_stats.(CG).(TP).M1.NumBlockLength;
                stats_burst_length.(TP).STR{cg_i} = all_data_stats.(CG).(TP).STR.NumBlockLength;
                stats_burst_length.(TP).SNR{cg_i} = [];
                
                stats_burst_BinNumber_Length.(TP).M1{cg_i} = all_data_stats.(CG).(TP).M1.BinNumber_Length;
                stats_burst_BinNumber_Length.(TP).STR{cg_i} = all_data_stats.(CG).(TP).STR.BinNumber_Length;
                stats_burst_BinNumber_Length.(TP).SNR{cg_i} = [];
                
                stats_burst_BinNumber_Area.(TP).M1{cg_i} = all_data_stats.(CG).(TP).M1.BinNumber_Area;
                stats_burst_BinNumber_Area.(TP).STR{cg_i} = all_data_stats.(CG).(TP).STR.BinNumber_Area;
                stats_burst_BinNumber_Area.(TP).SNR{cg_i} = [];
                
                stats_burst_BinEdges_Length.(TP).M1{cg_i} = all_data_stats.(CG).(TP).M1.BinEdges_Length;
                stats_burst_BinEdges_Length.(TP).STR{cg_i} = all_data_stats.(CG).(TP).STR.BinEdges_Length;
                stats_burst_BinEdges_Length.(TP).SNR{cg_i} = [];
                
                stats_burst_BinEdges_Area.(TP).M1{cg_i} = all_data_stats.(CG).(TP).M1.BinEdges_Area;
                stats_burst_BinEdges_Area.(TP).STR{cg_i} = all_data_stats.(CG).(TP).STR.BinEdges_Area;
                stats_burst_BinEdges_Area.(TP).SNR{cg_i} = [];
                
                stats_burst_BinPercentage_Length.(TP).M1{cg_i} = all_data_stats.(CG).(TP).M1.BinPercentage_Length;
                stats_burst_BinPercentage_Length.(TP).STR{cg_i} = all_data_stats.(CG).(TP).STR.BinPercentage_Length;
                stats_burst_BinPercentage_Length.(TP).SNR{cg_i} = [];
                
                stats_burst_BinPercentage_Area.(TP).M1{cg_i} = all_data_stats.(CG).(TP).M1.BinPercentage_Area;
                stats_burst_BinPercentage_Area.(TP).STR{cg_i} = all_data_stats.(CG).(TP).STR.BinPercentage_Area;
                stats_burst_BinPercentage_Area.(TP).SNR{cg_i} = [];
                
                stats_burst_area.(TP).M1{cg_i} = all_data_stats.(CG).(TP).M1.AreaUnderCurve;
                stats_burst_area.(TP).STR{cg_i} = all_data_stats.(CG).(TP).STR.AreaUnderCurve;
                stats_burst_area.(TP).SNR{cg_i} = [];
            end
        else
            if exist ([CG '_' TP '_Ruhe_burst'], 'dir')
                stats_burst_length.(TP).M1{cg_i} = all_data_stats.(CG).(TP).M1.NumBlockLength;
                stats_burst_length.(TP).STR{cg_i} = all_data_stats.(CG).(TP).STR.NumBlockLength;
                stats_burst_length.(TP).SNR{cg_i} = all_data_stats.(CG).(TP).SNR.NumBlockLength;
                
                stats_burst_BinNumber_Length.(TP).M1{cg_i} = all_data_stats.(CG).(TP).M1.BinNumber_Length;
                stats_burst_BinNumber_Length.(TP).STR{cg_i} = all_data_stats.(CG).(TP).STR.BinNumber_Length;
                stats_burst_BinNumber_Length.(TP).SNR{cg_i} = all_data_stats.(CG).(TP).SNR.BinNumber_Length;
                
                stats_burst_BinNumber_Area.(TP).M1{cg_i} = all_data_stats.(CG).(TP).M1.BinNumber_Area;
                stats_burst_BinNumber_Area.(TP).STR{cg_i} = all_data_stats.(CG).(TP).STR.BinNumber_Area;
                stats_burst_BinNumber_Area.(TP).SNR{cg_i} = all_data_stats.(CG).(TP).SNR.BinNumber_Area;
                
                stats_burst_BinEdges_Length.(TP).M1{cg_i} = all_data_stats.(CG).(TP).M1.BinEdges_Length;
                stats_burst_BinEdges_Length.(TP).STR{cg_i} = all_data_stats.(CG).(TP).STR.BinEdges_Length;
                stats_burst_BinEdges_Length.(TP).SNR{cg_i} = all_data_stats.(CG).(TP).SNR.BinEdges_Length;
                
                stats_burst_BinEdges_Area.(TP).M1{cg_i} = all_data_stats.(CG).(TP).M1.BinEdges_Area;
                stats_burst_BinEdges_Area.(TP).STR{cg_i} = all_data_stats.(CG).(TP).STR.BinEdges_Area;
                stats_burst_BinEdges_Area.(TP).SNR{cg_i} = all_data_stats.(CG).(TP).SNR.BinEdges_Area;
                
                stats_burst_BinPercentage_Length.(TP).M1{cg_i} = all_data_stats.(CG).(TP).M1.BinPercentage_Length;
                stats_burst_BinPercentage_Length.(TP).STR{cg_i} = all_data_stats.(CG).(TP).STR.BinPercentage_Length;
                stats_burst_BinPercentage_Length.(TP).SNR{cg_i} = all_data_stats.(CG).(TP).SNR.BinPercentage_Length;
                
                stats_burst_BinPercentage_Area.(TP).M1{cg_i} = all_data_stats.(CG).(TP).M1.BinPercentage_Area;
                stats_burst_BinPercentage_Area.(TP).STR{cg_i} = all_data_stats.(CG).(TP).STR.BinPercentage_Area;
                stats_burst_BinPercentage_Area.(TP).SNR{cg_i} = all_data_stats.(CG).(TP).SNR.BinPercentage_Area;
                
                stats_burst_area.(TP).M1{cg_i} = all_data_stats.(CG).(TP).M1.AreaUnderCurve;
                stats_burst_area.(TP).STR{cg_i} = all_data_stats.(CG).(TP).STR.AreaUnderCurve;
                stats_burst_area.(TP).SNR{cg_i} = all_data_stats.(CG).(TP).SNR.AreaUnderCurve;
            end
        end
    end
end

%% Statistics comparing different time points
% QQ plot (check for normal distribution. If yes: paired t test. If not: Wilcoxon rank sum test 

% %Length QQ plots
% figure ('Name','Length M1 TP00');
% qqplot_length_m1  = qqplot(cell2mat(stats_burst_length.TP00.M1(1,:)));
% figure ('Name','Length STR TP00');
% qqplot_length_str = qqplot(cell2mat(stats_burst_length.TP00.STR(1,:)));
% figure ('Name','Length SNR TP00');
% qqplot_length_snr = qqplot(cell2mat(stats_burst_length.TP00.SNR(1,:)));
% 
% %Area QQ plots
% figure ('Name','Length M1 TP00');
% qqplot_area_m1  = qqplot(cell2mat(stats_burst_area.TP00.M1(1,:)));
% figure ('Name','Length STR TP00');
% qqplot_area_str = qqplot(cell2mat(stats_burst_area.TP00.STR(1,:)));
% figure ('Name','Length SNR TP00');
% qqplot_area_snr = qqplot(cell2mat(stats_burst_area.TP00.SNR(1,:)));


% One-sample Kolmogorov-Smirnov test 
%(for normality, if =1 then it rejects the null hypothesis that the data is normally distributed)
%ktest for length
kstest_length_m1  = kstest (cell2mat(stats_burst_length.TP00.M1(1,:))); 
kstest_length_str = kstest (cell2mat(stats_burst_length.TP00.STR(1,:)));
kstest_length_snr = kstest (cell2mat(stats_burst_length.TP00.SNR(1,:)));

%ktest for area
kstest_area_m1  = kstest (cell2mat(stats_burst_area.TP00.M1(1,:))); 
kstest_area_str = kstest (cell2mat(stats_burst_area.TP00.STR(1,:)));
kstest_area_snr = kstest (cell2mat(stats_burst_area.TP00.SNR(1,:)));

%ktest for BinNumber_length
kstest_BinNumber_Length_m1  = kstest (cell2mat(stats_burst_BinNumber_Length.TP00.M1(1,:))); 
kstest_BinNumber_Length_str = kstest (cell2mat(stats_burst_BinNumber_Length.TP00.STR(1,:)));
kstest_BinNumber_Length_snr = kstest (cell2mat(stats_burst_BinNumber_Length.TP00.SNR(1,:)));

%ktest for BinPercentage_length
kstest_BinPercentage_Length_m1  = kstest (cell2mat(stats_burst_BinPercentage_Length.TP00.M1(1,:))); 
kstest_BinPercentage_Length_str = kstest (cell2mat(stats_burst_BinPercentage_Length.TP00.STR(1,:)));
kstest_BinPercentage_Length_snr = kstest (cell2mat(stats_burst_BinPercentage_Length.TP00.SNR(1,:)));

%ktest for BinNumber_area
kstest_BinNumber_Area_m1  = kstest (cell2mat(stats_burst_BinNumber_Area.TP00.M1(1,:))); 
kstest_BinNumber_Area_str = kstest (cell2mat(stats_burst_BinNumber_Area.TP00.STR(1,:)));
kstest_BinNumber_Area_snr = kstest (cell2mat(stats_burst_BinNumber_Area.TP00.SNR(1,:)));

%ktest for BinPercentage_area
kstest_BinPercentage_Area_m1  = kstest (cell2mat(stats_burst_BinPercentage_Area.TP00.M1(1,:))); 
kstest_BinPercentage_Area_str = kstest (cell2mat(stats_burst_BinPercentage_Area.TP00.STR(1,:)));
kstest_BinPercentage_Area_snr = kstest (cell2mat(stats_burst_BinPercentage_Area.TP00.SNR(1,:)));


% Wilcoxon Signed Rank test (non-parametric, paired, continuous data)
for tp_i = 1: length(TPs)
    TP = TPs{tp_i};
    if ~strcmp (TP, 'TP06') 
        if ~strcmp (TP, 'TP17')
            %No Ruhe_CG02_TP17 and no Ruhe_CG04_TP17 data files, so these were not analysed.
            %Since the signrank function requires equal number of elements to
            %comparison the statistics for these 2 TP are not possible (at
            %least for now, maybe there is a way - have to look for it)
            
%             %signrank for mean burst length
%             p_signrank.Burst_Length.M1.(TP) = signrank ((cell2mat(stats_burst_length.TP00.M1(1,:))) , (cell2mat(stats_burst_length.(TP).M1(1,:))));
%             p_signrank.Burst_Length.STR.(TP) = signrank ((cell2mat(stats_burst_length.TP00.STR(1,:))) , (cell2mat(stats_burst_length.(TP).STR(1,:))));
%             p_signrank.Burst_Length.SNR.(TP) = signrank ((cell2mat(stats_burst_length.TP00.SNR(1,:))) , (cell2mat(stats_burst_length.(TP).SNR(1,:))));
%             
%             %signrank for mean burst area
%             p_signrank.Burst_Area.M1.(TP) = signrank ((cell2mat(stats_burst_area.TP00.M1(1,:))) , (cell2mat(stats_burst_area.(TP).M1(1,:))));
%             p_signrank.Burst_Area.STR.(TP) = signrank ((cell2mat(stats_burst_area.TP00.STR(1,:))) , (cell2mat(stats_burst_area.(TP).STR(1,:))));
%             p_signrank.Burst_Area.SNR.(TP) = signrank ((cell2mat(stats_burst_area.TP00.SNR(1,:))) , (cell2mat(stats_burst_area.(TP).SNR(1,:))));
%             
            %signrank for binned number length
            p_signrank.BinNumber_Length.M1.(TP) = signrank ((cell2mat(stats_burst_BinNumber_Length.TP00.M1(1,:))) , (cell2mat(stats_burst_BinNumber_Length.(TP).M1(1,:))));
            p_signrank.BinNumber_Length.STR.(TP) = signrank ((cell2mat(stats_burst_BinNumber_Length.TP00.STR(1,:))) , (cell2mat(stats_burst_BinNumber_Length.(TP).STR(1,:))));
            p_signrank.BinNumber_Length.SNR.(TP) = signrank ((cell2mat(stats_burst_BinNumber_Length.TP00.SNR(1,:))) , (cell2mat(stats_burst_BinNumber_Length.(TP).SNR(1,:))));
            
            %signrank for binned number area
            p_signrank.BinNumber_Area.M1.(TP) = signrank ((cell2mat(stats_burst_BinNumber_Area.TP00.M1(1,:))) , (cell2mat(stats_burst_BinNumber_Area.(TP).M1(1,:))));
            p_signrank.BinNumber_Area.STR.(TP) = signrank ((cell2mat(stats_burst_BinNumber_Area.TP00.STR(1,:))) , (cell2mat(stats_burst_BinNumber_Area.(TP).STR(1,:))));
            p_signrank.BinNumber_Area.SNR.(TP) = signrank ((cell2mat(stats_burst_BinNumber_Area.TP00.SNR(1,:))) , (cell2mat(stats_burst_BinNumber_Area.(TP).SNR(1,:))));
            
            %signrank for binned percentage length
            p_signrank.BinPercentage_Length.M1.(TP) = signrank ((cell2mat(stats_burst_BinPercentage_Length.TP00.M1(1,:))) , (cell2mat(stats_burst_BinPercentage_Length.(TP).M1(1,:))));
            p_signrank.BinPercentage_Length.STR.(TP) = signrank ((cell2mat(stats_burst_BinPercentage_Length.TP00.STR(1,:))) , (cell2mat(stats_burst_BinPercentage_Length.(TP).STR(1,:))));
            p_signrank.BinPercentage_Length.SNR.(TP) = signrank ((cell2mat(stats_burst_BinPercentage_Length.TP00.SNR(1,:))) , (cell2mat(stats_burst_BinPercentage_Length.(TP).SNR(1,:))));
            
            %signrank for binned percentage area
            p_signrank.BinPercentage_Area.M1.(TP) = signrank ((cell2mat(stats_burst_BinPercentage_Area.TP00.M1(1,:))) , (cell2mat(stats_burst_BinPercentage_Area.(TP).M1(1,:))));
            p_signrank.BinPercentage_Area.STR.(TP) = signrank ((cell2mat(stats_burst_BinPercentage_Area.TP00.STR(1,:))) , (cell2mat(stats_burst_BinPercentage_Area.(TP).STR(1,:))));
            p_signrank.BinPercentage_Area.SNR.(TP) = signrank ((cell2mat(stats_burst_BinPercentage_Area.TP00.SNR(1,:))) , (cell2mat(stats_burst_BinPercentage_Area.(TP).SNR(1,:))));
        end
    end
end

%% Plot
%Burst Length
m1_length  = figure ('Name', 'Median M1 Burst Length');
for tp_i = 1: length(TPs)
    TP = TPs{tp_i};
    m1_median_length (tp_i)= (median (cell2mat(stats_burst_length.(TP).M1(1,:))));
    bar (m1_median_length)
    %if p_ranksum.length.M1.(TP) < 0.05
        
    hold on
end
xticklabels(TPs);
hold off

str_length  = figure ('Name', 'Median STR Burst Length');
for tp_i = 1: length(TPs)
    TP = TPs{tp_i};
    str_median_length (tp_i)= (median (cell2mat(stats_burst_length.(TP).STR(1,:))));
    bar (str_median_length)
    hold on
end
xticklabels(TPs);
hold off 

snr_length  = figure ('Name', 'Median SNR Burst Length');
for tp_i = 1: length(TPs)
    TP = TPs{tp_i};
    snr_median_length (tp_i)= (median (cell2mat(stats_burst_length.(TP).SNR(1,:))));
    bar (snr_median_length)
    hold on
end
xticklabels(TPs);
hold off


%Burst Area
m1_area  = figure ('Name', 'Median M1 Burst Area');
for tp_i = 1: length(TPs)
    TP = TPs{tp_i};
    m1_median_area (tp_i)= (median (cell2mat(stats_burst_area.(TP).M1(1,:))));
    bar (m1_median_area)
    hold on
end
xticklabels(TPs);
hold off

str_area  = figure ('Name', 'Median STR Burst Area');
for tp_i = 1: length(TPs)
    TP = TPs{tp_i};
    str_median_area (tp_i)= (median (cell2mat(stats_burst_area.(TP).STR(1,:))));
    bar (str_median_area)
    hold on
end
xticklabels(TPs);
hold off 

snr_area  = figure ('Name', 'Median SNR Burst Area');
for tp_i = 1: length(TPs)
    TP = TPs{tp_i};
    snr_median_area (tp_i)= (median (cell2mat(stats_burst_area.(TP).SNR(1,:))));
    bar (snr_median_area)
    hold on
end
xticklabels(TPs);
hold off

% Percentage Binned Length
m1_start  = figure ('Name', 'Median M1 Binned Length');
for tp_i = 1: length(TPs)
    TP = TPs{tp_i};
    m1_median_binlength (tp_i)= (median (cell2mat(stats_burst_BinPercentage_Length.(TP).M1(1,:))));
    bar (m1_median_binlength)
    hold on
end
xticklabels(TPs);
hold off

str_start  = figure ('Name', 'Median STR Binned Length');
for tp_i = 1: length(TPs)
    TP = TPs{tp_i};
    str_median_binlength (tp_i)= (median (cell2mat(stats_burst_BinPercentage_Length.(TP).STR(1,:))));
    bar (str_median_binlength)
    hold on
end
xticklabels(TPs);
hold off 

snr_start  = figure ('Name', 'Median SNR Binned Length');
for tp_i = 1: length(TPs)
    TP = TPs{tp_i};
    snr_median_binlength (tp_i)= (median (cell2mat(stats_burst_BinPercentage_Length.(TP).SNR(1,:))));
    bar (snr_median_binlength)
    hold on
end
xticklabels(TPs);
hold off

% Percentage Binned Area
m1_start  = figure ('Name', 'Median M1 Binned Area');
for tp_i = 1: length(TPs)
    TP = TPs{tp_i};
    m1_median_binArea (tp_i)= (median (cell2mat(stats_burst_BinPercentage_Area.(TP).M1(1,:))));
    bar (m1_median_binArea)
    hold on
end
xticklabels(TPs);
hold off

str_start  = figure ('Name', 'Median STR Binned Area');
for tp_i = 1: length(TPs)
    TP = TPs{tp_i};
    str_median_binArea (tp_i)= (median (cell2mat(stats_burst_BinPercentage_Area.(TP).STR(1,:))));
    bar (str_median_binArea)
    hold on
end
xticklabels(TPs);
hold off 

snr_start  = figure ('Name', 'Median SNR Binned Area');
for tp_i = 1: length(TPs)
    TP = TPs{tp_i};
    snr_median_binArea (tp_i)= (median (cell2mat(stats_burst_BinPercentage_Area.(TP).SNR(1,:))));
    bar (snr_median_binArea)
    hold on
end
xticklabels(TPs);
hold off


%% Plot Binned results for burst length and area. One plot per TP

%Creates a histogram with the median binned burst length across animals for each TP 
Bin_Length = [0.03:0.03:1 inf];
for tp_i = 1: length(TPs)
    TP = TPs{tp_i};
    plot_binPercent_m1 (tp_i, :)= (median ((cell2mat(stats_burst_BinPercentage_Length.(TP).M1(1,:)')),1)); %median across CGs in one TP for each bin
%     plot_binPercent_m1.(TP)= cell2mat(stats_burst_BinPercentage_Length.(TP).M1(1,:)');
%     binLength_signrank = signrank ( plot_binPercent_m1.TP00(:,1), plot_binPercent_m1.(TP)(:,1) );
    if ~strcmp (TP, 'TP00')
        figure ('Name',  ['Binned Burst Length - M1 - ' (TP)])
        bar (Bin_Length, [plot_binPercent_m1(1,:);plot_binPercent_m1(tp_i,:)] )
        xlabel('Bin Duration (ms)')
        ylabel ('Percentage of Bursts')
    end
end

for bin_i = 1:length (Bin_Length)
    

end


figure ('Name', 'M1 Binned Burst Length')
BinLength_bar = bar (Bin_Length, plot_binPercent_m1');
set(BinLength_bar, {'DisplayName'}, TPs')
xlabel('Bin Duration (ms)')
% xlim([0 0.6])
ylabel ('Percentage of Bursts')
legend() 

% Plot each Bin separetely, each figure is one bin, each bar is a TP
plot_binPercent_m1_1 = plot_binPercent_m1';
for plot_i = 1: length (Bin_Length)
    figure ('Name', ['M1 Burst Length = ' num2str(Bin_Length(plot_i))] );
    bar (plot_binPercent_m1_1(plot_i,:))
    set(gca, 'XTickLabel', (TPs))
    ylabel ('Percentage of Bursts')
end



