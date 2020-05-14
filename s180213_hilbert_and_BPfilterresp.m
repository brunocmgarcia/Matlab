%% s180213_hilbert_and_BPfilterresp
% fieldtrip: 
%   standart bp: ft_preproc_bandpassfilter.m:
%    N=4
%    Fn=Fs/2
%    [B, A] = butter(N, [unteregrenze/Fn oberegrenze/Fn])
%   standart ist twopass, also:
%    filt = filtfilt(B, A, dat')';


clearvars % -except data
close all

load('CG04_TP00_Ruhe.mat');
% cfg.demean='yes'
% cfg.ylim=[-200 200];
% cfg.viewmode='vertical';
% cfg=ft_databrowser(cfg,onechannel);
data.trial=cellfun(@(x) x./800,data.trial,'un',0);
%BG there is a gain of 800 when you do the recording (amplification), and /800 goes it back to
%the regular level

%  cfg.resamplefs=2000;
%  data=ft_resampledata(cfg,data);



%this is a fieldtrip struct you are calling 
cfg=[];
cfg.reref='yes';
cfg.refchannel=31; %rereferencing based on the ch31, subtracting everything from the cerebellum
cfg.demean='yes'; %this is the baseline correction, to subtract the mean from everything so the data is all araound 0 
cfg.bpfilter='yes';
cfg.bpfreq=[13 30]; %[25 27]; Tinkhauser2017BetaOnOff used 5-40 if you use a bandpass too narow you get filter instability and you will no longer be able to use that filter
%cfg.plotfiltresp='no';
data=ft_preprocessing(cfg,data);
%after this you have the bandpass filtered data and rereferenced to the
%cerebellum. I need to figure out how I want to band pass the data (range I
%want)

cfg=[];
cfg.channel=30; %ch 30 is motor cortex
onechannel=ft_selectdata(cfg,data);

% cfg.demean='yes'
% cfg.ylim=[-200 200];
% cfg.viewmode='vertical';
% cfg=ft_databrowser(cfg,onechannelhilb);

%BG apply hilbert transform to the ch30
cfg=[];
cfg.hilbert='abs'; %you want the absolute of the hilbert
onechannelhilb=ft_preprocessing(cfg,onechannel);
% Perzentile75=prctile(onechannelhilb.trial{1,1},75);
Perzentile75=prctile([onechannelhilb.trial{1,:}],75);
%defines the 75 percentile as your interest, considering all trials 
%later you will cut the data here as say above it are your bursts

% BG 
%figure
%plot(onechannelhilb.trial{1,1}) If i use too broad bandpass the envelope
%will be as the sharp wave

%this block extracts individual bursts
% Perzentilenkurve=((ones(length(onechannelhilb.trial{1,1}),1))*Perzentile75)'; %this draws the line for the cutoff (figure this)
% Perzentilenkurve(onechannelhilb.trial{1,1}<=Perzentilenkurve)=NaN;
Perzentilenkurve=((ones(length([onechannelhilb.trial{1,:}]),1))*Perzentile75)'; %this draws the line for the cutoff (figure this)
Perzentilenkurve([onechannelhilb.trial{1,:}]<=Perzentilenkurve)=NaN; %when the data is smaller than the percentiile set it as NAN, and cut it off
ueberthreshold           = diff( ~isnan([ NaN Perzentilenkurve NaN ]) );
NumBlockStart   = find( ueberthreshold>0 )-0; %start, end and length of the burst
NumBlockEnd     = find( ueberthreshold<0 )-1;
NumBlockLength  = (NumBlockEnd - NumBlockStart + 1)/onechannelhilb.fsample;
%BG Do I have to exclude signals with lenght of less than 100ms (as
%Franziska did in her MSc?)

% trapz gives an aprox. of the area under the curve (area under the burst curve but above the 75perc threshold)
onechannelhilbAlltrials = ([onechannelhilb.trial{1,:}]);
for i=1:length(NumBlockLength); 
    AreaUnderCurve(i)=trapz(onechannelhilbAlltrials(NumBlockStart(i):NumBlockEnd(i))) ... 
        - trapz(Perzentilenkurve(NumBlockStart(i):NumBlockEnd(i)));
end


hFig=figure('Name','Band Pass Filtered Data, abs(Hilbert) and Percentile Curve')
hAxes = gca;
meinslider=uicontrol('Style', 'slider', 'Min',1,'Max',max([data.time{1,:}]),'Value',5, 'Position', [70 5 120 20], 'Callback', @(src,evt) s180213_hax( src, hAxes ) );
set(hFig,'KeyPressFcn',@s180213_keyDownListener);

plot([data.time{1,:}],[onechannel.trial{1,:}],'color',[0,0,0]+.6);
hold on
plot([data.time{1,:}],[onechannelhilb.trial{1,:}], 'LineWidth', 2, 'color', 'r');
plot([data.time{1,:}],Perzentilenkurve, 'LineWidth',2, 'color', 'g')
hold off
xlim([0 5]) %BG maybe I have to change this to [0 2]

figure('Name','Distribution of suprathreshold Period lengths')
histolength=histogram(NumBlockLength,'NumBins', 15, 'Normalization', 'probability');
%histolength=histogram(NumBlockLength, [.1 .2 .3 .4 .5 .6 .7 .8 .9 inf],'Normalization', 'probability');

figure('Name','Distribution of suprathreshold AUC(data) - AUC(percentile)')
histoarea=histogram(AreaUnderCurve, 'Normalization', 'probability');
% statt histogram jetzt mal kernel density function https://en.wikipedia.org/wiki/Kernel_density_estimation
% mit ansteigendem (increasing) bandwidth
% for i=0.01:0.01:0.2
%     figure
%     ksdensity(NumBlockLength,[0 :0.01:max(NumBlockLength)],'Support','positive', 'Bandwidth',i);
% end

