%% s190225_notsoquickgammacomparison

clear all
close all
clc


total.CG04.LD=load('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/180/TFRsWithNaN/CG04_TP110_postLD180_ds_NOreref_m1TFRhannArtCorr.mat');
total.CG04.LB=load('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper_praeDez/02a_NOreref_justM1_ds500/CG04_TP110_praeLD_LB20_ds_NOreref_m1.mat');
total.CG04.ruhe=load('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/Ruhe10/TFRsWithNaN/CG04_TP110_praeLD_Ruhe10_ds_NOreref_m1_TFRhannArtCorr.mat');

total.CG06.LD=load('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/180/TFRsWithNaN/CG06_TP110_postLD180_ds_NOreref_m1TFRhannArtCorr.mat');
total.CG06.LB=load('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper_praeDez/02a_NOreref_justM1_ds500/CG06_TP110_praeLD_LB20_ds_NOreref_m1.mat');
total.CG06.ruhe=load('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/Ruhe10/TFRsWithNaN/CG06_TP110_praeLD_Ruhe10_ds_NOreref_m1_TFRhannArtCorr.mat');

total.CG07.LD=load('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/180/TFRsWithNaN/CG07_TP110_postLD180_ds_NOreref_m1TFRhannArtCorr.mat');
total.CG07.LB=load('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper_praeDez/02a_NOreref_justM1_ds500/CG07_TP110_praeLD_LB20_ds_NOreref_m1.mat');
total.CG07.ruhe=load('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/Ruhe10/TFRsWithNaN/CG07_TP110_praeLD_Ruhe10_ds_NOreref_m1_TFRhannArtCorr.mat');

total.CG08.LD=load('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/180/TFRsWithNaN/CG08_TP110_postLD180_ds_NOreref_m1TFRhannArtCorr.mat');
total.CG08.LB=load('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper_praeDez/02a_NOreref_justM1_ds500/CG08_TP110_praeLD_LB20_ds_NOreref_m1.mat');
total.CG08.ruhe=load('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/Ruhe10/TFRsWithNaN/CG08_TP110_praeLD_Ruhe10_ds_NOreref_m1_TFRhannArtCorr.mat');

total.CG10.LD=load('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/180/TFRsWithNaN/CG10_TP110_postLD180_ds_NOreref_m1TFRhannArtCorr.mat');
total.CG10.LB=load('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper_praeDez/02a_NOreref_justM1_ds500/CG10_TP110_praeLD_LB20_ds_NOreref_m1.mat');
total.CG10.ruhe=load('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/Ruhe10/TFRsWithNaN/CG10_TP110_praeLD_Ruhe10_ds_NOreref_m1_TFRhannArtCorr.mat');

clearvars -except total

feldnamen=fieldnames(total);
figure; hold on
for i=1:length(feldnamen)
    tier=feldnamen{i,1}
    filteredTFR=squeeze(total.(tier).LD.TFRhann.powspctrm);
    
    if size(filteredTFR,2)<88001
        LDs(i,:)=(squeeze(nanmean(filteredTFR(:,64001:end),2)));
        semilogy(total.(tier).LD.TFRhann.freq  , LDs(i,:),'r--')
    else
        LDs(i,:)=(squeeze(nanmean(filteredTFR(:,64001:88001),2)));
        semilogy(total.(tier).LD.TFRhann.freq  , LDs(i,:),'r--')
    end
    clearvars filteredTFR
    
end
semilogy(total.(tier).LD.TFRhann.freq  , mean(LDs,1),'r-')

for i=1:length(feldnamen)
    tier=feldnamen{i,1}
    filteredTFR=squeeze(total.(tier).ruhe.TFRhann.powspctrm);
    
    
        ruhes(i,:)=(squeeze(nanmean(filteredTFR,2)));
        semilogy(total.(tier).ruhe.TFRhann.freq  , ruhes(i,:),'k--')
   
    
    clearvars filteredTFR
    
end
semilogy(total.(tier).ruhe.TFRhann.freq  , mean(ruhes,1),'k-')



