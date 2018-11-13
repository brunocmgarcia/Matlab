clear all
close all
clc

if ispc
    primaerdaten='F:\Primaerdaten\TBSI\';
    eigeneskripte='C:\Users\guettlec\Dropbox\eigeneskripte';
    zielfolder='C:\Users\guettlec\Dropbox\data\videoartefaktdef';
    datafolder='F:\Auswertung\171121_nur_appenddata_und_rename_channels';
else
    primaerdaten='/Volumes/B_guettlec/Primaerdaten/TBSI/';
    eigeneskripte='/Users/guettlec/Documents/MATLAB/Skripte';
    zielfolder='/Users/guettlec/Dropbox/data/videoartefaktdef';
    datafolder='/Users/guettlec/Desktop/180621_plainLFPs_CG8910_bis_TP17'; 
end
    
load VAR_datakey;
cd(datafolder)
files=dir('*.mat');

files={files.name}';

for currentfile_i=2:length(files)  % 1
    cd(datafolder)
    currentfile=char(files(currentfile_i));
    load(currentfile);
    currentfile=currentfile(1:end-4);
    currentdatakeyindex = find(strcmp({datakey.key.MAT_name}, currentfile)==1); 
    if datakey.key(currentdatakeyindex).video
        uiwait(msgbox({['data: ' currentfile] ['info: ' datakey.key(currentdatakeyindex).kommentar]...
            ['filenum: ' num2str(currentfile_i) ' of ' num2str(length(files)) ]},'info','modal'));

        cfg=[];
        videoartdef=manual_video_trialdef([primaerdaten datakey.key(currentdatakeyindex).video]);
        
        for i=1:numel(videoartdef) % suche die sample nummer
            [c index] = min(abs(data.time{1,1}-videoartdef(i)));
            videoartdef(i)=index;
        end
        clearvars i c index
        
        cfg.artfctdef.behavior.artifact=videoartdef;

        cfg.viewmode='vertical';
        cfg.blocksize=10;      
        cfg.ylim=[-140000  140000];
        cfg=ft_databrowser(cfg, data);
        videoartdef=cfg.artfctdef.behavior.artifact;
        
        kommentar=inputdlg('Kommentar zum Video?','input',1,{'no comment'},'on');
        kommentar=kommentar{:};
        datakey.key(currentdatakeyindex).video_kommentar=kommentar;
        if ispc
            cd('C:\Users\guettlec\Dropbox\eigeneskripte\00_variables')
            dateiname=[zielfolder '\' currentfile '_viddef.mat'];
        else
            
            cd('/Users/guettlec/Dropbox/data/00_variables')
            save 'VAR_datakey.mat' 'datakey'
            cd('/Users/guettlec/Dropbox/data/videoartefaktdef')
            dateiname=[zielfolder '/' currentfile '_viddef.mat'];
        end
        
        

                 
                 
                 cd(zielfolder)
        save(dateiname, 'videoartdef')
        clearvars -except eigeneskripte zielfolder datafolder datakey files currentfile_i primaerdaten
        uiwait(msgbox(['completed ' num2str(currentfile_i) ' of ' num2str(length(files)) ],'info','modal'));
        close all
    else 
        uiwait(msgbox({['data: ' currentfile] ['info: ' datakey.key(currentdatakeyindex).kommentar]...
            ['filenum: ' num2str(currentfile_i) ' of ' num2str(length(files)) ] ['NO VIDEO FOUND!!!']},'info','modal'));
    end
end
