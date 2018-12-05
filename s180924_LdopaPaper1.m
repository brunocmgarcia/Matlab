% %% nimm alle no reref, just m1, ds 500 LDOPA versuch dateien
% % dann einmal alles rausschmeissen mit zuviel bis 8Hz, als artefakt
% % korrektur. dann in 2s abschnitte teilen und alle abschnitte verwerfen die
% % eine zu hohe raw power diff haben. dann mit Fieldtrip MTMCONV = complex
% % wavelet convolution. 
% % zitat: The Hanning taper that we often use has the
% % practical advantage that the temporal spread is fully confined to the 
% % specified taper length (time window of interest), whereas with a Gaussian
% % taper (which is infinitely wide) the taper needs to be truncated. 
% % Following the construction of the taper, both the data and tapered wavelet 
% % are Fourier transformed and element-wisemultiplied in the frequency 
% % domain, after which te inverse Fourier transform is computed 
% % Die Convolution wird aber am zusammenh�ngenden Trial durchgef�hrt. 
% % Dann median(TFR) jeder frequency nehmen, wobei die 180min aufnahmen in
% % die relevanten Zeitabschnitte geteilt werden. .mats im order TFRsWithNan
% % abspeichern.

% % edit181205: windowing ändern und artfkt range 4.5e4


set(0, 'DefaultTextInterpreter', 'none')
clear all
close all

if ~ispc
    cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/')
else
    cd('F:/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/')

end

% ruhe10dateien

cd('Ruhe10')
ordner=dir('*.mat');
files={ordner.name}';
for file_i=1:length(files)
datei=files(file_i);
datei=datei{:}
load(datei)

cfg=[];
cfg.artfctdef.zvalue.channel='30: M1';
cfg.artfctdef.zvalue.cutoff      = 2.5;
cfg.artfctdef.zvalue.trlpadding  = 0;
cfg.artfctdef.zvalue.fltpadding  = 0;
cfg.artfctdef.zvalue.artpadding  = 1;
cfg.artfctdef.zvalue.bpfilter    = 'yes';
cfg.artfctdef.zvalue.bpfreq      = [.1 8];
cfg.artfctdef.zvalue.bpfiltord   = 3;
cfg.artfctdef.zvalue.bpfilttype  = 'but';
cfg.artfctdef.zvalue.hilbert     = 'yes';
cfg.artfctdef.zvalue.boxcar      = 0.2;
cfg.artfctdef.zvalue.interactive = 'no';
[cfg, zvalue] = ft_artifact_zvalue(cfg, data);
cfg.artfctdef.reject='partial';
data_processed = ft_rejectartifact(cfg, data);
cfg=[];
cfg.length=2;
data_processed = ft_redefinetrial(cfg, data_processed);
cfg=[];
cfg.trl=data_processed.sampleinfo;
cfg.trl(:,3)=0;
cfg.artfctdef.threshold.range=450000;
cfg.artfctdef.threshold.bpfilter  = 'no';
cfg.artfctdef.threshold.bpfreq    = [0.3 30]
cfg.artfctdef.threshold.bpfiltord = 4
[cfg, threshold] = ft_artifact_threshold(cfg, data_processed);
cfg.artfctdef.reject='complete';
data_processed = ft_rejectartifact(cfg, data_processed);


% 
% 
%  cfg              = [];
% cfg.output       = 'pow';
% cfg.channel      = 'all';
% cfg.pad='nextpow2';
% cfg.method       = 'tfr';
% 
% cfg.toi=[data.time{1,1}(1):data.time{1,1}(end)];
% my_foi=1:1:135;
% cfg.foi          = my_foi;
% cfg.width    = my_foi./4;
% cfg.width(cfg.width<7)=7;
% 
% TFRhann = ft_freqanalysis(cfg, data);



cfg              = [];
cfg.output       = 'pow';
cfg.channel      = 'all';
cfg.pad='nextpow2';
cfg.method       = 'mtmconvol';
cfg.taper        = 'hanning';

my_foi=1:1:140;
cfg.foi          = my_foi;
cfg.t_ftimwin    = (6./my_foi)
cfg.t_ftimwin(cfg.t_ftimwin<.15)=.15;  % 7 cycles per time window




 cfg.toi          = '50%'; % data.time{1,1}(1,1):1:data.time{1,1}(1,end)
%  cfg.t_ftimwin(1:length(cfg.foi)) = 2;
%   cfg.tapsmofrq(1:length(cfg.foi)) = 5;

 TFRhann = ft_freqanalysis(cfg, data); 
 



 
  
figure('Units','Normalized','Position',[0 0 1 1])

subplot(1,4,1)

