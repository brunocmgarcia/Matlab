%% s180423 von allen tieren die erste vorhande ephys aufnahme als .mat erstellen
 

%% 
clear all
close all
clc

TBSIfolder='F:/Primaerdaten/TBSI';
Zielordner='F:/Auswertung/firstrecordings';
tiere={'CG01'; 'CG02'; 'CG03'; 'CG04'; 'CG05'; 'CG06'; 'CG07'};


load('VAR_datakey.mat')
Ephysliste={datakey.key(:).ephys}';
MAT_nameliste={datakey.key(:).MAT_name}';
MAT_nameliste(cellfun('isempty', MAT_nameliste)) = {''};
 

for i=1:length(tiere)
    
    tier=tiere(i);
    tier=tier{:};
%     [index verwerfen] = find(~cellfun('isempty', strfind(Ephysliste, tier)));
%     indices(i)=index(1);
        
    [index verwerfen] = find(~cellfun('isempty', strfind(MAT_nameliste, tier)));    
    indices(i)=index(1);
    clearvars tier index verwerfen
end
clearvars i 



for i=1:length(indices)
  
        cd([TBSIfolder '/' cell2mat(Ephysliste(indices(i)))])
            
            FileList = dir(['*LFP*.nex']); % finde alle LFP dateien
            N = size(FileList,1);
            if N~=0
                mkdir('LFP');
                for k = 1:N
                    filename = FileList(k).name;
                    fprintf('%s ', k);
                    channelcell = (regexp(filename,'\d*','Match')); %da die channel mit zb 2 und nicht 02
                    channelnummer = str2num(channelcell{1,1});      %laufen muss neu geordnet werden
                    copyfile(filename, sprintf( '%s/%02d.nex', 'LFP', channelnummer)); %alternativ einfach copyfile statt movefile
                end
            else
                    fprintf('No Raw Data found\n');
            end

            cd('LFP')
                      
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
                              datr{schleife}=datp;
                             

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

                           
                cd ../
                rmdir('LFP','s');
                dateiname=[Zielordner '/firstrec_' num2str(indices(i)) '.mat'];
                
                
                save(dateiname, 'data')
                clearvars data
                
                
             end
  
       