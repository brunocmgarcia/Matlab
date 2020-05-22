%% s200515_betaburst_BrunoLR

% Extracting the characteristics of beta bursts and exporting them as a
% single struct file for later statistical analysis.
%
%

%% 1) Load data file (Manually write CG, TP and LB - First one must be TP00)

clear all
cd('C:\Users\bruno\Documents\LR3\4bruno\4bruno')

% Liste=dir('*Ruhe*');
% Liste={Liste.name}';

CG = 'CG04'; %Input animal number
TP = 'TP21'; %Input date relative to 6OHDA injection
LB = 'Ruhe'; %Input condition ('Ruhe', LB10, LB20,...)
load([CG  '_'  TP  '_'  LB  '.mat']);
data.trial = cellfun(@(x) x ./ 800, data.trial,'un',0);
%There is a gain (amplification) of 800 during the recording, so /800 goes it back to
%the actual level

%% 2) Select Frequency for max beta power (done in Christopher's script using pwelch - s190122_quickanddirtybetapower)

%bp_tp00 = [];
% In this other script the frequency for max beta power in TP21 was 29. 
% using a range of +/-5 we have a bp range of [24 34]

%% 3) Pre-processing (Choose BP range and Channel Manually)

cfg=[];
cfg.reref='yes';
cfg.refchannel=31; %rereferencing based on the ch31, subtracting everything from the cerebellum
cfg.demean='yes'; %baseline correction, to subtract the mean from everything so the data is all araound 0 
cfg.bpfilter='yes';
cfg.bpfreq=[24 34]; % based on visual result of s190122_quickanddirtybetapower for the TP00 and TP21 (+/- 5)
data=ft_preprocessing(cfg,data);
%after this you have the bandpass filtered data and rereferenced to the cerebellum. 

cfg=[];
cfg.channel=30; %ch 30 is the M1
onechannel=ft_selectdata(cfg,data);

%% 4) Apply hilbert transform 

cfg=[];
cfg.hilbert='abs'; %you want the absolute value of the hilbert transform
onechannelhilb=ft_preprocessing(cfg,onechannel);

%% 5) Z-transform with mean and std deviation from baseline (TP00)
%If the data being analysed is the baseline (TP00) it will calculate the
%mean and sd for the z score in the other recordings. If it is one of the
%other time points it will load the TP00 mean and sd and use them to
%calculate the z score

if strcmp(TP, 'TP00')
    zscore_mean    = sum ([onechannelhilb.trial{1,:}]) ./ length([onechannelhilb.trial{1,:}]); %mean all trials
    zscore_sd      = sqrt((sum(([onechannelhilb.trial{1,:}] - zscore_mean).^2)) ./ length([onechannelhilb.trial{1,:}]) ); %std deviation all trials
%       zscore_s      = sum([onechannelhilb.trial{1,:}]);
%       zscore_ss     = sum([onechannelhilb.trial{1,:}].^2);
%       zscore_mean   = zscore_s ./ length([onechannelhilb.trial{1,:}]);
%       zscore_sd     = sqrt((zscore_ss - (zscore_s.^2)./length([onechannelhilb.trial{1,:}])) ./ (length([onechannelhilb.trial{1,:}])-1));
    onechannelhilbztransf   = ([onechannelhilb.trial{1,:}] - zscore_mean) ./ zscore_sd;

else
    load (['C:\Users\bruno\Documents\LR3\4bruno\4bruno' filesep CG  '_TP00_'  LB '_' 'burst' filesep CG  '_TP00_'  LB  '_betaburst.mat']);
    onechannelhilbztransf   = ([onechannelhilb.trial{1,:}] - betaburst.zscore_mean) ./ betaburst.zscore_sd;
end

%% 6) Thresholding (Percentile 75) - one trial or all trials
if strcmp(TP, 'TP00')
    %defines the 75 percentile as your interest, considering the first trial or alternatively all trials combined
    %Perzentile75=prctile(onechannelhilb.trial{1,1},75);
    Perzentile75=prctile([onechannelhilb.trial{1,:}],75);
    
    %draw a line at percentile 75 for the cutoff
    Perzentilenkurve =((ones(length([onechannelhilb.trial{1,:}]),1))*Perzentile75)';
    
    %when the data is smaller than the percentiile set it as NAN, which cuts it off
    Perzentilenkurve([onechannelhilb.trial{1,:}]<=Perzentilenkurve)=NaN;
else
    Perzentile75 = betaburst.Perzentile75;
%     Perzentilenkurve =((ones(length(onechannelhilb.trial),1))*Perzentile75)';
%     Perzentilenkurve(onechannelhilb.trial<=Perzentilenkurve)=NaN;
    Perzentilenkurve =((ones(length([onechannelhilb.trial{1,:}]),1))*Perzentile75)';
    Perzentilenkurve([onechannelhilb.trial{1,:}]<=Perzentilenkurve)=NaN;
end
    
%% 7) Burst characteristics 

