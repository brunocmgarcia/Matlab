%% s182404 average all valid channel combinations for icoherence in groups like str2str and str2snr etc.
% no averaging of animals yet.

clear all
cd('F:\Auswertung\FINAL180416\AllCombIcoh')
files=dir('*.mat');
for file_i=1:length(files)
    load(files(file_i).name)
%     mkdir([files(file_i).name(1:end-4) '_n1to1'])
%     cd(files(file_i).name(1:end-4))
     % namen raussuchen aus fd
    [striatalebeteiligung verwerfen] = find(~cellfun('isempty', strfind(fd(1).labelcmb, 'STR')));    
    [nigralebeteiligung verwerfen] = find(~cellfun('isempty', strfind(fd(1).labelcmb, 'SNR'))); 
    [M1beteiligung verwerfen] = find(~cellfun('isempty', strfind(fd(1).labelcmb, 'M1'))); 
    [str2m1_ind verwerfen]=find(ismember(striatalebeteiligung,M1beteiligung));
    str2m1_ind=striatalebeteiligung(str2m1_ind);
      [snr2m1_ind verwerfen]=find(ismember(nigralebeteiligung,M1beteiligung));
      snr2m1_ind=nigralebeteiligung(snr2m1_ind);
    [str2snr_ind verwerfen]=find(ismember(striatalebeteiligung,nigralebeteiligung));
    str2snr_ind=striatalebeteiligung(str2snr_ind);
       
    [verwerfen,einzelne_nigral,verwerfen]=unique(nigralebeteiligung);
    snr2snr_ind=nigralebeteiligung;
    snr2snr_ind(einzelne_nigral)=0;
    [snr2snr_ind verwerfen]=find(snr2snr_ind);
    snr2snr_ind=nigralebeteiligung(snr2snr_ind);
   
    [verwerfen,einzelne_striatal,verwerfen]=unique(striatalebeteiligung);
    str2str_ind=striatalebeteiligung;
    str2str_ind(einzelne_striatal)=0;
    [str2str_ind verwerfen]=find(str2str_ind);
    str2str_ind=striatalebeteiligung(str2str_ind);
    
 %  str2strspec=zeros(18,48);
    
    
    mylim=[-1 1];
    CM = jet(length(fd));
    anzahlcombi=length(fd(1).labelcmb);
   
        myplot=figure('Name',files(file_i).name(1:end-4), 'Units', 'normalized', 'OuterPosition', [0 0 1 1]);
        
            subplot(5,1,1)
            axis tight
            hold on
            for i=1:length(fd)
          %      str2strspec(i,:)=(str2strspec(i,:)+ (mean((fd(i).cohspctrm(str2str_ind,:)),1)./5));
               plot(fd(i).freq, mean((fd(i).cohspctrm(str2str_ind,:)),1), 'color', CM(i,:))
            end
            hold off
            title('Str 2 Str averaged');
            ylim(mylim)
            
            subplot(5,1,2)
            axis tight
            hold on
            for i=1:length(fd)
               plot(fd(i).freq, mean((fd(i).cohspctrm(snr2snr_ind,:)),1), 'color', CM(i,:))
            end
            hold off
            title('SNR 2 SNR averaged');
            ylim(mylim)
            
            subplot(5,1,3)
            axis tight
            hold on
            for i=1:length(fd)
               plot(fd(i).freq, mean((fd(i).cohspctrm(str2m1_ind,:)),1), 'color', CM(i,:))
            end
            hold off
            title('STR 2 M1 averaged');
            ylim(mylim)
            
             subplot(5,1,4)
            axis tight
            hold on
            for i=1:length(fd)
               plot(fd(i).freq, mean((fd(i).cohspctrm(snr2m1_ind,:)),1), 'color', CM(i,:))
            end
            hold off
            title('SNR 2 M1 averaged');
            ylim(mylim)
            
             subplot(5,1,5)
            axis tight
            hold on
            for i=1:length(fd)
               plot(fd(i).freq, mean((fd(i).cohspctrm(str2snr_ind,:)),1), 'color', CM(i,:))
            end
            hold off
            title('STR 2 SNR averaged');
            ylim(mylim)
            
            
         speichername=['F:\Auswertung\FINAL180416\AllCombIcoh\averaged_combinations\' files(file_i).name(1:end-4) '.png']; 
         saveas(myplot,speichername);
         close(myplot)
    end
  