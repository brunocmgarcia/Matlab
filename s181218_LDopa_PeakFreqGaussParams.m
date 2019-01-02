%% 181218_LDopa_PeakFreqGaussParams
% stand: umgebaut zu center of mass
clear all
cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/180/TFRsWithNaN/fooofed')

load VAR_baselineschluessel
ordner=dir('*.mat');
files={ordner.name}';
lowerfreq=70;
higherfreq=130;
masterpeakfreq(1:10)=nan;
peakfreq=[];

for file_i=1:length(files)
      
        peakfreq=[];

    file=files(file_i);
    dateiname=file{:};
       BLdateiname=baselineschluessel(find(strcmp([dateiname(1:end-18) '_4fooof.mat'],baselineschluessel)),2);
    BLdateiname=BLdateiname{:};
     if ~isempty(BLdateiname)
         BLdateiname=[BLdateiname(1:end-18) '_TFRhannArtCorr_4fooof.mat'];
        BLdateiname=['/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/Ruhe10/TFRsWithNaN/fooofed/' BLdateiname]
        BLs=load(BLdateiname);
        BLfields=fieldnames(BLs);
    s=load(dateiname);
    fields=fieldnames(s);
    freq=s.(cell2mat(fields(5)));
    [verwerfen lower]=min(abs(lowerfreq-freq));
    [verwerfen upper]=min(abs(higherfreq-freq));





    zaehler=0;



    for i=1:9:length(fields)
        zaehler=zaehler+1;
        BLflat=BLs.(cell2mat(BLfields(3)));
        flat=s.(cell2mat(fields(i+2)));

        %             gaussparam=s.(cell2mat(fields(i)));
        %             if ~isempty(gaussparam)
        %                 if size(gaussparam,1)>1
        %                     [~, index]=max(gaussparam(:,2));
        %                     gaussparam=gaussparam(index,1);
        %                 else
        %                     gaussparam=gaussparam(1,1);
        %                 end
        %                 
        %                 peakfreq(zaehler)=gaussparam;
        %             else
        %                 peakfreq(zaehler)=NaN;
        %             end
         peakfreqhelper1=freq(lower:upper);
         newFlat=flat(lower:upper)-BLflat(lower:upper);
         newFlat(newFlat<0)=0;
        
         newFlat=newFlat./(sum(newFlat));
        
         peakfreq(zaehler)=sum(newFlat.*peakfreqhelper1);
         
            
            %[verwerfen,peakfreqhelper2]=max(flat(lower:upper)-BLflat(lower:upper));
            %peakfreq(zaehler)=peakfreqhelper1(peakfreqhelper2);

    end
     end
    if size(peakfreq,2) < 10
        peakfreq(size(peakfreq,2)+1:10)=nan;
    end
    
    masterpeakfreq=cat(1,masterpeakfreq,peakfreq); 
    
    clearvars -except file_i masterpeakfreq files lowerfreq higherfreq masterpeakpowerlog masterpeakpowerlogBL masterpeakpowernologBL masterpeakpowernolog baselineschluessel
end


f=masterpeakfreq(2:end,:);
save(['/Users/guettlec/Dropbox/data/00_variables/VAR_centerofmasspeakfreqs.mat'],'f')

