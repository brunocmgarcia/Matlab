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

%% visualisieren
% load any fd
myfig=figure('Name',xxxx); % namen raussuchen aus fd
mylim=[-0.6 .6];
CM = jet(length(fd));
anzahlcombi=length(fd(1).cohspctrm));
for comb_i=1:anzahlcombi

    subplot(floor(anzahlcombi/2),ceil(anzahlcombi/2),comb_i)
    hold on
    for i=1:length(fd)
        plot(fd(i).freq, (fd(i).cohspctrm(1,:)), 'color', CM(i,:))
    end
    hold off
    ylim(mylim)
   
end
saveas(myfig,['/Volumes/A_guettlec/Auswertung/FINAL180416/' tier behav]);