%label when each burst start, ends, and how long it last
ueberthreshold     =  diff( ~isnan([ NaN Perzentilenkurve NaN ]) );
NumBlockStart      =  find( ueberthreshold>0 )-0; %start, end and length of the burst
NumBlockEnd        =  find( ueberthreshold<0 )-1;
NumBlockLength     =  (NumBlockEnd - NumBlockStart + 1)/onechannelhilb.fsample;


% trapz gives an aprox. of the area under the curve (area under the burst curve but above the 75perc threshold)
if strcmp(TP, 'TP00')
    onechannelhilbAlltrials = ([onechannelhilb.trial{1,:}]);
else
%     onechannelhilbAlltrials = onechannelhilb.trial;
    onechannelhilbAlltrials = ([onechannelhilb.trial{1,:}]);
end

for i = 1 : length(NumBlockLength) 
    AreaUnderCurve(i)=trapz(onechannelhilbAlltrials(NumBlockStart(i):NumBlockEnd(i))) ... 
        - trapz(Perzentilenkurve(NumBlockStart(i):NumBlockEnd(i)));
end
%% 8) Plotting

%Plot bp curve, enveloped hilbert curve, and 75th threshold for all trials
hFig=figure('Name','Band Pass Filtered Data, abs(Hilbert) and Percentile Curve');
hAxes = gca;

meinslider=uicontrol('Style', 'slider', 'Min',1,'Max',max([data.time{1,:}]),'Value',5, 'Position', ...
    [70 5 120 20], 'Callback', @(src,evt) s180213_hax( src, hAxes ) );
set(hFig,'KeyPressFcn',@s180213_keyDownListener);

plot([data.time{1,:}],[onechannel.trial{1,:}],'color',[0,0,0]+.6);

hold on
if strcmp(TP, 'TP00')
    plot([data.time{1,:}],[onechannelhilb.trial{1,:}], 'LineWidth', 2, 'color', 'r');
else
%     plot([data.time{1,:}],onechannelhilb.trial, 'LineWidth', 2, 'color', 'r');
    plot([data.time{1,:}],[onechannelhilb.trial{1,:}], 'LineWidth', 2, 'color', 'r');
end
plot([data.time{1,:}],Perzentilenkurve, 'LineWidth',2, 'color', 'g')
hold off
xlim([20 30])  %adjust this if using all trials
title ('Band Pass Filtered Data, abs(Hilbert) and Percentile Curve')

%Plot distribution of burst duration
%Tinkhauser2017 - The distribution of burst durations was considered by categorizing
%them into nine time windows of 100 ms starting from 100 ms to 900 ms in duration
burst_length = figure('Name','Distribution of suprathreshold Period lengths');
histolength=histogram(NumBlockLength,[.1 .2 .3 .4 .5 .6 .7 .8 .9 inf], 'Normalization', 'probability');
xlabel ('Block Length (s)')
title ('Distribution of suprathreshold Period lengths')

%Plot distribution of burst AUC (~amplitude)
burst_AUC = figure('Name','Distribution of suprathreshold AUC(data) - AUC(percentile)');
histoarea=histogram(AreaUnderCurve, 'Normalization', 'probability');
xlabel ('AUC (a.u.)')
title ('Distribution of suprathreshold AUC(data) - AUC(percentile)')

%% 9) Export Bursts' Characteristics
% One mat file per region (STR, SNR, M1) with burst characteristics: CG004_TP00_bburst_str,bburst_snr bburst_m1 
% (total length of recording (length(onechannel.trial), .NumBlockStart, .NumBlockEnd, .NumBlockLength, .AreaUnderCurve, 
% .Perzentile75)

clear betaburst
betaburst = struct ('NumBlockStart', NumBlockStart, 'NumBlockEnd',NumBlockEnd, 'NumBlockLength', NumBlockLength,...
    'Perzentile75',Perzentile75, 'Perzentilenkurve', Perzentilenkurve, 'onechannelhilb', onechannelhilb,...
    'AreaUnderCurve', AreaUnderCurve);

if strcmp(TP, 'TP00')
    betaburst.zscore_mean = zscore_mean;
    betaburst.zscore_sd = zscore_sd;
    betaburst.onechannelhilbztransf = onechannelhilbztransf;
else
    betaburst.onechannelhilbztransf = onechannelhilbztransf;
end

mkdir ([ CG  '_'  TP  '_'  LB '_' 'burst'])
export_path = (['C:\Users\bruno\Documents\LR3\4bruno\4bruno' filesep CG  '_'  TP  '_'  LB '_' 'burst']);
savefig (hFig, [export_path filesep CG  '_'  TP  '_'  LB  '_bbhilbthresh'])
saveas (burst_length,[export_path filesep CG  '_'  TP  '_'  LB  '_bbLength.png'])
saveas (burst_AUC, [export_path filesep CG  '_'  TP  '_'  LB  '_bbAUC.png'])
save([export_path filesep CG  '_'  TP  '_'  LB  '_betaburst.mat'], 'betaburst');

close all