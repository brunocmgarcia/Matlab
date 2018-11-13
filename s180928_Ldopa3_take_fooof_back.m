%% Ldopa3: nimmt die gefoooften datein zurück.
%output: jeweils eine figure mit original powspctr, gauss model, just
%peaks, justpeaks als lineartransform. zusätzlich am schluss eine csv für
%peaks und linpeak AUC sowie txt liste aller datei namen um am schluss ein
%excel sheet zu erstellen.

clear all
cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/180/TFRsWithNaN/fooofed')



ordner=dir('*.mat');
files={ordner.name}';
lowerfreq=70;
higherfreq=130;

 masterpeakpowerlog(1:10)=nan;
 masterpeakpowernolog(1:10)=nan;

for file_i=1:length(files)
    file=files(file_i);
    dateiname=file{:};
    s=load(dateiname);
    fields=fieldnames(s);
    freq=s.(cell2mat(fields(4)));
    [verwerfen lower]=min(abs(lowerfreq-freq));
    [verwerfen upper]=min(abs(higherfreq-freq));
    
    myfig=figure('units','normalized','outerposition',[0 0 1 1]);
    axis tight manual
    farbe=hot(70);
    colormap(hot(70));
    zaehler=0;
    for i=1:7:length(fields)
        zaehler=zaehler+1;
        gaussparam=s.(cell2mat(fields(i)));
        peakfit=s.(cell2mat(fields(i+1)));
        bgfit=s.(cell2mat(fields(i+2)));
        power=s.(cell2mat(fields(i+4)));
        R2=s.(cell2mat(fields(i+5)));
        fooofed=s.(cell2mat(fields(i+6)));
        s1=subplot(1,4,1);
        hold on
        plot(freq,power, 'Color', farbe(i,:))
        ylim([0 10])
        hold off
        s2=subplot(1,4,2);
        hold on
        plot(freq,fooofed, 'Color', farbe(i,:))
        ylim([0 10])
        hold off
        s3=subplot(1,4,3);
        ylim([0 1])
        hold on
        plot(freq,peakfit, 'Color', farbe(i,:))
        hold off
        
        s4=subplot(1,4,4);
        ylim([0 8])
        hold on
        plot(freq,((10.^peakfit)-1), 'Color', farbe(i,:))
        hold off       
        peakpowerlog(zaehler)=sum(peakfit(lower:upper));
        peakpowernolog(zaehler)=sum((10.^peakfit(lower:upper))-1);
    end
    
    set(myfig, 'currentaxes', s1)
    xlabel('Frequency [Hz]')
    ylabel('log10(Power)')
    title('Original Spectrum, semi-log')    
    colorbar
    
    set(myfig, 'currentaxes', s2)
    xlabel('Frequency [Hz]')
    ylabel('log10(Power)')
    title('Gaussian Reconstruction, semi-log')  
    
    set(myfig, 'currentaxes', s3)
    peakpowertextlog=cat(1,1:zaehler,peakpowerlog);
    peakpowertextlog=num2str(peakpowertextlog');
    yhelper1=get(gca,'ylim');
    text(65,yhelper1(2)*0.9,{['AUC log10(power) ' num2str(freq(lower))...
        'Hz to ' num2str(freq(upper)) 'Hz'], 'TP   result',(peakpowertextlog)});
    xlabel('Frequency [Hz]')
    ylabel('log10(Power)')
    title('1/f subtracted Gaussians, semi-log')
    rectangle('Position', [freq(lower) 0 freq(upper)-freq(lower) yhelper1(2)], 'FaceColor', [0 0 0 0.1], 'EdgeColor', 'none')

    
    set(myfig, 'currentaxes', s4)
    peakpowertextnolog=cat(1,1:zaehler,peakpowernolog);
    peakpowertextnolog=num2str(peakpowertextnolog');
    yhelper2=get(gca,'ylim');
    text(65,yhelper2(2)*0.9,{['AUC linear power ' num2str(freq(lower))...
        'Hz to ' num2str(freq(upper)) 'Hz'], 'TP   result',(peakpowertextnolog)});
    xlabel('Frequency [Hz]')
    ylabel('Power')
    title('1/f subtracted Gaussians, linear')
    rectangle('Position', [freq(lower) 0 freq(upper)-freq(lower) yhelper2(2)], 'FaceColor', [0 0 0 0.1], 'EdgeColor', 'none')
    cd MAT_processed
    saveas(gcf,[dateiname(1:end-10) 'fooofed.png'])
    cd ..
    close all
    if size(peakpowerlog,2) < 10
        peakpowerlog(size(peakpowerlog,2)+1:10)=nan;
    end
    if size(peakpowernolog,2) < 10
        peakpowernolog(size(peakpowernolog,2)+1:10)=nan;
    end
    masterpeakpowerlog=cat(1,masterpeakpowerlog,peakpowerlog);
    masterpeakpowernolog=cat(1,masterpeakpowernolog,peakpowernolog);
    clearvars -except file_i files lowerfreq higherfreq masterpeakpowerlog masterpeakpowernolog
end
cd MAT_processed
dlmwrite(['fooofed_log_csv.txt'],masterpeakpowerlog);
dlmwrite(['fooofed_nolog_csv.txt'],masterpeakpowernolog);
fileID = fopen('filenames.txt','w');

for row = 1:length(files)
    fprintf(fileID, '%i : %s\n', row, files{row});
end

fclose(fileID);
