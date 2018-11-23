%% s181122_overnight_artdef_180

 clear all

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
cfg.demean='yes';
data=ft_preprocessing(cfg,data);

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
cfg.artfctdef.threshold.range=400000;
cfg.artfctdef.threshold.bpfilter  = 'no';
cfg.artfctdef.threshold.bpfreq    = [0.3 30]
cfg.artfctdef.threshold.bpfiltord = 4
[cfg, threshold] = ft_artifact_threshold(cfg, data_processed);
save(['F:\Auswertung\00_LDopa_Paper\02a_NOreref_justM1_ds500\180\artdefs\' datei],'threshold','zvalue');
clearvars -except files file_i 
end

% 
% binaryartefactchannel=data.time{1,1}*0;
% for artefakt_i=1:size(zvalue,1) 
%     binaryartefactchannel(zvalue(artefakt_i,1):zvalue(artefakt_i,2))=1;
% end
% for artefakt_i=1:size(threshold,1)       
%     binaryartefactchannel(threshold(artefakt_i,1):threshold(artefakt_i,2))=1;  
% end
% clearvars artefakt_i
% 
% % jetzt habe ich eine 0-1 timeline die mit den samples übereinstimmt.
% % 1=artefakt. Jetzt normales vorgehen zum burstfinden, erstmal mit
% % rect/smooth 
% 
% %1: bp filtern
% cfg=[];
% cfg.bpfilter='yes';
% cfg.bpfreq=[85 130];
% cfg.bpfiltord=5;
% data=ft_preprocessing(cfg,data);
% orig_data=data;
% %2: rectify
% cfg=[];
% cfg.rectify='yes';
% data=ft_preprocessing(cfg,data);
% 
% %3: smoothing & discard artfkt episodes CAVE GEHT NUR MIT SIGNAL PROCESSING
% %TOOLBOX
% datrectsmooth=smoothdata(data.trial{1,1},2,'gaussian',(0.1*data.fsample));
% datrectsmooth(binaryartefactchannel==1)=NaN;
% 
% % testeinschub, nachher entfernen!:
% %data.trial{1,1}=datrectsmooth;
% %call shortcut databrowser!
% %REMOVE!
% 
% %4: berechnung p75
% P75rs=prctile(datrectsmooth,75);
% P75rs=0.8e4;
% P75rs_curve=((ones(length(datrectsmooth),1)*P75rs)');
% P75rs_curve(P75rs_curve>=datrectsmooth)=NaN;
% rs_ueberthreshold           = diff( ~isnan([ NaN P75rs_curve NaN ]) );
% rs_NumBlockStart   = find( rs_ueberthreshold>0 )-0;
% rs_NumBlockEnd     = find( rs_ueberthreshold<0 )-1;
% rs_NumBlockLength  = (rs_NumBlockEnd - rs_NumBlockStart + 1)/data.fsample;
% 
% datrectsmoothsub=datrectsmooth-P75rs;
% datrectsmoothsub(datrectsmoothsub<=0)=0;
% 
% %5 visualisieren
% h=figure('Units', 'normalized', 'Position', [0 0 1 1]);
% 
% 
% s1=subplot(4,4,1:4);
% title('rote linie == 75ste percentile des blauen signals')
% axis tight
% hold on
% 
% plot(orig_data.trial{1,1},'Color', 'black')
% plot(1:length(orig_data.trial{1,1}),zeros(length(orig_data.trial{1,1}),1)', 'black')
% title('Rohdaten (gefiltert)')
% xlim([1 1500])
% ylim([-3e4 3e4])
% hold off
% 
% s2=subplot(4,4,5:8);
% axis tight
% hold on
% plot(orig_data.trial{1,1},'Color', 'black')
% plot(datrectsmooth, 'Color', 'b')
% plot(1:length(orig_data.trial{1,1}),zeros(length(orig_data.trial{1,1}),1)', 'black')
% plot(1:length(orig_data.trial{1,1}),P75rs_curve(1:length(orig_data.trial{1,1})), 'Color', 'r')
% title('rectified+smoothed')
% xlim([1 1500])
% ylim([-3e4 3e4])
% 
% hold off
% 
% 
% s3=subplot(4,4,9:12);
% hold on
% jbdatrectsmoothsub=datrectsmoothsub;
% jbdatrectsmoothsub(isnan(jbdatrectsmoothsub))=0;
% jbfill(1:length(jbdatrectsmoothsub),jbdatrectsmoothsub,zeros(length(jbdatrectsmoothsub),1)');
% title('rectified+smoothed')
% xlim([1 1500])
% ylim([0 2e4])
% 
% hold off
% 
% 
% s4=subplot(4,4,13:14);
%     hold on
%     histogram(rs_NumBlockLength, 0:0.01:0.4, 'Normalization', 'probability');
%  %   ksdensity(rs_NumBlockLength)
%     title('rectified & smooth')
%     xlim([0 0.4])
%     hold off
% s5=subplot(4,4,16);
% set(s5, 'visible', 'off');
% %end
% 
