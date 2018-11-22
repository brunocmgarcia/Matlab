%% s181019_LDopaIcoh3 : take old freq, variation coh

clear all
close all
clc
set(0, 'DefaultTextInterpreter', 'none')
cd('/Users/guettlec/Desktop/SNR')
zielfolder='/Users/guettlec/Desktop/SNR/COH/';
if 7~=exist(zielfolder,'dir')
    mkdir(zielfolder);
end

%dropboxfolder='/';
ordner=dir('*.mat');
files={ordner.name}';
clearvars ordner
fehler=0;
for file_i=1:length(files)
    file=files(file_i);
    dateiname=file{:};
    load(dateiname)
    clearvars fd
    channelcombinations=freq.labelcmb;
      try

        cfg=[];
            cfg.method = 'coh';
            cfg.complex='abs';
            cfg.removemean='no';
            cfg.keeptrials='yes';
            cfg.jackknife='yes';
            cfg.channelcmb = channelcombinations;
            roughtrialtimes=(freq.cfg.previous.trl(:,[1 2])/60000); 
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
                    plot(fd(1).freq, (fd(i).cohspctrm(comb_i,:)),'color', CM(i,:))
                end
            hold off
           % ylim(mylim)
        end

        fig_average=figure('Name',dateiname);
        hold on
            for i=1:length(fd)
                plot(fd(1).freq, (mean(fd(i).cohspctrm,1)), 'color', CM(i,:))
                jbfill(fd(1).freq,(mean(fd(i).cohspctrm,1)) + (mean(fd(i).cohspctrmsem,1)),...
                (mean(fd(i).cohspctrm,1)) - ...
                (mean(fd(i).cohspctrmsem,1)),CM(i,:),CM(i,:),0,0.2);
            end
        hold off

        colormap(CM)
        colorbar('Ticks', 0:.1:1,'TickLabels',{'0min','10min','30min','50min','70min','90min','110min','130min','150min','170min','180min'})
        xlim([80 120])
        xlabel('Frequency [Hz]')
        ylabel('COH ± jackknife SEM')
        title([dateiname(1:end-15) '_SNR_coh_average'])


         saveas(fig_allcomb,[zielfolder dateiname(1:end-15) '_SNR_coh_allcomb.png']);
         saveas(fig_average,[zielfolder dateiname(1:end-15) '_SNR_coh_average.png']);
%         saveas(fig_allcomb,[dropboxfolder dateiname(1:end-4) '_SNR_WPLI_allcomb.png']);
%         saveas(fig_average,[dropboxfolder dateiname(1:end-4) '_SNR_WPLI_average.png']);
%         save([zielfolder dateiname(1:end-4) 'freqAndWPLI.mat'], 'freq', 'fd', 'roughtrialtimes');
    catch
         fehler(file_i)=1;
     end
    clearvars -except file_i files zielfolder dropboxfolder fehler
    close all
end