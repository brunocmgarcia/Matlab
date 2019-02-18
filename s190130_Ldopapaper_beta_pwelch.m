%% s190130_Ldopapaper_beta_pwelch 
clear all
clc
close all

cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/Ruhe10')

if exist(['beta_pwelch_' datestr(datetime('now'),  'yymmdd', 2000)]) ~= 7
    mkdir(['beta_pwelch_' datestr(datetime('now'),  'yymmdd', 2000)])
end

zielfolder=['beta_pwelch_' datestr(datetime('now'),  'yymmdd', 2000)];


    
Liste=dir('*.mat');
Liste={Liste.name}';
Liste=Liste([7 8 10 11 13 16 18 35 36 38 40 42 45 47 50 51 53 55 57 60 62 65 66 68 69 70 73 75 89 90 92 93 94 97 99]);

for datei_i=1:length(Liste)
    
    aktuelle_datei=Liste(datei_i);
    load(aktuelle_datei{:})
    
   
               
    
    cfg=[];
    cfg.demean='yes';
   
    
    data=ft_preprocessing(cfg,data);
    
    
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
        data = ft_rejectartifact(cfg, data);
        
   
        
   
     cfg=[];
        cfg.length=2; 
        data = ft_redefinetrial(cfg, data);  
        
       
        cfg=[];
        cfg.trl                            = data.sampleinfo;
        cfg.trl(:,3)                       = 0;
        cfg.artfctdef.threshold.range      = 450000;
        cfg.artfctdef.threshold.bpfilter   = 'no';
        cfg.artfctdef.threshold.bpfreq     = [0.3 30];
        cfg.artfctdef.threshold.bpfiltord  = 4;
        
        [cfg, threshold] = ft_artifact_threshold(cfg, data);
        
        cfg.artfctdef.reject='complete';
        data = ft_rejectartifact(cfg, data); 
       

         for i=1:length(data.trial) 
            welch(:,:,i)=(data.trial{1,i}(1,:)')/800;
          
            [pxx(:,:,i), welch_freq(:,1)]=(pwelch(welch(:,:,i), hanning(100), [], 2048, 500, 'psd'));  % 2048 mit hanning statt hamming
            

            
            
        end

        welch=pxx;
        clearvars pxx
        welch_average(datei_i,:)=mean(welch,3);
        

        clearvars -except zielfolder welch_average Liste datei_i welch_freq
end

cd(zielfolder)
save('baseline','welch_average','welch_freq','Liste')
cd ..


%% 180

clear all
clc
close all

cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/180')

if exist(['beta_pwelch_' datestr(datetime('now'),  'yymmdd', 2000)]) ~= 7
    mkdir(['beta_pwelch_' datestr(datetime('now'),  'yymmdd', 2000)])
end

zielfolder=['beta_pwelch_' datestr(datetime('now'),  'yymmdd', 2000)];


    
Liste=dir('*.mat');
Liste={Liste.name}';
Liste=Liste([10 11 13 14 16 17 18 32 33 35 37 39 41 42 44 45 47 49 51 53 54 56 57 59 60 61 63 64 75 76 78 79 80 82 83]);

for datei_i=1:length(Liste)
    
    aktuelle_datei=Liste(datei_i);
    load(aktuelle_datei{:})
    
    [~,von]=(min(abs(data.time{1,1}-(60*50))));
    [~,bis]=(min(abs(data.time{1,1}-(60*130))));
               
    cfg=[];
    cfg.begsample=von;
    cfg.endsample=bis;
    data=ft_redefinetrial(cfg,data);
    
   
    
    cfg=[];
    cfg.demean='yes';
    
    
    data=ft_preprocessing(cfg,data);
    
    
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
        data = ft_rejectartifact(cfg, data);
        
   
        
   
     cfg=[];
        cfg.length=2; 
        data = ft_redefinetrial(cfg, data);  
        
       
        cfg=[];
        cfg.trl                            = data.sampleinfo;
        cfg.trl(:,3)                       = 0;
        cfg.artfctdef.threshold.range      = 450000;
        cfg.artfctdef.threshold.bpfilter   = 'no';
        cfg.artfctdef.threshold.bpfreq     = [0.3 30];
        cfg.artfctdef.threshold.bpfiltord  = 4;
        
        [cfg, threshold] = ft_artifact_threshold(cfg, data);
        
        cfg.artfctdef.reject='complete';
        data = ft_rejectartifact(cfg, data); 
       

         for i=1:length(data.trial) 
            welch(:,:,i)=(data.trial{1,i}(1,:)')/800;
          
            [pxx(:,:,i), welch_freq(:,1)]=(pwelch(welch(:,:,i), hanning(100), [], 2048, 500, 'psd'));  % 2048 mit hanning statt hamming
            

            
            
        end

        welch=pxx;
        clearvars pxx
        welch_average(datei_i,:)=mean(welch,3);
        

        clearvars -except zielfolder welch_average Liste datei_i welch_freq
end

cd(zielfolder)
save('180','welch_average','welch_freq','Liste')

clear all
cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/180/beta_pwelch_190130')
load('180.mat')
freq180=welch_freq;
welch180=welch_average;
liste180=Liste;
cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/Ruhe10/beta_pwelch_190130')
load('baseline.mat')
freq10=welch_freq;
welch10=welch_average;
liste10=Liste;
clearvars -except freq180 liste180 welch180 freq10 welch10 liste10

for i=1:35
    figure
    hold on
    plot(freq10,welch10(i,:),'b')
    plot(freq180,welch180(i,:),'r')
    hold off
    xlim([10 70])
    
end

for i=1:7
 figure 
    hold on
    plot(freq10,mean(welch10(i:7:end,:),1),'b')
    plot(freq180,mean(welch180(i:7:end,:),1),'r')
    hold off
    xlim([4 70])
end



FileNameAndLocation=[mfilename('fullpath')];
    newbackup=sprintf('%s_rundate_%s.m', mfilename, date);
    currentfile=strcat(FileNameAndLocation, '.m');
    copyfile(currentfile,newbackup);
    
    
 
