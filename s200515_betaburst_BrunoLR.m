%% s200515_betaburst_BrunoLR

% Extracting the characteristics of beta bursts and exporting them as a
% single file for later statistical analysis.

%% 1) Load data file

clear all
cd('C:\Users\bruno\Documents\LR3\4bruno\4bruno')

% Liste=dir('*Ruhe*');
% Liste={Liste.name}';

load('CG04_TP00_Ruhe.mat');
data.trial = cellfun(@(x) x ./ 800, data.trial,'un',0);
%There is a gain (amplification) of 800 during the recording, so /800 goes it back to
%the actual level

%% 2) Select Frequency for max beta power (done in Christopher's script using pwelch - s190122_quickanddirtybetapower)

%bp_tp00 = [];
% In this other script the frequency for max beta power in TP21 was 23.44. 
% Rounding it to 24 and using a range of +/-5 we have a bp range of [19 29]

%% 3) Pre-processing (Choose BP range and Channel Manually)

cfg=[];
cfg.reref='yes';
cfg.refchannel=31; %rereferencing based on the ch31, subtracting everything from the cerebellum
cfg.demean='yes'; %baseline correction, to subtract the mean from everything so the data is all araound 0 
cfg.bpfilter='yes';
cfg.bpfreq=[19 29]; % based on visual result of s190122_quickanddirtybetapower for the TP00 and TP21 (+/- 5)
data=ft_preprocessing(cfg,data);
%after this you have the bandpass filtered data and rereferenced to the cerebellum. 

cfg=[];
cfg.channel=30; %ch 30 is the M1
onechannel=ft_selectdata(cfg,data);

%% 4) Apply hilbert transform to ch30 (or other of choice)

cfg=[];
cfg.hilbert='abs'; %you want the absolute value of the hilbert transform
onechannelhilb=ft_preprocessing(cfg,onechannel);

%% 5) Smoothing 

%smoothdata uses (input data, dimension to smooth, smoothing method, window length)
onechhilbsmoothed   = smoothdata(data.trial{1,1},2,'gaussian',(0.1*data.fsample)); 
allchhilbsmoothed   = smoothdata([data.trial{1,:}],2,'gaussian',(0.1*data.fsample));

%% 6) Z-transform with mean and std deviation from baseline (TP00)

mean_onetp00 = sum (onechhilbsmoothed) ./ length(onechhilbsmoothed); %mean one channel
mean_alltp00 = sum (allchhilbsmoothed) ./ length(allchhilbsmoothed); %mean all channels
sd_onetp00   = sqrt((sum((onechhilbsmoothed - mean_onetp00).^2)) ./ length(onechhilbsmoothed) ); %std deviation one channel
sd_alltp00   = sqrt((sum((allchhilbsmoothed - mean_alltp00).^2)) ./ length(allchhilbsmoothed) ); %std deviation all channels
oneztransf   = (onechhilbsmoothed - mean_onetp00) ./ sd_onetp00;
allztransf   = (allchhilbsmoothed - mean_alltp00) ./ sd_alltp00;

%% 7) Thresholding (Percentile 75) - one channel or all channels

%defines the 75 percentile as your interest, considering the first trial or
%alternatively all trials combined
%Perzentile75=prctile(onechannelhilb.trial{1,1},75);
Perzentile75=prctile([onechannelhilb.trial{1,:}],75);

%draw a line at percentile 75 for the cutoff 
% Perzentilenkurve=((ones(length(onechannelhilb.trial{1,1}),1))*Perzentile75)'; 
Perzentilenkurve=((ones(length([onechannelhilb.trial{1,:}]),1))*Perzentile75)'; 

%when the data is smaller than the percentiile set it as NAN, which cuts it off
% Perzentilenkurve(onechannelhilb.trial{1,1}<=Perzentilenkurve)=NaN;
Perzentilenkurve([onechannelhilb.trial{1,:}]<=Perzentilenkurve)=NaN; 

%% 8) Burst characteristics 

%label when each burst start, ends, and how long it last
ueberthreshold     =  diff( ~isnan([ NaN Perzentilenkurve NaN ]) );
NumBlockStart      =  find( ueberthreshold>0 )-0; %start, end and length of the burst
NumBlockEnd        =  find( ueberthreshold<0 )-1;
NumBlockLength     =  (NumBlockEnd - NumBlockStart + 1)/onechannelhilb.fsample;


% trapz gives an aprox. of the area under the curve (area under the burst curve but above the 75perc threshold)
% for i = 1 : length(NumBlockLength) 
%     AreaUnderCurve(i)=trapz(onechannelhilb.trial{1,1}(NumBlockStart(i):NumBlockEnd(i))) ... 
%         - trapz(Perzentilenkurve(NumBlockStart(i):NumBlockEnd(i)));
% end
onechannelhilbAlltrials = ([onechannelhilb.trial{1,:}]);
for i = 1 : length(NumBlockLength) 
    AreaUnderCurve(i)=trapz(onechannelhilbAlltrials(NumBlockStart(i):NumBlockEnd(i))) ... 
        - trapz(Perzentilenkurve(NumBlockStart(i):NumBlockEnd(i)));
end
%% 9) Plotting

hFig=figure('Name','Band Pass Filtered Data, abs(Hilbert) and Percentile Curve')
hAxes = gca;
meinslider=uicontrol('Style', 'slider', 'Min',1,'Max',max(data.time{1,1}),'Value',5, 'Position', [70 5 120 20], 'Callback', @(src,evt) s180213_hax( src, hAxes ) );
%meinslider=uicontrol('Style', 'slider', 'Min',1,'Max',max([data.time{1,:}]),'Value',5, 'Position', [70 5 120 20], 'Callback', @(src,evt) s180213_hax( src, hAxes ) );
set(hFig,'KeyPressFcn',@s180213_keyDownListener);

% plot(data.time{1,1},onechannel.trial{1,1},'color',[0,0,0]+.6);
plot([data.time{1,:}],[onechannel.trial{1,:}],'color',[0,0,0]+.6);
hold on
% plot(data.time{1,1},onechannelhilb.trial{1,1}, 'LineWidth', 2, 'color', 'r');
% plot(data.time{1,1},Perzentilenkurve, 'LineWidth',2, 'color', 'g')
plot([data.time{1,:}],[onechannelhilb.trial{1,:}], 'LineWidth', 2, 'color', 'r');
plot([data.time{1,:}],Perzentilenkurve, 'LineWidth',2, 'color', 'g')
hold off
xlim([0 5])  %adjust this if using all channels

%Tinkhauser2017 - The distribution of burst durations was considered by categorizing
%them into nine time windows of 100 ms starting from 100 ms to 900 ms in duration
figure('Name','Distribution of suprathreshold Period lengths')
histolength=histogram(NumBlockLength,[.1 .2 .3 .4 .5 .6 .7 .8 .9 inf], 'Normalization', 'probability');

figure('Name','Distribution of suprathreshold AUC(data) - AUC(percentile)')
histoarea=histogram(AreaUnderCurve, 'Normalization', 'probability');

%% 10) Export Bursts' Characteristics
