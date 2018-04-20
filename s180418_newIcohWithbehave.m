%% s180418_newIcohWithbehave : new version of icoh.

%cd('F:\Auswertung\FINAL180416\01_trialappend')
cd('/Volumes/A_guettlec/Auswertung/FINAL180416/01_trialappend')
clear all
%close all
animals={'CG02';'CG04';'CG05';'CG06';'CG07'};
behavior={'Ruhe';'LB10';'LB20';}

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


            cfg=[];
                cfg.demean='yes';
                cfg.reref='yes';
                cfg.refchannel = 31;
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
                cfg.channelcmb = {'01: STR 01' '16: SNR 01'; '01: STR 01' '30: M1'; '16: SNR 01' '30: M1'};
                freq = ft_freqanalysis(cfg, data);

            cfg=[];
                cfg.method = 'coh';
                cfg.complex = 'imag';
                cfg.channelcmb = {'01: STR 01' '16: SNR 01'; '01: STR 01' '30: M1'; '16: SNR 01' '30: M1'};
                fd(datei_i) = ft_connectivityanalysis(cfg, freq);


            clearvars -except Liste datei_i fd behavei animali animals behavior tier behav
        end

        myfig=figure('Name',[tier ':' behav]);
        mylim=[-0.6 .6];
        CM = jet(14);
        subplot(3,1,1)
        hold on
        for i=1:length(fd)
        plot(fd(i).freq, (fd(i).cohspctrm(1,:)), 'color', CM(i,:))
        end
        hold off

        ylim(mylim)
        subplot(3,1,2)
        hold on
        for i=1:length(fd)
        plot(fd(i).freq, (fd(i).cohspctrm(2,:)), 'color', CM(i,:))
        end
        hold off

        ylim(mylim)
        subplot(3,1,3)
        hold on
        for i=1:length(fd)
        plot(fd(i).freq, (fd(i).cohspctrm(3,:)), 'color', CM(i,:))
        end
        hold off

        ylim(mylim)
        save(['/Volumes/A_guettlec/Auswertung/FINAL180416/' tier behav '.mat'],'fd')
        saveas(myfig,['/Volumes/A_guettlec/Auswertung/FINAL180416/' tier behav]);
        clearvars fd tier behav
        close all
    end
end

