%% s181022_LDopaIcoh_reref : based on iCOH

clear all
close all
clc
set(0, 'DefaultTextInterpreter', 'none')
cd('F:\Auswertung\00_LDopa_Paper\01_AppendChannel_fs1000_LP450')
zielfolder_STR='F:\Auswertung\00_LDopa_Paper\03_connectivity\reref\STR';
zielfolder_SNR='F:\Auswertung\00_LDopa_Paper\03_connectivity\reref\SNR\SNR';
dropboxfolder_STR='C:\Users\guettlec\Dropbox\wpli_img\reref\STR';
dropboxfolder_SNR='C:\Users\guettlec\Dropbox\wpli_img\reref\SNR\SNR';
ordner=dir('*.mat');
files={ordner.name}';
clearvars ordner
fehler=0;
IndexC = strfind(files, '180');
min180aufnahmen = find(not(cellfun('isempty', IndexC)));
for variante=2
    if variante==1
 
        for file_i=min180aufnahmen' %% alle 180min Ldopaaufnahmen
            file=files(file_i);
            dateiname=file{:};
            load(dateiname)
           try
                cfg.channel=data.label([1:15 30 31]); 
                channelcombinations=cfg.channel(1:end-2);
                channelcombinations(1:end,2) = cfg.channel(end-1);    
                data=ft_selectdata(cfg,data);    

                %% artfkt

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
                    cfg.artfctdef.threshold.channel='30: M1';
                    cfg.artfctdef.threshold.bpfilter  = 'no';
                    cfg.artfctdef.threshold.bpfreq    = [0.3 30]
                    cfg.artfctdef.threshold.bpfiltord = 4
                    [cfg, threshold] = ft_artifact_threshold(cfg, data_processed);

                    cfg.artfctdef.reject='complete';
                    data = ft_rejectartifact(cfg, data_processed);

                clearvars data_processed
                
                %% reref
                cfg=[];
                cfg.refchannel='31: Cerebellum'
                cfg.reref='yes';
                data=ft_preprocessing(cfg,data);
                
                %% pow&csd -> wpli

                cfg=[];
                    cfg.output = 'powandcsd';
                    cfg.method = 'mtmfft';
                    cfg.taper = 'dpss';
                    cfg.pad = 'nextpow2';
                    my_foi=2:1:140;
                    cfg.foi          = my_foi;
                    cfg.t_ftimwin    = 7./cfg.foi;
                    cfg.tapsmofrq = 5;
                    cfg.keeptrials = 'yes';
                    cfg.toi          = '90%';
                    cfg.channelcmb = channelcombinations;
                    freq = ft_freqanalysis(cfg, data);

                cfg=[];
                    cfg.method = 'wpli_debiased';
                    cfg.removemean='no';
                    cfg.keeptrials='yes';
                    cfg.jackknife='yes';
                    cfg.channelcmb = channelcombinations;
                    roughtrialtimes=(freq.cfg.previous.previous.trl(:,[1 2])/60000); 
                    timebins=[0 10 30 50 70 90 110 130 150 170 180];
                    for abschnitt_i=1:10 
                        von = find(roughtrialtimes(:,1)>timebins(abschnitt_i),1, 'first');
                        bis = find(roughtrialtimes(:,2)>timebins(abschnitt_i+1),1, 'first');
                        if isempty(bis) & ~isempty(von) & roughtrialtimes(end,2)<timebins(abschnitt_i+1)
                            bis=size(roughtrialtimes,1);
                        end  
                        cfg.trials = [von:bis];
                        if ~isempty(cfg.trials)
                            fd(abschnitt_i) = ft_connectivityanalysis(cfg, freq);

                        end    
                        clearvars von bis cfg.trials
                    end

                %% visualisieren

                fig_allcomb=figure('Name',dateiname); % namen raussuchen aus fd
                mylim=[0 1];  
                CM = parula(10);
                colormap(CM)
                anzahlcombi=length(fd(1).labelcmb);

                for comb_i=1:anzahlcombi
                    subplot(ceil(sqrt(anzahlcombi)),ceil(sqrt(anzahlcombi)),comb_i)
                    title(fd(1).labelcmb(comb_i,:))
                    hold on
                        for i=1:length(fd)
                            plot(fd(1).freq, (fd(i).wpli_debiasedspctrm(comb_i,:)),'color', CM(i,:))
                        end
                    hold off
                    ylim(mylim)
                end

                fig_average=figure('Name',dateiname);
                hold on
                    for i=1:length(fd)
                        plot(fd(1).freq, (mean(fd(i).wpli_debiasedspctrm,1)), 'color', CM(i,:))
                        jbfill(fd(1).freq,(mean(fd(i).wpli_debiasedspctrm,1)) + (mean(fd(i).wpli_debiasedspctrmsem,1)),...
                        (mean(fd(i).wpli_debiasedspctrm,1)) - ...
                        (mean(fd(i).wpli_debiasedspctrmsem,1)),CM(i,:),CM(i,:),0,0.2);
                    end
                hold off

                colormap(CM)
                colorbar('Ticks', 0:.1:1,'TickLabels',{'0min','10min','30min','50min','70min','90min','110min','130min','150min','170min','180min'})
                xlim([80 120])
                xlabel('Frequency [Hz]')
                ylabel('debiased WPLI ± jackknife SEM')
                title(dateiname)


                saveas(fig_allcomb,[zielfolder_STR dateiname(1:end-4) '_rerefSTR_WPLI_allcomb.png']);
                saveas(fig_average,[zielfolder_STR dateiname(1:end-4) '_rerefSTR_WPLI_average.png']);
                saveas(fig_allcomb,[dropboxfolder_STR dateiname(1:end-4) '_rerefSTR_WPLI_allcomb.png']);
                saveas(fig_average,[dropboxfolder_STR dateiname(1:end-4) '_rerefSTR_WPLI_average.png']);
                save([zielfolder_STR dateiname(1:end-4) 'rereffreqAndWPLI.mat'], 'freq', 'fd', 'roughtrialtimes');
           catch
               fehler(file_i)=1;
           end
            clearvars -except file_i min180aufnahmen files zielfolder_STR zielfolder_SNR dropboxfolder_STR dropboxfolder_SNR fehler variante
            close all
        end
       
    end
    if variante==2
        
        
        for file_i=min180aufnahmen' %% alle 180min Ldopaaufnahmen
            file=files(file_i);
            dateiname=file{:};
            load(dateiname)
           try
                cfg.channel=data.label([16:29 30 31]); 
                channelcombinations=cfg.channel(1:end-2);
                channelcombinations(1:end,2) = cfg.channel(end-1);    
                data=ft_selectdata(cfg,data);    

                %% artfkt

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
                    cfg.artfctdef.threshold.channel='30: M1';
                    cfg.artfctdef.threshold.bpfilter  = 'no';
                    cfg.artfctdef.threshold.bpfreq    = [0.3 30]
                    cfg.artfctdef.threshold.bpfiltord = 4
                    [cfg, threshold] = ft_artifact_threshold(cfg, data_processed);

                    cfg.artfctdef.reject='complete';
                    data = ft_rejectartifact(cfg, data_processed);

                clearvars data_processed
                
                %% reref
                cfg=[];
                cfg.refchannel='31: Cerebellum'
                cfg.reref='yes';
                data=ft_preprocessing(cfg,data);
                
                %% pow&csd -> wpli

                cfg=[];
                    cfg.output = 'powandcsd';
                    cfg.method = 'mtmfft';
                    cfg.taper = 'dpss';
                    cfg.pad = 'nextpow2';
                    my_foi=2:1:140;
                    cfg.foi          = my_foi;
                    cfg.t_ftimwin    = 7./cfg.foi;
                    cfg.tapsmofrq = 5;
                    cfg.keeptrials = 'yes';
                    cfg.toi          = '90%';
                    cfg.channelcmb = channelcombinations;
                    freq = ft_freqanalysis(cfg, data);

                cfg=[];
                    cfg.method = 'wpli_debiased';
                    cfg.removemean='no';
                    cfg.keeptrials='yes';
                    cfg.jackknife='yes';
                    cfg.channelcmb = channelcombinations;
                    roughtrialtimes=(freq.cfg.previous.previous.trl(:,[1 2])/60000); 
                    timebins=[0 10 30 50 70 90 110 130 150 170 180];
                    for abschnitt_i=1:10 
                        von = find(roughtrialtimes(:,1)>timebins(abschnitt_i),1, 'first');
                        bis = find(roughtrialtimes(:,2)>timebins(abschnitt_i+1),1, 'first');
                        if isempty(bis) & ~isempty(von) & roughtrialtimes(end,2)<timebins(abschnitt_i+1)
                            bis=size(roughtrialtimes,1);
                        end  
                        cfg.trials = [von:bis];
                        if ~isempty(cfg.trials)
                            fd(abschnitt_i) = ft_connectivityanalysis(cfg, freq);

                        end    
                        clearvars von bis cfg.trials
                    end

                %% visualisieren

                fig_allcomb=figure('Name',dateiname); % namen raussuchen aus fd
                mylim=[0 1];  
                CM = parula(10);
                colormap(CM)
                anzahlcombi=length(fd(1).labelcmb);

                for comb_i=1:anzahlcombi
                    subplot(ceil(sqrt(anzahlcombi)),ceil(sqrt(anzahlcombi)),comb_i)
                    title(fd(1).labelcmb(comb_i,:))
                    hold on
                        for i=1:length(fd)
                            plot(fd(1).freq, (fd(i).wpli_debiasedspctrm(comb_i,:)),'color', CM(i,:))
                        end
                    hold off
                    ylim(mylim)
                end

                fig_average=figure('Name',dateiname);
                hold on
                    for i=1:length(fd)
                        plot(fd(1).freq, (mean(fd(i).wpli_debiasedspctrm,1)), 'color', CM(i,:))
                        jbfill(fd(1).freq,(mean(fd(i).wpli_debiasedspctrm,1)) + (mean(fd(i).wpli_debiasedspctrmsem,1)),...
                        (mean(fd(i).wpli_debiasedspctrm,1)) - ...
                        (mean(fd(i).wpli_debiasedspctrmsem,1)),CM(i,:),CM(i,:),0,0.2);
                    end
                hold off

                colormap(CM)
                colorbar('Ticks', 0:.1:1,'TickLabels',{'0min','10min','30min','50min','70min','90min','110min','130min','150min','170min','180min'})
                xlim([80 120])
                xlabel('Frequency [Hz]')
                ylabel('debiased WPLI ± jackknife SEM')
                title(dateiname)


                saveas(fig_allcomb,[zielfolder_SNR dateiname(1:end-4) '_rerefSNR_WPLI_allcomb.png']);
                saveas(fig_average,[zielfolder_SNR dateiname(1:end-4) '_rerefSNR_WPLI_average.png']);
                saveas(fig_allcomb,[dropboxfolder_SNR dateiname(1:end-4) '_rerefSNR_WPLI_allcomb.png']);
                saveas(fig_average,[dropboxfolder_SNR dateiname(1:end-4) '_rerefSNR_WPLI_average.png']);
                save([zielfolder_SNR dateiname(1:end-4) 'rereffreqAndWPLI.mat'], 'freq', 'fd', 'roughtrialtimes');
           catch
               fehler(file_i)=1;
           end
            clearvars -except file_i files min180aufnahmen zielfolder_STR zielfolder_SNR dropboxfolder_STR dropboxfolder_SNR fehler variante
            close all
        end
        
    end
end