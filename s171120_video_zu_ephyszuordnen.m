%% s171120 video information zu ephys automatisch. im anschluss datakey.mat händisch auffüllen

% 

%% 
clear all
close all
clc

load('VAR_datakey.mat')
tiere=strsplit('CG01 CG02 CG03 CG04 CG05 CG06 CG07')';

startordner = '/Volumes/A_guettlec/Primaerdaten/TBSI';




all_requested_folders=[];
all_zugehoerige_TP=[];
all_zugehoerige_animals=[];
for i=1:length(tiere)
    
    tier=tiere(i);
    tier=tier{:};
    justdates=datakey.TP2dates.(tier);
    ordner_gewuenscht=strcat(tier, '/', num2str(justdates(:,1)));
    zugehoerige_TP=justdates(:,2);
    
    for ii=1:length(justdates)
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


for i=1:length(all_requested_folders)
    ordner_i=[startordner '/' all_requested_folders(i,:)]
    cd(ordner_i)
    
    
    ephysaufnahmen=dir('*-*');
    
    
    cd('optimap')
    videoaufnahmen=dir('*-*');
    cd ../
    
    for mistschleife=1:length(ephysaufnahmen)
        ephysaufnahmen(mistschleife).name=strcat(all_requested_folders(i,:), '/', ephysaufnahmen(mistschleife).name);
    end
    for mistschleife=1:length(videoaufnahmen)
        videoaufnahmen(mistschleife).name=strcat(all_requested_folders(i,:),'/optimap/', videoaufnahmen(mistschleife).name);
    end
    
    lengthephysaufnahmen=length(ephysaufnahmen);
    ephys_video_mismatch=lengthephysaufnahmen-length(videoaufnahmen);
    if  ephys_video_mismatch==0
                if i==1 
                datakey.key=struct('ephys',{ephysaufnahmen(:).name});
                [datakey.key(:).video]=deal(videoaufnahmen(:).name);
                else
                [datakey.key(1+end:end+length(ephysaufnahmen)).ephys]=deal(ephysaufnahmen(:).name);
                [datakey.key(end-length(ephysaufnahmen)+1:end).video]=deal(videoaufnahmen(:).name);
                end
                
    else
                if i==1
                datakey.key=struct('ephys',{ephysaufnahmen(:).name});
                [datakey.key(:).video]=deal('unbekannt');
                else
                 [datakey.key(1+end:end+length(ephysaufnahmen)).ephys]=deal(ephysaufnahmen(:).name);
                [datakey.key(end-length(ephysaufnahmen)+1:end).video]=deal('unbekannt'); 
                end
                
    end
    
   
    
end


        