imagesc(squeeze(TFRhann.powspctrm))
set(gca,'YDir','normal')
caxis([0 1e+8])

spektral=nanmedian(TFRhann.powspctrm,3);
subplot(1,4,3)
hold on
plot(my_foi,spektral)
xlim([min(my_foi) max(my_foi)])
ylim([0 2e8])
hold off

for z_i=1:(length(zvalue(:)))
    zvalue(z_i)=data.time{1,1}(zvalue(z_i));
end
for t_i=1:(length(threshold(:)))
    threshold(t_i)=data.time{1,1}(threshold(t_i));
end

for artefakt_i=1:size(zvalue,1) 
    [verwerfen von]=min(abs(zvalue(artefakt_i,1)-TFRhann.time(:)));
    [verwerfen bis]=min(abs(zvalue(artefakt_i,2)-TFRhann.time(:)));
    TFRhann.powspctrm(:,:,von:bis)=nan;
end
    clearvars von bis verwerfen artefakt_i
for artefakt_i=1:size(threshold,1) 
      
    [verwerfen von]=min(abs(threshold(artefakt_i,1)-TFRhann.time(:)));
    [verwerfen bis]=min(abs(threshold(artefakt_i,2)-TFRhann.time(:)));
    TFRhann.powspctrm(:,:,von:bis)=nan;
 
    
end

subplot(1,4,2)
imagesc(squeeze(TFRhann.powspctrm))
set(gca,'YDir','normal')
caxis([0 1e8])

spektral=nanmedian(TFRhann.powspctrm,3);
subplot(1,4,3)
hold on
plot(my_foi,spektral)
xlim([1 max(my_foi)])
ylim([0 2e8])
% ylim([0 (max(spektral)+(0.1*max(spektral)))])
hold off
spektral=nanmean(TFRhann.powspctrm,3);
subplot(1,4,3)
hold on
plot(my_foi,spektral)
xlim([0 max(my_foi)])
ylim([0 2e8])
% ylim([0 (max(spektral)+(0.1*max(spektral)))])
hold off
legend('median','art median','art mean','Location','best')
 for i=1:length(data_processed.trial)
        [pxx(i,:,:), welch_freq(:,1)]=pwelch(data_processed.trial{1,i}, hanning(floor(data_processed.fsample/4.5)), [], [2048], data_processed.fsample, 'power');  % mit hanning statt hamming
 end
 pxx=squeeze(pxx);
 subplot(1,4,4)
 plot(welch_freq,median(pxx,1)) 
 xlim([0 max(my_foi)])
 ylim([0 1e9])
 title(datei(1:end-4))

% % ylim([0 (max(spektral)+(0.1*max(spektral)))])
if ~exist([cd '/TFRsWithNaN'],'dir')
    mkdir('TFRsWithNaN');
end
cd TFRsWithNaN
    
    save([datei(1:end-4) 'TFRhann.mat'],'TFRhann', 'spektral')  
    saveas(gcf,[datei(1:end-4) '.png'])
    cd ..
    
 clearvars -except  file_i   files
 close all
end

% 180min dateien
clear all
close all

if ~ispc
    cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/')
else
    cd('F:/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/')

end
cd('180')
ordner=dir('*.mat');
files={ordner.name}';
for file_i=1:length(files)
datei=files(file_i);
datei=datei{:}
load(datei)

cfg=[];
cfg.artfctdef.zvalue.channel='30: M1';
cfg.artfctdef.zvalue.cutoff      = 2.5;
cfg.artfctdef.zvalue.trlpadding  = 0;
cfg.artfctdef.zvalue.fltpadding  = 0;
cfg.artfctdef.zvalue.artpadding  = 1;
cfg.artfctdef.zvalue.bpfilter    = 'yes';
cfg.artfctdef.zvalue.bpfreq      = [.1 8];
cfg.artfctdef.zvalue.bpfiltord   = 3;
cfg.artfctdef.zvalue.bpfilttype  = 'but';
cfg.artfctdef.zvalue.hilbert     = 'yes';
cfg.artfctdef.zvalue.boxcar      = 0.2;
cfg.artfctdef.zvalue.interactive = 'no';
[cfg, zvalue] = ft_artifact_zvalue(cfg, data);
cfg.artfctdef.reject='partial';
data_processed = ft_rejectartifact(cfg, data);
cfg=[];
cfg.length=2;
data_processed = ft_redefinetrial(cfg, data_processed);
cfg=[];
cfg.trl=data_processed.sampleinfo;
cfg.trl(:,3)=0;
cfg.artfctdef.threshold.range=450000;
cfg.artfctdef.threshold.bpfilter  = 'no';
cfg.artfctdef.threshold.bpfreq    = [0.3 30]
cfg.artfctdef.threshold.bpfiltord = 4
[cfg, threshold] = ft_artifact_threshold(cfg, data_processed);
cfg.artfctdef.reject='complete';
data_processed = ft_rejectartifact(cfg, data_processed);




