%% dieses script soll alle LDOPA 10min ruheaufnahmen TFRs laden und 
% an python weitergeben.
% output: gif file und mat mit nanmean spectrum und my_foi
% EDIT 181207 nanmedian statt nanmean. robuster.
% EDIT 181227 mit TP00&31

clear all


if ~ispc
    cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/Ruhe10/TFRsWithNaN')
else
    cd('F:/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/Ruhe10/TFRsWithNaN')
end


if ~exist('prefooofed','dir')
        mkdir('prefooofed');
 end
 if ~exist('gifs','dir')
        mkdir('gifs');
 end

ordner=dir('*ArtCorr.mat');
files={ordner.name}';


for file_i=1:length(files)
    file=files(file_i);
    dateiname=file{:};
    load(dateiname)
    my_foi=TFRhann.freq;



    time=TFRhann.time';

    Yscaling=4e+8;

    spektral=nanmedian(TFRhann.powspctrm(:,:,:),3);
    h=figure('units','normalized','outerposition',[0 0 .6 .6]);
    subplot(1,3,1)
    plot(my_foi,spektral)
    xlim([0 max(my_foi)])
    ylim([0 Yscaling])

    
    xlabel('Frequency [Hz]')
    ylabel('Power [a.u.]')

 

    subplot(1,3,2:3)


    hoehe=Yscaling*0.95;
    filename=[dateiname(1:end-4) '.gif']
    for i=1:844:length(time)-844
    spektral_i=nanmedian(TFRhann.powspctrm(:,:,i:i+844),3);
    cla
    plot(my_foi,spektral_i)
    xlim([0 140])
    ylim([0 Yscaling])
    text(110,hoehe,['seconds: ' num2str(floor((time(i+844))))])
    xlabel('Frequency [Hz]')
    ylabel('Power [a.u.]')
    drawnow
    frame=getframe(h);
    im=frame2im(frame);
    [imind,cm]=rgb2ind(im,256);
    if i==1
        imwrite(imind,cm,[cd '\gifs\' filename],'gif','Loopcount',inf, 'DelayTime', 0.1);
    else
        imwrite(imind,cm,[cd '\gifs\' filename],'gif','Writemode','append', 'DelayTime', 0.1);
    end   
    clearvars spektral_i frame im imind cm
    end

    cd('prefooofed')
    save([dateiname(1:end-4) '_4fooof.mat'],'spektral','my_foi');
    
    
    
    cd ..
    clearvars -except files file_i
    close all
end

cd('prefooofed')


%% TP00&31
clear all


if ~ispc
    cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/TP00&TP31/TFRsWithNaN')
end


if ~exist('prefooofed','dir')
        mkdir('prefooofed');
 end
 if ~exist('gifs','dir')
        mkdir('gifs');
 end

ordner=dir('*ArtCorr.mat');
files={ordner.name}';


for file_i=1:length(files)
    file=files(file_i);
    dateiname=file{:};
    load(dateiname)
    my_foi=TFRhann.freq;



    time=TFRhann.time';

    Yscaling=4e+8;

    spektral=nanmedian(TFRhann.powspctrm(:,:,:),3);
    h=figure('units','normalized','outerposition',[0 0 .6 .6]);
    subplot(1,3,1)
    plot(my_foi,spektral)
    xlim([0 max(my_foi)])
    ylim([0 Yscaling])

    
    xlabel('Frequency [Hz]')
    ylabel('Power [a.u.]')

 

    subplot(1,3,2:3)


    hoehe=Yscaling*0.95;
    filename=[dateiname(1:end-4) '.gif']
    for i=1:844:length(time)-844
    spektral_i=nanmedian(TFRhann.powspctrm(:,:,i:i+844),3);
    cla
    plot(my_foi,spektral_i)
    xlim([0 140])
    ylim([0 Yscaling])
    text(110,hoehe,['seconds: ' num2str(floor((time(i+844))))])
    xlabel('Frequency [Hz]')
    ylabel('Power [a.u.]')
    drawnow
    frame=getframe(h);
    im=frame2im(frame);
    [imind,cm]=rgb2ind(im,256);
    if i==1
        imwrite(imind,cm,[cd '\gifs\' filename],'gif','Loopcount',inf, 'DelayTime', 0.1);
    else
        imwrite(imind,cm,[cd '\gifs\' filename],'gif','Writemode','append', 'DelayTime', 0.1);
    end   
    clearvars spektral_i frame im imind cm
    end

    cd('prefooofed')
    save([dateiname(1:end-4) '_4fooof.mat'],'spektral','my_foi');
    
    
    
    cd ..
    clearvars -except files file_i
    close all
end

cd('prefooofed')

    FileNameAndLocation=[mfilename('fullpath')];
    newbackup=sprintf('%s_rundate_%s.m', mfilename, date);
    currentfile=strcat(FileNameAndLocation, '.m');
    copyfile(currentfile,newbackup);