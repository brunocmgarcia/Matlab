%% s180809_overnightTFR_Ldopa

clear all
cd('/Volumes/A_guettlec/Auswertung/180807_LDOPA')
load VAR_datakey


Matfinalliste={datakey.key(:).MAT_name_final}';
for i=1:length(Matfinalliste)
    try
            
            aktuellereintrag=Matfinalliste(i);
            aktuellereintrag=aktuellereintrag{:};
            if iscell(aktuellereintrag) 
                aktuellereintrag=aktuellereintrag{:};
            end
            if ~isempty(aktuellereintrag)


                if string(aktuellereintrag(end-4:end))==string('PO180')

                    %% hier!

                    load([datakey.key(i).MAT_name '.mat'])

                    cfg.demean='yes';
                    cfg.reref='no';
                    cfg.refchannel=31;
                    data=ft_preprocessing(cfg,data);    
                    dat=data.trial{1,1}';
                    clearvars data cfg
                    for ii=1:31
                        disp([char(aktuellereintrag) ' /// ' num2str(ii)])
                        [S(:,:,ii), F(:,ii), T(ii,:)] = spectrogram(dat(:,ii), hanning(4000), 2000, 1024, 1000);
                    end
                    cd TFR
                    save([aktuellereintrag '_TFR.mat'],'S','F', 'T')  % function form 
                    clearvars dat S F T
                    cd ..

                   %%VORBEI
                end
            end
            clearvars aktuellereintrag
    catch
        fehler.(['f' num2str(i)])=aktuellereintrag;
    end
end



