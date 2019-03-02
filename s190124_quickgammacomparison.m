%% s190124_quickgammacomparison

clear all
close all
clc


load('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/180/TFRsWithNaN/CG04_TP110_postLD180_ds_NOreref_m1TFRhannArtCorr.mat')
my_foi=TFRhann.freq;
    

    time=TFRhann.time';
    
    filteredTFR=squeeze(TFRhann.powspctrm);
    figure
    axis tight
    %plot((my_foi),    (log(squeeze(nanmean(filteredTFR(:,40001:104001),2)))-log(squeeze(nanmean(filteredTFR(140,40001:104001),2)))))
    %plot(my_foi, log(squeeze(nanmean(filteredTFR(:,40001:104001),2))),'r')
    semilogy(my_foi, (squeeze(nanmean(filteredTFR(:,64001:88001),2))),'r')

    
 
%xlim([60 140])
    
 clear all     
load('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/Ruhe10/TFRsWithNaN/CG04_TP110_praeLD_Ruhe10_ds_NOreref_m1_TFRhannArtCorr.mat')
  
 
    my_foi=TFRhann.freq;
    

    time=TFRhann.time';
    
    filteredTFR=squeeze(TFRhann.powspctrm);
    hold on
    
 %   plot((my_foi), (log(squeeze(nanmean(filteredTFR,2)))-log(squeeze(nanmean(filteredTFR(140,:),2)))))
    semilogy((my_foi), ((squeeze(nanmean(filteredTFR,2)))),'black')
%xlim([60 140])  
hold off


clear all
load('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper_praeDez/02a_NOreref_justM1_ds500/CG04_TP110_praeLD_LB20_ds_NOreref_m1.mat')

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
    
    
    
      my_foi=TFRhann.freq;
    

    time=TFRhann.time';
    
    filteredTFR=squeeze(TFRhann.powspctrm);
    hold on
    
%    plot(my_foi, (log(squeeze(nanmean(filteredTFR,2)))-log(squeeze(nanmean(filteredTFR(140,:),2)))))
     semilogy(my_foi, ((squeeze(nanmean(filteredTFR,2)))),'b')
xlim([10 (140)])
    ylim([0 3e8])
    
    hold off
    
    
   
    