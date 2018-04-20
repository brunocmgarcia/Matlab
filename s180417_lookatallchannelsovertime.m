%% find broken channels over time 

clear all
close all
clc

if ispc
    primaerdaten='F:\Primaerdaten\TBSI\';
    eigeneskripte='C:\Users\guettlec\Dropbox\eigeneskripte';
    zielfolder='F:\Auswertung\FINAL180416';
    datafolder='F:\Auswertung\FINAL180416\02_downsampledTo500Hz';
else
    primaerdaten='/Volumes/A_guettlec/Primaerdaten/TBSI/';
    eigeneskripte='/Users/guettlec/Dropbox/eigeneskripte';
    zielfolder='/Users/guettlec/Dropbox/data/videoartefaktdef';
    datafolder='/Volumes/A_guettlec/Auswertung/FINAL180416/02_downsampledTo500Hz'; 
end
    
load VAR_datakey;
animals={'CG01.*';'CG02.*';'CG03.*';'CG04.*';'CG05.*';'CG06.*';'CG07.*'};

for animal_i=2%4:length(animals);
    finalmonster=zeros(31,1);
    recordings=(regexp({datakey.key.ephys}, animals(animal_i), 'match')');
    recordings=recordings(~cellfun(@isempty, recordings));


    for recording_i=1:8%length(recordings)  
        path=strcat(primaerdaten, recordings{recording_i})
        cd(path{:})
        LFPlist=dir('*LFP*');
          for k = 1:length(LFPlist)
              try
                  [data freq]=ownreadnex(LFPlist(k).name);
                  data=data-(mean(data));
              catch
                  data=zeros(2000,1)';
              end
              try 
                  recordingbuildup(k,:)=data(1:2000);
              catch
                  recordingbuildup(k,:)=data(1:end);
              end
                  
              clearvars data freq
          end
          recordingbuildup=recordingbuildup([1 3 5 7 9 27 29 17 21 25 31 15 23 13 11 30 28 26 24 6 4 16 12 8 2 18 10 20 22 19 14],:);
          finalmonster=[finalmonster recordingbuildup];
          clearvars recordingbuildup
    end
    %save([zielfolder '\' 'CG0' num2str(animal_i) '_ChannelsOverTime.mat'],'finalmonster')
    %clearvars finalmonster
end


MonPos = get(0, 'MonitorPositions');
for channel_i=1:31


    if size(MonPos, 1) == 1  % nicht mehr als ein Monitor    
        myfig=   figure('units','normalized','outerposition',[1 1 1 1],'name','Channel over time');
    else
         myfig=  figure('units','pix','outerposition',[MonPos(2,1) MonPos(2,2) MonPos(2,3) MonPos(2,4)],'name',sprintf('CG02 Channel %02d',channel_i));
    end

    for figure_i=1:10
        subplot(10,1,figure_i)
        mygca(figure_i) = gca;
        plot(linspace(0,(size(finalmonster,2)/2000),size(finalmonster,2)),finalmonster(channel_i,:))
    end
    
    set(mygca, 'Ylim', [-120 120])
    
    for figure_i=1:10
        set(mygca(figure_i), 'Xlim', [(figure_i*125/10)-12.5 figure_i*125/10])
    end
       speichername=sprintf('img_%02d.emf',channel_i); 
        saveas(myfig,speichername);
        close all
end
        
