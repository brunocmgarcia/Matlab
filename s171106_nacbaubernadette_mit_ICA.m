%% Bernadette STN PAC ClinNeurph2016
%  online LP 600hz 
% sampled 2400Hz
% bipolar montage between adjacent contacts --> check
% 4th order butterworth BS with harmonics to 600Hz of 50Hz +- 0.5Hz -->
% brauche ich nicht
% divide into 3.41s epochs, discard everything where peak to peak above
% 100µV. on everage 60 epochs remained (13-106)--> meins ansatz: autodetect
% 
% dann pWelch.m 8Hmming windows 50% overlap, average spectra across epochs
% discard values +-3hz around 50hz um notch filter effects zu entfernen
% powervalues below 50Hz were individually normalized by sum of whole power spectrum 
% values between 150 and 400 normalized by mean power between 400 and 500Hz
%
% kommentar zum welch vorgehen: bei meiner fs von 1000 und standartmäßig 8
% windows mit 50% overlap ergibt sich eine windowgrösse von 757,77
% 
% datapoints also gerunded 757 = 757ms in meinen daten. das würde eine
% minimal frequenz von 2.63Hz unter der doppelten wellenlänge pro window
% ergeben. Das scheint aktzeptabel da ja erst alles ab alpha 8Hz beobachtet
% werden soll. 8Hz würde also 3.02 mal reinpassen. Ich ändere aber auf
% Hanning window ab da es auf 0 an den seiten runtergeht
%     figure
%     plot(hanning(1000))
%     hold
%     plot(hamming(1000))
% wobei natürllcih nicht das standart fenster mit hanning(1000) sondern mit
% hanning(757) ersetzt werden muss 

%% now try to rebuild this
clear all
%close all
clc

%% datei, mri, montage und elec laden, kaputte channel ausschliessen, channel umbennen neue montage und elec erstellen
    % daten laden
        if ispc
            [filename, pathname]=uigetfile('F:\Auswertung\171121_nur_appenddata_und_rename_channels\CG*.mat','Bitte LFP .mat File aussuchen');
        else
            [filename, pathname]=uigetfile('/Volumes/A_guettlec/Auswertung/171121_nur_appenddata_und_rename_channels/CG*.mat','Bitte LFP .mat File aussuchen');
        end
        
        load(fullfile(pathname, filename));
        load('VAR_standard_montage_and_positions.mat'); % erzeuge alles aus den standarts neu
        load('VAR_mri_paxinos.mat'); % fertig bearbeitet in bez. auf coordsys etc
        load('VAR_lay.mat');
        try
            behaviordefname=[filename(1:end-4) '_viddef.mat'];
            load(behaviordefname);
        end
            