cfg              = [];
cfg.output       = 'pow';
cfg.channel      = 'all';
cfg.pad='nextpow2';
cfg.method       = 'mtmconvol';
cfg.taper        = 'hanning';

my_foi=1:1:140;
cfg.foi          = my_foi;
cfg.t_ftimwin    = (6./my_foi)
cfg.t_ftimwin(cfg.t_ftimwin<.15)=.15;  % 7 cycles per time window




 cfg.toi          = '50%'; % data.time{1,1}(1,1):1:data.time{1,1}(1,end)
%  cfg.t_ftimwin(1:length(cfg.foi)) = 2;
%   cfg.tapsmofrq(1:length(cfg.foi)) = 5;

 TFRhann = ft_freqanalysis(cfg, data);
 
 
 
 
 
 
 
 
  
figure('Units','Normalized','Position',[0 0 1 1])


subplot(1,4,1)

imagesc(squeeze(TFRhann.powspctrm))
set(gca,'YDir','normal')
caxis([0 1e8])

spektral=nanmedian(TFRhann.powspctrm,3);
subplot(1,4,3)
hold on
plot(my_foi,spektral)
xlim([1 max(my_foi)])
ylim([0 2e8])
hold off

for z_i=1:(length(zvalue(:)))
    zvalue(z_i)=data.time{1,1}(zvalue(z_i));
end
for t_i=1:(length(threshold(:)))
    threshold(t_i)=data.time{1,1}(threshold(t_i));
end

for artefakt_i=1:size(zvalue,1) 
    [verwerfen von]=min(abs(zvalue(artefakt_i,1)-TFRhann.time(:)));
    [verwerfen bis]=min(abs(zvalue(artefakt_i,2)-TFRhann.time(:)));
    TFRhann.powspctrm(:,:,von:bis)=nan;
end
    clearvars von bis verwerfen artefakt_i
for artefakt_i=1:size(threshold,1) 
      
    [verwerfen von]=min(abs(threshold(artefakt_i,1)-TFRhann.time(:)));
    [verwerfen bis]=min(abs(threshold(artefakt_i,2)-TFRhann.time(:)));
    TFRhann.powspctrm(:,:,von:bis)=nan;
 
    
end

subplot(1,4,2)
imagesc(squeeze(TFRhann.powspctrm))
set(gca,'YDir','normal')
caxis([0 1e8])

spektral=nanmedian(TFRhann.powspctrm,3);
subplot(1,4,3)
hold on
plot(my_foi,spektral)
xlim([0 max(my_foi)])
ylim([0 2e+8])
% ylim([0 (max(spektral)+(0.1*max(spektral)))])
hold off
legend('median','art median','art mean','Location','best')
spektral=nanmean(TFRhann.powspctrm,3);
subplot(1,4,3)
hold on
plot(my_foi,spektral)
xlim([0 max(my_foi)])
ylim([0 2e+8])
% ylim([0 (max(spektral)+(0.1*max(spektral)))])
hold off
 for i=1:length(data_processed.trial)
        [pxx(i,:,:), welch_freq(:,1)]=pwelch(data_processed.trial{1,i}, hanning(floor(data_processed.fsample/4.5)), [], [2048], data_processed.fsample, 'power');  % mit hanning statt hamming
 end
 pxx=squeeze(pxx);
 subplot(1,4,4)
 plot(welch_freq,median(pxx,1)) 
 xlim([0 max(my_foi)])
 ylim([0 1e+9])
 title(datei(1:end-4))

% % ylim([0 (max(spektral)+(0.1*max(spektral)))])
if ~exist([cd '/TFRsWithNaN'],'dir')
    mkdir('TFRsWithNaN');
end
cd TFRsWithNaN
    
    save([datei(1:end-4) 'TFRhann.mat'],'TFRhann', 'spektral', 'my_foi', '-v7.3')  
    saveas(gcf,[datei(1:end-4) '.png'])
    cd ..
    
 clearvars -except  file_i   files
 close all
end

if ~ispc
    cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/')
else
    cd('F:/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/')
end

FileNameAndLocation=[mfilename('fullpath')];
newbackup=sprintf('%s_rundate_%s.m', mfilename, date);
currentfile=strcat(FileNameAndLocation, '.m');
copyfile(currentfile,newbackup);