for i=1:length(feldnamen)
    tier=feldnamen{i,1};
    
    
    
     data=total.(tier).LB.data;
     cfg=[];
        cfg.artfctdef.zvalue.channel        = '30: M1';
        cfg.artfctdef.zvalue.cutoff         = 2.5;
        cfg.artfctdef.zvalue.trlpadding     = 0;
        cfg.artfctdef.zvalue.fltpadding     = 0;
        cfg.artfctdef.zvalue.artpadding     = 1;
        cfg.artfctdef.zvalue.bpfilter       = 'yes';
        cfg.artfctdef.zvalue.bpfreq         = [.1 8];
        cfg.artfctdef.zvalue.bpfiltord      = 3;
        cfg.artfctdef.zvalue.bpfilttype     = 'but';
        cfg.artfctdef.zvalue.hilbert        = 'yes';
        cfg.artfctdef.zvalue.boxcar         = 0.2;
        cfg.artfctdef.zvalue.interactive    = 'no'; 
        
        [cfg, zvalue] = ft_artifact_zvalue(cfg, data);
        
        cfg.artfctdef.reject                = 'partial';
        data_processed = ft_rejectartifact(cfg, data);
        
    cfg=[];
        cfg.length  = 2;
        data_processed = ft_redefinetrial(cfg, data_processed);
        
    cfg=[];
        cfg.trl                            = data_processed.sampleinfo;
        cfg.trl(:,3)                       = 0;
        cfg.artfctdef.threshold.range      = 450000;
        cfg.artfctdef.threshold.bpfilter   = 'no';
        cfg.artfctdef.threshold.bpfreq     = [0.3 30];
        cfg.artfctdef.threshold.bpfiltord  = 4;
        
        [cfg, threshold] = ft_artifact_threshold(cfg, data_processed);
        
        cfg.artfctdef.reject='complete';
        data_processed = ft_rejectartifact(cfg, data_processed);

    cfg=[];
        cfg.output       = 'pow';
        cfg.channel      = 'all';
        cfg.pad          = 'nextpow2';
        cfg.method       = 'mtmconvol';
        cfg.taper        = 'hanning';
        my_foi           = 1:1:140;
        cfg.foi          = my_foi;
        cfg.t_ftimwin    = (6./my_foi);
        cfg.t_ftimwin(cfg.t_ftimwin<.15)=.15; 
        cfg.toi          = '50%';
        
        TFRhann = ft_freqanalysis(cfg, data); 

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
    clearvars von bis verwerfen artefakt_i
    
    
    
    
    
    filteredTFR=squeeze(TFRhann.powspctrm);
    
    
        LBs(i,:)=(squeeze(nanmean(filteredTFR,2)));
        semilogy(TFRhann.freq  , LBs(i,:),'b--')
   
    
    clearvars filteredTFR data
    
end
semilogy(total.(tier).ruhe.TFRhann.freq  , mean(LBs,1),'b-')
hold off

clearvars -except total LBs LDs ruhes
freq=total.CG04.ruhe.TFRhann.freq;

LDsAUC=trapz(LDs(:,70:140),2);
LBsAUC=trapz(LBs(:,70:140),2);
ruhesAUC=trapz(ruhes(:,70:140),2);
kombi=[(ruhesAUC) (LBsAUC) (LDsAUC)];
figure
plotSingleBarSEM(kombi)
ylim([0 3.5e9])

figure; 

axis tight
hold on
plot([70:140],mean(ruhes(:,70:140),1),'k-')
hold off
jbfill([70:140],mean(ruhes(:,70:140),1)+(std(ruhes(:,70:140),1))./sqrt(5),mean(ruhes(:,70:140),1)-(std(ruhes(:,70:140),1))./sqrt(5),[0 0 0],[0 0 0],1,.3);
hold on
plot([70:140],mean(LBs(:,70:140),1),'b-')
hold off
jbfill([70:140],mean(LBs(:,70:140),1)+(std(LBs(:,70:140),1))./sqrt(5),mean(LBs(:,70:140),1)-(std(LBs(:,70:140),1))./sqrt(5),[0 0 1],[0 0 1],1,.3);
hold on
plot([70:140],mean(LDs(:,70:140),1),'r-')
hold off
jbfill([70:140],mean(LDs(:,70:140),1)+(std(LDs(:,70:140),1))./sqrt(5),mean(LDs(:,70:140),1)-(std(LDs(:,70:140),1))./sqrt(5),[1 0 0],[1 0 0],1,.3);
xlim([70 140])

