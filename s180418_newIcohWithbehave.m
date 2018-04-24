%% s180418_newIcohWithbehave : new version of icoh.

cd('F:\Auswertung\FINAL180416\01_trialappend')
%cd('/Volumes/A_guettlec/Auswertung/FINAL180416/01_trialappend')
clear all
%close all
animals={'CG02';'CG04';'CG05';'CG06';'CG07'};
behavior={'Ruhe';'LB10';'LB20';}
load VAR_datakey
includedchannels={...
    datakey.key(176).includedchannels;...
    datakey.key(320).includedchannels;...
    datakey.key(368).includedchannels;datakey.key(488).includedchannels;...
    datakey.key(588).includedchannels};

for behavei=1:3
    for animali=1:5
        tier=animals(animali);
        tier=tier{:};
        behav=behavior(behavei);
        behav=behav{:};
        Liste=dir(['*' tier '*' behav '*']);
        Liste={Liste.name}';

        for datei_i=1:length(Liste)
            
            aktuelle_datei=Liste(datei_i);
            load(aktuelle_datei{:})
            channelcombinations=cell2mat(includedchannels(animali))';       
            channelcombinations=channelcombinations(1:end-1);
            channelcombinations=data.label(channelcombinations);
            channelcombinations=nchoosek(channelcombinations,2);
            cfg.channel=cell2mat(includedchannels(animali))';
            data=ft_selectdata(cfg,data);
             
            cfg=[];
                cfg.demean='yes';
                cfg.reref='yes';
                cfg.refchannel = '31: Cerebellum';
                cfg.refmethod='avg';

                data=ft_preprocessing(cfg,data);



             cfg=[];
                cfg.length=0.9;
                data = ft_redefinetrial(cfg, data);


            cfg=[];
                cfg.output = 'powandcsd';
                cfg.method = 'mtmfft';
                cfg.taper = 'hanning';
                cfg.pad = 'nextpow2';
                cfg.foi = 3:1:50;
                cfg.tapsmofrq = 4;
                cfg.keeptrials = 'no';
                cfg.channelcmb = channelcombinations;
                freq = ft_freqanalysis(cfg, data);
                
            
            
            cfg=[];
                cfg.method = 'coh';
                cfg.complex = 'imag';
                cfg.channelcmb = channelcombinations;
                fd(datei_i) = ft_connectivityanalysis(cfg, freq);


            clearvars -except Liste datei_i fd behavei animali animals behavior tier behav VAR_datakey includedchannels
        end
        

         save(['F:/Auswertung/FINAL180416/AllCombIcoh/' tier behav '.mat'],'fd')

        clearvars fd tier behav

    
    end
end

% %% visualisieren
% % load any fd
% clear all
% cd('F:\Auswertung\FINAL180416\AllCombIcoh')
% files=dir('*.mat');
% for file_i=1:length(files)
%     load(files(file_i).name)
%     mkdir([files(file_i).name(1:end-4) '_n1to1'])
%     cd(files(file_i).name(1:end-4))
%      % namen raussuchen aus fd
%     mylim=[-1 1];
%     CM = jet(length(fd));
%     anzahlcombi=length(fd(1).labelcmb);
%     for comb_i=1:anzahlcombi
% 
%         %=figure%subplot(ceil(sqrt(anzahlcombi)),ceil(sqrt(anzahlcombi)),comb_i);
%         myplot=figure('Name',files(file_i).name(1:end-4), 'Units', 'normalized', 'OuterPosition', [0 0 1 1]);
%         %axis tight
%         hold on
%         for i=1:length(fd)
%             plot(fd(i).freq, (fd(i).cohspctrm(comb_i,:)), 'color', CM(i,:))
%         end
%         hold off
%         title([fd(1).labelcmb{comb_i, 1}  ' zu ' fd(1).labelcmb{comb_i, 2}]);
%         ylim(mylim)
%         speichername=[fd(1).labelcmb{comb_i, 1}  ' zu ' fd(1).labelcmb{comb_i, 2} '.png']; 
%         speichername=strrep(speichername, ' ','_');
%         speichername=strrep(speichername, ':','');
%         saveas(myplot,speichername);
%         close(myplot)
%     end
%     cd ..
% end

