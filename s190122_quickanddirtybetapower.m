clearvars
cd('C:\Users\bruno\Documents\LR3\4bruno\4bruno')

    
Liste=dir('*Ruhe*');
Liste={Liste.name}';


for datei_i=1:length(Liste)
  %  figure
    aktuelle_datei=Liste(datei_i);
    load(aktuelle_datei{:})
    cfg=[];
    cfg.length=2;
    data = ft_redefinetrial(cfg, data);  
    for i=1:length(data.trial) 
            welch(:,:,i)=(data.trial{1,i}')/800; 
            [pxx(:,:,i), welch_freq(:,1)]=(pwelch(welch(:,:,i), hanning(100), [], 2048, 2000, 'psd'));  % mit hanning statt hamming 

    end
    welch=pxx;
	clearvars pxx
	welch_average=mean(welch,3); %averaging all trials in each channel
    %totalaverage(datei_i,:)= mean(welch_average,2);%averaging all channels
    totalaverageSTR(datei_i,:)= mean(welch_average(:,[1:15]),2); %averaging all STR channels together
    totalaverageSNR(datei_i,:)= mean(welch_average (:,[16:29]),2); %averaging all SNR channels
    totalaverageM1(datei_i,:)= welch_average (:,30); % M1 channel
%         h=s171109_normalizegame(welch_average, welch_freq)
%     uiwait(h)
%       
    
% 
    [c norm_index_unten1] = min(abs(welch_freq-60));
    [c norm_index_oben1] = min(abs(welch_freq-65));
    clearvars c
    
%     [c norm_index_unten2] = min(abs(welch_freq-60));
%     [c norm_index_oben2] = min(abs(welch_freq-65));
%     clearvars c
    
    normfaktor=mean(welch_average([norm_index_unten1:norm_index_oben1],:));
    
%     
% % %  variante mit 1/f^2 scaling   
% %     normfaktor= repmat(welch_freq,1,size(welch_average,2));
% %     normfaktor=(normfaktor.^2);
% %     normfaktor=1./normfaktor;
% %     
%     
%     
    welch_average_norm= bsxfun(@rdivide, welch_average, normfaktor);
     welch_average=(welch_average_norm);
      %totalaveragenorm(datei_i,:)= mean(welch_average,2);
      totalaveragenormSTR(datei_i,:)= mean(welch_average(:,[1:15]),2); %averaging all STR channels together
      totalaveragenormSNR(datei_i,:)= mean(welch_average (:,[16:29]),2); %averaging all SNR channels
      totalaveragenormM1(datei_i,:)= welch_average (:,30); % M1 channel
       
%         plot(welch_freq,welch_average(:,:))
%           title(aktuelle_datei{1,1}(1:14), 'Interpreter', 'none', 'FontSize', 8)  
%           xlabel('Frequency [Hz]', 'FontSize', 8)
%           ylabel('Power [a.u.]', 'FontSize', 8)


%         drawnow
%         [pks,locs] = findpeaks(welch_average_norm);
%         if isempty((welch_freq(locs(welch_freq(locs)>13 & welch_freq(locs)<45))))==0
% 
%         peaks_locs{datei_i}=(welch_freq(locs(welch_freq(locs)>13 & welch_freq(locs)<45)));
%         peaks_height{datei_i}=(pks(find((welch_freq(locs)>13 & welch_freq(locs)<45))));
%          hold on
%          scatter(cell2mat(peaks_locs(datei_i)),cell2mat(peaks_height(datei_i))); 
%          hold off
%         end
%          set(gca, 'Xlim', [4 65])
%         set(gca, 'XTick', 5:10:65)
%       %       set(gca, 'Ylim', [0 1.5])
%             set(gca, 'XMinorGrid', 'on')
%          set(gca, 'YGrid', 'on')
         
        clearvars -except totalaveragenorm* LocFig Liste datei_i peaks_locs peaks_height totalaverage* baseline mygca total_average2 total_average4 welch_freq
end

figure
hold on
plot(welch_freq,totalaveragenormSNR(1,:))
plot(welch_freq,totalaveragenormSNR(2,:))

hold off
ylim([0 20])
xlim([10 80])

figure
hold on
plot(repmat(welch_freq,[1,]),(totalaveragenormSNR(1,:))','r')
plot(repmat(welch_freq,[1,1]),(totalaveragenormSNR(2,:))','b')

hold off
ylim([0 20])
xlim([10 80])

figure
hold on
plot(repmat(welch_freq,[1,1]),(totalaverageSNR([1],:))','r')
plot(repmat(welch_freq,[1,1]),(totalaverageSNR([2],:))','b')

hold off
ylim([0 20])
xlim([10 80])


figure
plot(welch_freq,totalaveragenormSNR(2,:)./totalaveragenormSNR(1,:))





