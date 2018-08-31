%% s171117matfilesausLFPoderRAW erstelle data.mat files anhand von tier und TP angabe
% mein LP filter ist ein 6th order butterworth filter, zweimal durchlaufen,
 

%% 
clear all
close all
clc 

load('VAR_datakey.mat')
tiere=inputdlg('Welche Tiere sollen in die Analyse eingeschlossen werden?','input',1,{'CG01 CG02 CG03 CG04 CG05 CG06 CG07 CG08 CG09 CG10'},'on');
tiere=strsplit(tiere{:})';
%TPs=inputdlg('Welche Zeitpunkte sollen eingeschlossen werden?','input',1,{'0 1 2 3 4 6 8 11 14 17 21 25 29 31'},'on');
TPs=inputdlg('Welche Zeitpunkte sollen eingeschlossen werden?','input',1,{'101 103 104 107 109 110 112 113 116 119 121 122 200 300 400 500'},'on');
%paradigmata=inputdlg('Welche Paradigmen sollen eingeschlossen werden?','input',1,{'Ruhe LB10 LB20 LB30'},'on');
%paradigmata=strsplit(paradigmata{:})';


TPs=(str2num(TPs{:}))';
LFPoderRAW=inputdlg('LFP oder RAW daten?','input',1,{'LFP'},'on');
LFPoderRAW=LFPoderRAW{:};
resample_wunsch=inputdlg('Soll ein resampling durchgeführt werden? in Hz, sonst [ ]','input',1,{'2000'},'on');
resample_wunsch=(str2num(resample_wunsch{:}));
maxbyte4nex=inputdlg('Wieviel Byte darf ein .nex File auf diesem System maximal haben?','input',1,{'10000000'},'on');
maxbyte4nex=str2num(maxbyte4nex{:});
startordner=uigetdir('/Volumes/A_guettlec/Primaerdaten/TBSI', 'Bitte Startordner auswählen');
startordner=strrep(startordner,'\','/');
zielordner=uigetdir('/Volumes/A_guettlec/Auswertung', 'Bitte Zielordner auswählen');
zielordner=strrep(zielordner,'\','/');


Ephysliste={datakey.key(:).ephys}';

LP_wunsch=inputdlg('Soll ein Low-Pass Filter angewandt werden? in Hz, sonst [ ]','input',1,{'500'},'on');
LP_wunsch=str2num(LP_wunsch{:});

Reref_wunsch=inputdlg('Soll ein Reref ausgeführt werden? Channel oder [ ]','input',1,{'31: Cerebellum'},'on');
Reref_wunsch=Reref_wunsch{:};


all_requested_folders=[];
all_zugehoerige_TP=[];
all_zugehoerige_animals=[];
for i=1:length(tiere)
    
    tier=tiere(i);
    tier=tier{:};
    justdates=datakey.TP2dates.(tier);
    [verwerfen, index] = ismember(TPs,justdates(:,2));
    index( all(~index,2), : ) = [];
    
    
    ordner_gewuenscht=strcat(tier, '/', num2str(justdates(index,1)));
    zugehoerige_TP=justdates(index,2);
    
    for ii=1:length(index)
        zugehoerige_animals(ii,:)=tier;
    end
    all_requested_folders=char(all_requested_folders,ordner_gewuenscht);
    all_zugehoerige_TP=[all_zugehoerige_TP; zugehoerige_TP];
    all_zugehoerige_animals=char(all_zugehoerige_animals, zugehoerige_animals);
    clearvars justdates verwerfen index tier ordner_gewuenscht zugehoerige_TP ii zugehoerige_animals
end
clearvars  i 
all_requested_folders(1,:)=[];
all_zugehoerige_animals(1,:)=[];

for i=1:size(all_requested_folders,1)
    if str2num(all_requested_folders(i,3:4))<6
        startordner(i,:)='/Volumes/A_guettlec/Primaerdaten/TBSI';
    else
        startordner(i,:)='/Volumes/B_guettlec/Primaerdaten/TBSI';
    end
   
end

for i=1:size(all_requested_folders,1)
    ordner_i=[startordner(i,:) '/' all_requested_folders(i,:)]
    cd(ordner_i)
    ordner_i_einzelne_aufnahmen=(subdir)';
    ordner_i_einzelne_aufnahmen=strrep(ordner_i_einzelne_aufnahmen,'\','/');
    IndexC = strfind(ordner_i_einzelne_aufnahmen, 'optimap');
    Index = find(not(cellfun('isempty', IndexC)));
    ordner_i_einzelne_aufnahmen(Index,:)=[];
    clearvars Index IndexC;
    for einzelne_aufnahmen_i=1:length(ordner_i_einzelne_aufnahmen)
        cd(cell2mat(ordner_i_einzelne_aufnahmen(einzelne_aufnahmen_i)))
            
            FileList = dir(['*' LFPoderRAW '*.nex']); % finde alle LFP dateien
            N = size(FileList,1);
            if N~=0
                mkdir(LFPoderRAW);
                for k = 1:N
                    filename = FileList(k).name;
                    fprintf('%s ', k);
                    channelcell = (regexp(filename,'\d*','Match')); %da die channel mit zb 2 und nicht 02
                    channelnummer = str2num(channelcell{1,1});      %laufen muss neu geordnet werden
                    copyfile(filename, sprintf( '%s/%02d.nex', LFPoderRAW, channelnummer)); %alternativ einfach copyfile statt movefile
                end
            else
                    fprintf('No Raw Data found\n');
            end

            cd(LFPoderRAW)
            
            number_of_chops=chop_nex(maxbyte4nex);
            if number_of_chops>1
                for chopordner_i=1:number_of_chops
                        cd(['chopped_part_' sprintf('%02d',chopordner_i)])
                        channelofinterest=[1:31];
                        striatum=[1 3 5 7 9 27 29 17 21 25 31 15 23 13 11];
                        snr=[30 28 26 24 6 4 16 12 8 2 18 10 20 22];
                        cerebellum=14;
                        m1=19;
                        schleife=0;

                        for channel_i=[1 3 5 7 9 27 29 17 21 25 31 15 23 13 11 30 28 26 24 6 4 16 12 8 2 18 10 20 22 19 14] %% channel benennen.
                              schleife=schleife+1;
                              cfgp         = [];
                              cfgp.dataset = pwd;
                              cfgp.channel = channelofinterest(1,channel_i);
                              datp         = ft_preprocessing(cfgp);
                              if resample_wunsch
                                  cfgr            = [];
                                  cfgr.resamplefs = resample_wunsch; 
                                  datr{schleife}         = ft_resampledata(cfgr, datp);
                              else
                                  datr{schleife}=datp;
                              end

                              % umbennen
                              if ismember(channel_i, striatum) 
                                  position=striatum-channel_i;
                                  position=find(~position);
                                  datr{schleife}.label{1, 1}  =sprintf('%02d: STR %02d', schleife, position);
                              end
                              if ismember(channel_i, snr) 
                                  position=snr-channel_i;
                                  position=find(~position);
                                  datr{schleife}.label{1, 1} =sprintf('%02d: SNR %02d', schleife, position);
                              end
                              if channel_i==19
                                  datr{schleife}.label{1, 1} ='30: M1';
                              end
                              if channel_i==14
                                  datr{schleife}.label{1, 1} ='31: Cerebellum';
                              end

                              clear datp
                        end

                        cfg = [];
                        data = ft_appenddata(cfg, datr{:}); 
                        
                        if any(Reref_wunsch) + any(LP_wunsch)>0
                            cfg=[];
                            cfg.padding      = 0;
                            cfg.padtype      = 'data';
                            cfg.continuous   = 'yes';
                            cfg.demean       = 'yes';
                            if Reref_wunsch
                                cfg.reref='yes';
                                cfg.refchannel=Reref_wunsch;
                            else
                                cfg.reref='no';  
                            end
                            if LP_wunsch
                                cfg.lpfilter='yes';
                                cfg.lpfreq=LP_wunsch;
                            else
                                cfg.lpfilter='no';
                            end

                            data=ft_preprocessing(cfg, data);
                        end

                        cd ../
                        
                        dateiname=sprintf('%s/%s_TP%03d_Rec%02d_Chop%02dof%02d',zielordner, ...
                            all_zugehoerige_animals(i,:), all_zugehoerige_TP(i), einzelne_aufnahmen_i, ...
                            chopordner_i, number_of_chops);
                        save(dateiname, 'data', '-v7.3')
                        
                        
                        
                end
                cd ../
                rmdir(LFPoderRAW,'s');
            else
            
                channelofinterest=[1:31];
                striatum=[1 3 5 7 9 27 29 17 21 25 31 15 23 13 11];
                snr=[30 28 26 24 6 4 16 12 8 2 18 10 20 22];
                cerebellum=14;
                m1=19;
                schleife=0;

                        for channel_i=[1 3 5 7 9 27 29 17 21 25 31 15 23 13 11 30 28 26 24 6 4 16 12 8 2 18 10 20 22 19 14] %% channel benennen.
                              schleife=schleife+1;
                              cfgp         = [];
                              cfgp.dataset = pwd;
                              cfgp.channel = channelofinterest(1,channel_i);
                              datp         = ft_preprocessing(cfgp);
                              if resample_wunsch
                                  cfgr            = [];
                                  cfgr.resamplefs = resample_wunsch; 
                                  datr{schleife}         = ft_resampledata(cfgr, datp);
                              else
                                  datr{schleife}=datp;
                              end

                              % umbennen
                              if ismember(channel_i, striatum) 
                                  position=striatum-channel_i;
                                  position=find(~position);
                                  datr{schleife}.label{1, 1}  =sprintf('%02d: STR %02d', schleife, position);
                              end
                              if ismember(channel_i, snr) 
                                  position=snr-channel_i;
                                  position=find(~position);
                                  datr{schleife}.label{1, 1} =sprintf('%02d: SNR %02d', schleife, position);
                              end
                              if channel_i==19
                                  datr{schleife}.label{1, 1} ='30: M1';
                              end
                              if channel_i==14
                                  datr{schleife}.label{1, 1} ='31: Cerebellum';
                              end

                              clear datp
                        end

                cfg = [];
                data = ft_appenddata(cfg, datr{:}); 

                if any(Reref_wunsch) + any(LP_wunsch)>0
                    cfg=[];
                    cfg.padding      = 0;
                    cfg.padtype      = 'data';
                    cfg.continuous   = 'yes';
                    cfg.demean       = 'yes';
                    if Reref_wunsch
                        cfg.reref='yes';
                        cfg.refchannel=Reref_wunsch;
                    else
                        cfg.reref='no';  
                    end
                    if LP_wunsch
                        cfg.lpfilter='yes';
                        cfg.lpfreq=LP_wunsch;
                    else
                        cfg.lpfilter='no';
                    end

                    data=ft_preprocessing(cfg, data);
                end
                
                cd ../
                rmdir(LFPoderRAW,'s');
                dateiname=sprintf('%s/%s_TP%03d_Rec%02d',zielordner, ...
                    all_zugehoerige_animals(i,:), all_zugehoerige_TP(i), einzelne_aufnahmen_i);
                
                index_Ephysliste = find(ismember(string(Ephysliste), string(ordner_i_einzelne_aufnahmen{einzelne_aufnahmen_i}(end-30:end))));
                datakey.key(index_Ephysliste).MAT_name  =sprintf('%s_TP%03d_Rec%02d', ...
                    all_zugehoerige_animals(i,:), all_zugehoerige_TP(i), einzelne_aufnahmen_i);      
                        
                        
                
                save(dateiname, 'data', '-v7.3')
               
                
                
                
             end
        
    end   
end
        
       