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

load('CG02_TP00_Ruhe.mat');
% cfg.demean='yes'
% cfg.ylim=[-200 200];
% cfg.viewmode='vertical';
% cfg=ft_databrowser(cfg,onechannel);
data.trial=cellfun(@(x) x./800,data.trial,'un',0);

%  cfg.resamplefs=2000;
%  data=ft_resampledata(cfg,data);




cfg=[];
cfg.reref='yes';
cfg.refchannel=31;
cfg.demean='yes';
cfg.bpfilter='yes';
cfg.bpfreq=[25 27];
cfg.plotfiltresp='no';
data=ft_preprocessing(cfg,data);


cfg=[];
cfg.channel=30;
onechannel=ft_selectdata(cfg,data);

% cfg.demean='yes'
% cfg.ylim=[-200 200];
% cfg.viewmode='vertical';
% cfg=ft_databrowser(cfg,onechannelhilb);


cfg=[];
cfg.hilbert='abs';
onechannelhilb=ft_preprocessing(cfg,onechannel);
Perzentile75=prctile(onechannelhilb.trial{1,1},75);


Perzentilenkurve=((ones(length(onechannelhilb.trial{1,1}),1))*Perzentile75)';
Perzentilenkurve(onechannelhilb.trial{1,1}<=Perzentilenkurve)=NaN;
ueberthreshold           = diff( ~isnan([ NaN Perzentilenkurve NaN ]) );
NumBlockStart   = find( ueberthreshold>0 )-0;
NumBlockEnd     = find( ueberthreshold<0 )-1;
NumBlockLength  = (NumBlockEnd - NumBlockStart + 1)/onechannelhilb.fsample;
    

for i=1:length(NumBlockLength);
    AreaUnderCurve(i)=trapz(onechannelhilb.trial{1,1}(NumBlockStart(i):NumBlockEnd(i))) ...
        - trapz(Perzentilenkurve(NumBlockStart(i):NumBlockEnd(i)));
end


hFig=figure('Name','Band Pass Filtered Data, abs(Hilbert) and Percentile Curve')
hAxes = gca;
meinslider=uicontrol('Style', 'slider', 'Min',1,'Max',max(data.time{1,1}),'Value',5, 'Position', [70 5 120 20], 'Callback', @(src,evt) s180213_hax( src, hAxes ) );
set(hFig,'KeyPressFcn',@s180213_keyDownListener);



plot(data.time{1,1},onechannel.trial{1,1},'color',[0,0,0]+.6);
hold on
plot(data.time{1,1},onechannelhilb.trial{1,1}, 'LineWidth', 2, 'color', 'r');
plot(data.time{1,1},Perzentilenkurve, 'LineWidth',2, 'color', 'g')
hold off
xlim([0 5])
figure('Name','Distribution of suprathreshold Period lengths')
histolength=histogram(NumBlockLength, [.1 .2 .3 .4 .5 .6 .7 .8 .9 inf],'Normalization', 'probability');
figure('Name','Distribution of suprathreshold AUC(data) - AUC(percentile)')
histoarea=histogram(AreaUnderCurve, 'Normalization', 'probability');
% statt histogram jetzt mal kernel density function https://en.wikipedia.org/wiki/Kernel_density_estimation
% mit ansteigendem bandwidth
for i=0.01:0.01:0.2
    figure
    ksdensity(NumBlockLength,[0 :0.01:max(NumBlockLength)],'Support','positive', 'Bandwidth',i);
end

