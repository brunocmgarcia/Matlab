%% s171121 text information zu ephys automatisch. im anschluss datakey.mat händisch auffüllen


clear all
close all
clc

load('VAR_datakey.mat')
startordner = 'F:/Primaerdaten/TBSI';

for ephysordner_i=1:length(datakey.key)
    cd([startordner '/' datakey.key(ephysordner_i).ephys])
    try
        fileID = fopen('note.txt','r');
        A = fscanf(fileID,'%c');
        fclose(fileID);
        datakey.key(ephysordner_i).kommentar=A;
    catch
    end
    clearvars fileID A 
end