%     % erster überblick, zum aussuchen der kaputten channel
%         cfg=[];
%         try cfg.artfctdef.bahave.artifact = videoartdef; 
%         end;
%         cfg.viewmode='vertical';
%         cfg.blocksize=180;      
%         cfg.ylim=[-140000  140000];
%         cfg=ft_databrowser(cfg, data);
    
    % preprocess: demean, common average
        cfg=[];
        cfg.demean = 'yes';
        data=ft_preprocessing(cfg,data);
        
        cfg=[];
        try cfg.artfctdef.behave.artifact = videoartdef; 
        end;
        cfg.viewmode='vertical';
        cfg.blocksize=45;      
        cfg.ylim=[-100000  100000];
        cfg=ft_databrowser(cfg, data);

    % user input kaputte channel
        badchannels=inputdlg('Welche Channels müssen ausgeschlossen werden?');
        excludedchannelnumbers=nan;
    % jetzt erst reref und nicht vorher damit kaputte chanel besser erkannt werden koennen
        cfg=[];
        cfg.reref = 'yes' 
        cfg.refchannel = [1 16 30 31];

        data=ft_preprocessing(cfg,data);
    % eventuelle badchannels ausschliessen, und das standart montagen layout anpassen    
        if ~isempty(badchannels{1,1})
            excludedchannelnumbers=str2num(badchannels{:});
            badchannels=data.label(str2num(badchannels{:}));
            goodchannels=data.label(~ismember(data.label, badchannels));
            cfg=[]; 
            cfg.channel=goodchannels;
            data=ft_preprocessing(cfg,data); % erst aus den daten schmeissen

            for i=1:length(excludedchannelnumbers) % dann layout anpassung
                [a b]=find(montagen_layout==excludedchannelnumbers(i));
                if length(a)==1 % falls channel nur einmal am 'rand' auftaucht
                    montagen_layout(a,:)=[];
                else % falls er zweimal vorkommt.
                    montagen_layout(a(1),b(1))=0;
                    montagen_layout(a(2),b(2))=0;
                    montagen_layout(a(1),b(1))=montagen_layout(a(2),b(1));
                    montagen_layout(a(1),b(2))=montagen_layout(a(1),b(2));
                    montagen_layout(a(2),:)=[];
                end
                clearvars a b;
            end
        end
    
    % montage erstellen
                                     
        bipolar_montage.labelold=data.label;
            for i=1:length(montagen_layout)
                
                if montagen_layout(i,1)== 30
                     bipolar_montage.labelnew(i,1)={'M1'};
                elseif montagen_layout(i,1)== 31
                     bipolar_montage.labelnew(i,1)={'Cerebellum'};
                else 
                    
                     erster=strfind(data.label,sprintf('%02d:',montagen_layout(i,1)));
                     erster=find(~cellfun(@isempty,erster));
                     erster=data.label(erster,1);
                     
                     zweiter=strfind(data.label,sprintf('%02d:',montagen_layout(i,2)));
                     zweiter=find(~cellfun(@isempty,zweiter));
                     zweiter=data.label(zweiter,1);
                     
                     bipolar_montage.labelnew(i,1)={[erster{1,1}(5:end),' - ',zweiter{1,1}(5:end)]};
                end
            end
        bipolar_montage.tra=zeros(length(montagen_layout),length(data.label));
        for i=1:length(montagen_layout)
            bipolar_montage.tra(i,montagen_layout(i,1))=1;
            if ~isnan(montagen_layout(i,2))
                bipolar_montage.tra(i,montagen_layout(i,2))=-1;
            end
        end
        bipolar_montage.tra( :, ~any(bipolar_montage.tra,1) ) = [];  % entfernt leere coloumn

    % elektroden structure erstellen (bisher ohne die montage!)
        elec.label=data.label;
        elec.elecpos=elektrodenpositionen;
        if ~isnan(excludedchannelnumbers)
            elec.elecpos(excludedchannelnumbers,:)=[];
        end

%     %falls eine darstellung der reinen electrodenpos gewünscht ist
%          figure                 
%          ft_plot_sens(elec);   
%          grid on
%          view(190,5)

    %falls mri darstellung mit elektroden gewünscht ist
         cfg=[];    
         elec.elecpos(:,1)=elec.elecpos(:,1)*(-1);
         elec.elecpos(:,2)=elec.elecpos(:,2)*(-1);
         cfg.elec        = elec; % plot the previously identified electrodes on the mri
         cfg.magtype     = 'peak';
         cfg.method='mri';
         
         elec = ft_electrodeplacement(cfg, mri);
         elec.elecpos(:,1)=elec.elecpos(:,1)*(-1);
         elec.elecpos(:,2)=elec.elecpos(:,2)*(-1);
        
        


