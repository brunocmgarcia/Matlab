%% dieses script soll alle LDOPA 10min ruheaufnahmen TFRs laden und 
% an python weitergeben.
% output: gif file und mat mit nanmean spectrum und my_foi


clear all
cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/Ruhe10/TFRsWithNaN')



ordner=dir('*.mat');
files={ordner.name}';


for file_i=1:length(files)
    file=files(file_i);
    dateiname=file{:};
    load(dateiname)
    my_foi=0.5:1:140;



    time=TFRhann.time';

    Yscaling=7e+8;

    spektral=nanmean(TFRhann.powspctrm(:,:,:),3);
    h=figure('units','normalized','outerposition',[0 0 .6 .6]);
    subplot(1,3,1)
    plot(my_foi,spektral)
    xlim([0 max(my_foi)])
    ylim([0 Yscaling])

    
    xlabel('Frequency [Hz]')
    ylabel('Power [a.u.]')

 

    subplot(1,3,2:3)


    hoehe=Yscaling*0.95;
    filename=['prefooofed/' dateiname(1:end-4) '.gif']
    for i=1:844:length(time)-844
    spektral_i=nanmean(TFRhann.powspctrm(:,:,i:i+844),3);
    cla
    plot(my_foi,spektral_i)
    xlim([0 140])
    ylim([0 Yscaling])
    text(120,hoehe,['Sekunden: ' num2str(floor((time(i+844))))])
    xlabel('Frequency [Hz]')
    ylabel('Power [a.u.]')
    drawnow
    frame=getframe(h);
    im=frame2im(frame);
    [imind,cm]=rgb2ind(im,256);
    if i==1
        imwrite(imind,cm,filename,'gif','Loopcount',inf, 'DelayTime', 0.1);
    else
        imwrite(imind,cm,filename,'gif','Writemode','append', 'DelayTime', 0.1);
    end   
    clearvars spektral_i frame im imind cm
    end

    cd('prefooofed')
    save([dateiname(1:end-4) '_4fooof.mat'],'spektral','my_foi');
    cd ..
    clearvars -except files file_i
    close all
end
