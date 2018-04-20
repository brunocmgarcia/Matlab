%%s180305_icoh


%clearvars -except fd0l fd0r fd31r fd31l
cd('F:\Auswertung\171121_nur_appenddata_und_rename_channels\trialappend\downsample')
clear all
%close all
Liste=dir('*CG04*Ruhe*');
Liste={Liste.name}';

for datei_i=1%:length(Liste)
    
    aktuelle_datei=Liste(datei_i);
    load(aktuelle_datei{:})

    
    cfg=[];
        cfg.demean='yes';
        cfg.reref='no';
        cfg.refchannel = 31;
        cfg.refmethod='avg';

        data=ft_preprocessing(cfg,data);
    
  
    
     cfg=[];
        cfg.length=0.9;
        data = ft_redefinetrial(cfg, data);


    cfg=[];
        cfg.output     = 'powandcsd';
        cfg.method     = 'mtmfft';
        cfg.taper      = 'dpss';
        cfg.pad        = 'nextpow2';
        cfg.foi        = 4:2:60;
        cfg.tapsmofrq  = 2;
        cfg.keeptrials = 'no';
        %cfg.channel    = {'01: STR 01';'02: STR 02';'16: SNR 01';'30: M1'}
        cfg.channelcmb = {'01: STR 01' '02: STR 02'; '01: STR 01' '16: SNR 01'; '01: STR 01' '30: M1'; '16: SNR 01' '30: M1'};
        freq           = ft_freqanalysis(cfg, data);

    cfg            = [];
        cfg.method     = 'coh';
        cfg.complex ='imag';
        cfg.channelcmb = {'01: STR 01' '02: STR 02'; '01: STR 01' '16: SNR 01'; '01: STR 01' '30: M1'; '16: SNR 01' '30: M1'; '16: SNR 01' '17: SNR 02'};
        fd             = ft_connectivityanalysis(cfg, freq);

%fd.cohspctrm  =abs(fd.cohspctrm);


% figure('NumberTitle', 'off', 'Name', (aktuelle_datei{:}));
% %plot(fd.freq,fd.cohspctrm);
% cfg           = [];
% cfg.parameter = 'cohspctrm';
% %cfg.parameter = 'wpli_debiasedspctrm';
% 
% %cfg.zlim      = [0 1];
% cfg.zlim      = [-.25 .25];
% cfg.xlim =[0 100]
% 
% 


%ft_connectivityplot(cfg, fd);
end

cd([cd '\figures_icoh_CG4ruhe'])
saveallopenfigures()
% 
% 
% plot(fd0r.freq(1,:),fd0r.cohspctrm(4,:))
% hold on
% plot(fd0l.freq(1,:),fd0l.cohspctrm(4,:))
% plot(fd31r.freq(1,:),fd31r.cohspctrm(4,:))
% plot(fd31l.freq(1,:),fd31l.cohspctrm(4,:))