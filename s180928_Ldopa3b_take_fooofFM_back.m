%% Ldopa3: nimmt die gefoooften datein zur�ck.
%output: jeweils eine figure mit original powspctr, gauss model, flat.
% flat als lineartransform. dann baseline (flat) abziehen. zus�tzlich am schluss eine csv f�r
%peaks und linpeak AUC sowie txt liste aller datei namen um am schluss ein
%excel sheet zu erstellen. 181009: jetzt mit AUC trapz

clear all
cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/180/TFRsWithNaN/fooofed')
if ~exist('MAT_processed','dir')
        mkdir('MAT_processed');
 end



ordner=dir('*.mat');
files={ordner.name}';
lowerfreq=70;
higherfreq=130;

masterpeakpowerlog(1:10)=nan;
masterpeakpowernolog(1:10)=nan;
masterpeakpowerlogBL(1:10)=nan;
masterpeakpowernologBL(1:10)=nan;
masterpeakfreq(1:10)=nan;

load VAR_baselineschluessel

for file_i=1:length(files)
    file=files(file_i);
    dateiname=file{:};
    s=load(dateiname);
    fields=fieldnames(s);
    freq=s.(cell2mat(fields(5)));
    [verwerfen lower]=min(abs(lowerfreq-freq));
    [verwerfen upper]=min(abs(higherfreq-freq));
    
    BLdateiname=baselineschluessel(find(strcmp([dateiname(1:end-18) '_4fooof.mat'],baselineschluessel)),2);
    BLdateiname=BLdateiname{:};
   
    peakpowerlog=[];
    peakpowernolog=[];
    peakpowerlogBL=[];
    peakpowernologBL=[];
    peakfreq=[];
    
    if ~isempty(BLdateiname)
         BLdateiname=[BLdateiname(1:end-18) '_TFRhannArtCorr_4fooof.mat'];
        BLdateiname=['/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/Ruhe10/TFRsWithNaN/fooofed/' BLdateiname]
        BLs=load(BLdateiname);
        BLfields=fieldnames(BLs);

        myfig=figure('units','normalized','outerposition',[0 0 1 1]);
        axis tight manual
        farbe=hot(length(fields));
        colormap(hot(length(fields)));
        zaehler=0;

        s1=subplot(2,4,[1 5]);
        s2=subplot(2,4,[2 6]);
        s3=subplot(2,4,3);
        s4=subplot(2,4,4);
        s5=subplot(2,4,7);
        s6=subplot(2,4,8);

        for i=1:9:length(fields)
            zaehler=zaehler+1;
            BLpower=BLs.(cell2mat(BLfields(6)));
            BLflat=BLs.(cell2mat(BLfields(3)));
            BLfooofed=BLs.(cell2mat(BLfields(9)));
            BLbgfit=BLs.(cell2mat(BLfields(4)));

            gaussparam=s.(cell2mat(fields(i)));
            peakfit=s.(cell2mat(fields(i+1)));
            flat=s.(cell2mat(fields(i+2)));
            bgfit=s.(cell2mat(fields(i+3)));

            power=s.(cell2mat(fields(i+5)));
            R2=s.(cell2mat(fields(i+6)));
            peak_rm=s.(cell2mat(fields(i+7)));
            fooofed=s.(cell2mat(fields(i+8)));

            set(myfig, 'currentaxes', s1)
            hold on
            plot(freq,power, 'Color', farbe(i,:))
            p1=plot(freq,BLpower, 'Color', 'g');
            legend(p1,'Baseline', 'Location', 'northeast')
            ylim([6 9])
            hold off

            set(myfig, 'currentaxes', s2)
            hold on
            plot(freq,fooofed, 'Color', farbe(i,:))
            plot(freq,bgfit,'--','Color',farbe(i,:))
            p2=plot(freq,BLfooofed, 'Color', 'g');
            plot(freq,BLbgfit,'--', 'Color', 'g')
            legend(p2,'Baseline', 'Location', 'northeast')
            ylim([6 9])
            hold off


            set(myfig, 'currentaxes', s3)
            ylim([0 1])
            hold on
            plot(freq,flat, 'Color', farbe(i,:))
            p3=plot(freq,BLflat, 'Color', 'g');
            legend(p3,'Baseline', 'Location', 'northeast')
            hold off

            set(myfig, 'currentaxes', s4)
            ylim([0 8])
            hold on
            plot(freq,((10.^flat)-1), 'Color', farbe(i,:))
            p4=plot(freq,((10.^BLflat)-1), 'Color', 'g');
            legend(p4,'Baseline', 'Location', 'northeast')
            hold off       
            peakpowerlog(zaehler)=trapz(freq(lower:upper),flat(lower:upper));
            peakpowernolog(zaehler)=trapz(freq(lower:upper),(10.^flat(lower:upper))-1);
            
            set(myfig, 'currentaxes', s5)
            ylim([0 1])
            hold on
            plot(freq,flat-BLflat, 'Color', farbe(i,:))
            hold off

            set(myfig, 'currentaxes', s6)
            ylim([0 8])
            hold on
            plot(freq,((10.^(flat-BLflat))-1), 'Color', farbe(i,:))
            hold off       
            peakpowerlogBL(zaehler)=trapz(freq(lower:upper),(flat(lower:upper)-BLflat(lower:upper)));
            peakfreqhelper1=freq(lower:upper);
            [verwerfen,peakfreqhelper2]=max(flat(lower:upper)-BLflat(lower:upper));
            peakfreq(zaehler)=peakfreqhelper1(peakfreqhelper2);
            peakpowernologBL(zaehler)=trapz(freq(lower:upper),((10.^(flat(lower:upper)-BLflat(lower:upper)))-1));       
        end
    
        set(myfig, 'currentaxes', s1)
        xlabel('Frequency [Hz]')
        ylabel('log10(Power)')
        title('Original Spectrum, semi-log')  
        colorbar('TickLabels',{'0min','10min','30min','50min','70min','90min','110min','130min','150min','170min','180min'})


        set(myfig, 'currentaxes', s2)
        xlabel('Frequency [Hz]')
        ylabel('log10(Power)')
        title('Gaussian Reconstruction, semi-log')  

        set(myfig, 'currentaxes', s3)
        peakpowertextlog=cat(1,1:zaehler,peakpowerlog);
        peakpowertextlog=num2str(peakpowertextlog');
        yhelper1=get(gca,'ylim');
        text(65,yhelper1(2)*0.8,{['AUC log10(power) ' num2str(freq(lower))...
            'Hz to ' num2str(freq(upper)) 'Hz'], 'TP   result',(peakpowertextlog)});
        xlabel('Frequency [Hz]')
        ylabel('log10(Power)')
        title('1/f subtracted power, semi-log')
        rectangle('Position', [freq(lower) 0 freq(upper)-freq(lower) yhelper1(2)], 'FaceColor', [0 0 0 0.1], 'EdgeColor', 'none')


        set(myfig, 'currentaxes', s4)
        peakpowertextnolog=cat(1,1:zaehler,peakpowernolog);
        peakpowertextnolog=num2str(peakpowertextnolog');
        yhelper2=get(gca,'ylim');
        text(65,yhelper2(2)*0.8,{['AUC linear power ' num2str(freq(lower))...
            'Hz to ' num2str(freq(upper)) 'Hz'], 'TP   result',(peakpowertextnolog)});
        xlabel('Frequency [Hz]')
        ylabel('Power')
        title('1/f subtracted power, linear')
        rectangle('Position', [freq(lower) 0 freq(upper)-freq(lower) yhelper2(2)], 'FaceColor', [0 0 0 0.1], 'EdgeColor', 'none')

        set(myfig, 'currentaxes', s5)
        peakpowertextlogBL=cat(1,1:zaehler,peakpowerlogBL);
        peakpowertextlogBL=cat(1,peakpowertextlogBL,peakfreq);
        peakpowertextlogBL=num2str(peakpowertextlogBL');
        yhelper1=get(gca,'ylim');
        text(65,yhelper1(2)*0.8,{['AUC log10(power) ' num2str(freq(lower))...
            'Hz to ' num2str(freq(upper)) 'Hz'], 'TP   result',(peakpowertextlogBL)});
        xlabel('Frequency [Hz]')
        ylabel('log10(Power)')
        title('1/f subtracted power, semi-log, BL subtracted')
        rectangle('Position', [freq(lower) 0 freq(upper)-freq(lower) yhelper1(2)], 'FaceColor', [0 0 0 0.1], 'EdgeColor', 'none')

        set(myfig, 'currentaxes', s6)
        peakpowertextnologBL=cat(1,1:zaehler,peakpowernologBL);
        peakpowertextnologBL=num2str(peakpowertextnologBL');
        yhelper2=get(gca,'ylim');
        text(65,yhelper2(2)*0.8,{['AUC linear power ' num2str(freq(lower))...
            'Hz to ' num2str(freq(upper)) 'Hz'], 'TP   result',(peakpowertextnologBL)});
        xlabel('Frequency [Hz]')
        ylabel('Power')
        title('1/f subtracted power, linear, BL subtracted')
        rectangle('Position', [freq(lower) 0 freq(upper)-freq(lower) yhelper2(2)], 'FaceColor', [0 0 0 0.1], 'EdgeColor', 'none')




        cd MAT_processed
         saveas(gcf,[dateiname(1:end-10) 'fooofed.png'])
        cd ..
        close all
     end
        if size(peakpowerlog,2) < 10
            peakpowerlog(size(peakpowerlog,2)+1:10)=nan;
        end
        if size(peakpowernolog,2) < 10
            peakpowernolog(size(peakpowernolog,2)+1:10)=nan;
        end
        masterpeakpowerlog=cat(1,masterpeakpowerlog,peakpowerlog);
        masterpeakpowernolog=cat(1,masterpeakpowernolog,peakpowernolog);

        if size(peakpowerlogBL,2) < 10
            peakpowerlogBL(size(peakpowerlogBL,2)+1:10)=nan;
        end
        if size(peakpowernologBL,2) < 10
            peakpowernologBL(size(peakpowernologBL,2)+1:10)=nan;
        end
        if size(peakfreq,2) < 10
            peakfreq(size(peakfreq,2)+1:10)=nan;
        end
        masterpeakpowerlogBL=cat(1,masterpeakpowerlogBL,peakpowerlogBL);
        masterpeakpowernologBL=cat(1,masterpeakpowernologBL,peakpowernologBL);    
        masterpeakfreq=cat(1,masterpeakfreq,peakfreq); 
    
    clearvars -except file_i masterpeakfreq files lowerfreq higherfreq masterpeakpowerlog masterpeakpowerlogBL masterpeakpowernologBL masterpeakpowernolog baselineschluessel
end
cd MAT_processed
dlmwrite(['fooofed_log_csv.txt'],masterpeakpowerlog);
dlmwrite(['fooofed_log_BLsubtracted_csv.txt'],masterpeakpowerlogBL);
dlmwrite(['fooofed_nolog_csv.txt'],masterpeakpowernolog);
dlmwrite(['fooofed_nolog_BLsubtracted_csv.txt'],masterpeakpowernologBL);
dlmwrite(['fooofed_log_BLsubtracted_freqs_csv.txt'],masterpeakfreq);
fileID = fopen('filenames.txt','w');

for row = 1:length(files)
    fprintf(fileID, '%i : %s\n', row, files{row});
end

fclose(fileID);
results.masterpeakfreq=masterpeakfreq(2:end,:);
results.masterpeakpowerlog=masterpeakpowerlog(2:end,:);
results.masterpeakpowernolog=masterpeakpowernolog(2:end,:);
results.masterpeakpowerlogBL=masterpeakpowerlogBL(2:end,:);
results.masterpeakpowernologBL=masterpeakpowernologBL(2:end,:);
results.filenames=files;
save('results.mat', 'results');

   FileNameAndLocation=[mfilename('fullpath')];
    newbackup=sprintf('%s_rundate_%s.m', mfilename, date);
    currentfile=strcat(FileNameAndLocation, '.m');
    copyfile(currentfile,newbackup);