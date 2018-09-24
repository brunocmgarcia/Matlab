clear all
cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/')
load('CG04_TP121_postLD180_ds_NOreref_m1.mat')

cfg=[];
cfg.artfctdef.zvalue.channel='30: M1';
cfg.artfctdef.zvalue.cutoff      = 4;
cfg.artfctdef.zvalue.trlpadding  = 0;
cfg.artfctdef.zvalue.fltpadding  = 0;
cfg.artfctdef.zvalue.artpadding  = 1;
cfg.artfctdef.zvalue.bpfilter    = 'yes';
cfg.artfctdef.zvalue.bpfreq      = [2 150];
cfg.artfctdef.zvalue.bpfiltord   = 3;
cfg.artfctdef.zvalue.bpfilttype  = 'but';
cfg.artfctdef.zvalue.hilbert     = 'yes';
cfg.artfctdef.zvalue.boxcar      = 0.2;
cfg.artfctdef.zvalue.interactive = 'yes';
[cfg, zvalue] = ft_artifact_zvalue(cfg, data);
cfg.artfctdef.reject='partial';
data_processed = ft_rejectartifact(cfg, data);
cfg=[];
cfg.length=2;
data_processed = ft_redefinetrial(cfg, data_processed);
cfg=[];
cfg.trl=data_processed.sampleinfo;
cfg.trl(:,3)=0;
cfg.artfctdef.threshold.range=400000;
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

my_foi=1:2:140;
cfg.foi          = my_foi;
 cfg.t_ftimwin    = 100./cfg.foi;  % 7 cycles per time window

% cfg.t_ftimwin(1:length(cfg.foi)) = 1;
% cfg.tapsmofrq(1:length(cfg.foi)) = 5;

figure

cfg.toi          = 'all';
TFRhann = ft_freqanalysis(cfg, data);
subplot(1,3,1)
imagesc(squeeze(TFRhann.powspctrm))
set(gca,'YDir','normal')
caxis([0 5e+7])

spektral=nanmedian(TFRhann.powspctrm,3);
subplot(1,3,3)
hold on
plot(my_foi,spektral)
xlim([0 max(my_foi)])
ylim([0 max(spektral)])
hold off

for artefakt_i=1:size(zvalue,1) 
    TFRhann.powspctrm(:,:,zvalue(artefakt_i,1):zvalue(artefakt_i,2))=nan;
end
for artefakt_i=1:size(threshold,1) 
    TFRhann.powspctrm(:,:,threshold(artefakt_i,1):threshold(artefakt_i,2))=nan;
end

subplot(1,3,2)
imagesc(squeeze(TFRhann.powspctrm))
set(gca,'YDir','normal')
caxis([0 5e+7])

spektral=nanmedian(TFRhann.powspctrm,3);
subplot(1,3,3)
hold on
plot(my_foi,spektral)
xlim([0 max(my_foi)])
ylim([0 (max(spektral)+(0.1*max(spektral)))])
hold off