%% artifact removal
    cfg=[];
    % automatic z value artifactremoval
        try cfg.artfctdef.bahave.artifact = videoartdef; end;    
        cfg.artfctdef.zvalue.channel    = 'all';
        cfg.artfctdef.zvalue.cutoff     = 40;
        cfg.artfctdef.zvalue.trlpadding = 0;
        cfg.artfctdef.zvalue.artpadding = 3;
        cfg.artfctdef.zvalue.fltpadding = 0;
        cfg.artfctdef.zvalue.cumulative    = 'yes';
        cfg.artfctdef.zvalue.medianfilter  = 'yes';
        cfg.artfctdef.zvalue.medianfiltord = 9;
        cfg.artfctdef.zvalue.absdiff       = 'yes';
        cfg.artfctdef.zvalue.interactive = 'yes';

        [cfg, artifact_jump] = ft_artifact_zvalue(cfg, data);

    % manual artifactremoval
        cfg.viewmode='vertical';
        cfg.blocksize=180;
        cfg=ft_databrowser(cfg, data);
        %cfg.artfctdef.minaccepttim=3.41;
        cfg.artfctdef.reject='partial';
        
    % reject  
        data = ft_rejectartifact(cfg, data);  
        
        %% ICA mit elec def
    cfg = [];
    cfg.method = 'fastica'
    %cfg.channel=[1:15]; % nur innerhalb einer structure?
    cfg.numcomponent = 15;
    comp = ft_componentanalysis(cfg, data);

    
    cfg           = [];
    cfg.component = [1:15];       % specify the component(s) that should be plotted
    cfg.layout    = lay; % specify the layout file that should be used for plotting
    cfg.comment   = 'no';
    ft_topoplotIC(cfg, comp)

    cfg = [];
    %cfg.elec=elec;
    cfg.layout=lay;
    cfg.channel  = [1:15]; % components to be plotted
    cfg.viewmode = 'component';
    cfg.blocksize=30; 
    cfg=ft_databrowser(cfg, comp)

    cfg = [];
    ausschluss=inputdlg('Welche Components sollen ausgeschlossen werden?');
    cfg.component = str2num(ausschluss{:}); 
    clearvars ausschluss
    data = ft_rejectcomponent(cfg, comp, data)


        
% % bipolar montage, dann inspektion
%    data=ft_apply_montage(data,bipolar_montage)
%    cfg=[];
%    cfg.viewmode='vertical';
%    cfg.blocksize=60; % ein minütige ausschnitte
%    cfg=ft_databrowser(cfg, data);

%% cut in to segments     
    cfg=[];
    cfg.length=0.9;
    data = ft_redefinetrial(cfg, data);
    
%% welch
    for i=1:length(data.trial) 
        welch(:,:,i)=data.trial{1,i}';
        %[pxx(:,:,i), welch_freq(:,1)]=pmtm(welch(:,:,i),[],[],2000);
        %[pxx(:,:,i), welch_freq(:,1)]=pwelch(welch(:,:,i), [], [], [], data.fsample);  % mit hamming(auto) 
        [pxx(:,:,i), welch_freq(:,1)]=pwelch(welch(:,:,i), hanning(757), [], [], data.fsample);  % mit hanning statt hamming
    end
    
    welch=pxx;
    clearvars pxx
    welch_average=mean(welch,3);

%% normalize
    h=s171109_normalizegame(welch_average, welch_freq)
    uiwait(h)
    norm_gewuenscht_Hz=inputdlg('Normalisierung von 4-90 Hz ändern? ja: [lower upper] / nein: []');
    norm_gewuenscht_Hz=str2num(norm_gewuenscht_Hz{:});

    if size(norm_gewuenscht_Hz,2)==2
        norm_gewuenscht_Hz_unten=norm_gewuenscht_Hz(1,1);
        norm_gewuenscht_Hz_oben=norm_gewuenscht_Hz(1,2);
    else
        norm_gewuenscht_Hz_unten=4;
        norm_gewuenscht_Hz_oben=90;
    end

    [c norm_index_unten] = min(abs(welch_freq-norm_gewuenscht_Hz_unten));
    [c norm_index_oben] = min(abs(welch_freq-norm_gewuenscht_Hz_oben));
    clearvars c
    
    normfaktor=mean(welch_average(norm_index_unten:norm_index_oben,:));
    welch_average_norm= bsxfun(@rdivide, welch_average, normfaktor);
    figure 
        plot(welch_freq,pow2db(welch_average_norm))
        xlim([8 60])
        ylim([0 10])
figure 
        plot(welch_freq,welch_average_norm(:,29))
        xlim([8 60])
        ylim([0 10])



% 
% %% stuff
% welch_average_norm_beta=mean(welch_average_norm(13:30,:));
% scatter3(elec.elecpos([1:2:5 6:2:16 20:2:30],1),elec.elecpos([1:2:5 6:2:16 20:2:30],2),elec.elecpos([1:2:5 6:2:16 20:2:30],3),[], welch_average_norm_beta([1:2:5 6:2:16 20:2:30])','filled' )
% colormap(hot);
% colorbar;


