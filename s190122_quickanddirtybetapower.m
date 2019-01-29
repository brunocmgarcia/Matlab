clearvars
cd('E:\Auswertung\noreref500hzforbeta\ds\trialappend\selected')

    
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
            [pxx(:,:,i), welch_freq(:,1)]=(pwelch(welch(:,:,i), hanning(100), [], 2048, 500, 'psd'));  % mit hanning statt hamming
    end
    welch=pxx;
	clearvars pxx
	welch_average=mean(welch,3);
    totalaverage(datei_i,:)= welch_average;   
%         h=s171109_normalizegame(welch_average, welch_freq)
%     uiwait(h)
%       
    
% 
    [c norm_index_unten1] = min(abs(welch_freq-60));
    [c norm_index_oben1] = min(abs(welch_freq-65));
    clearvars c
    
    [c norm_index_unten2] = min(abs(welch_freq-60));
    [c norm_index_oben2] = min(abs(welch_freq-65));
    clearvars c
    
    normfaktor=mean(welch_average([norm_index_unten1:norm_index_oben1 norm_index_unten2:norm_index_oben2],:));
    
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
      totalaveragenorm(datei_i,:)= welch_average;  
       
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
         
        clearvars -except totalaveragenorm LocFig Liste datei_i peaks_locs peaks_height totalaverage baseline mygca total_average2 total_average4 welch_freq
end

figure
hold on
plot(welch_freq,mean(totalaveragenorm([1 5 7 9   13],:),1))
plot(welch_freq,mean(totalaveragenorm([2 6 8 10  14],:),1))

hold off
ylim([0 20])
xlim([10 80])

figure
hold on
plot(repmat(welch_freq,[1,5]),(totalaveragenorm([1 5 7 9   13],:))','r')
plot(repmat(welch_freq,[1,5]),(totalaveragenorm([2 6 8 10  14],:))','b')

hold off
ylim([0 20])
xlim([10 80])

figure
hold on
plot(repmat(welch_freq,[1,5]),(totalaverage([1 5 7 9   13],:))','r')
plot(repmat(welch_freq,[1,5]),(totalaverage([2 6 8 10  14],:))','b')

hold off
ylim([0 20])
xlim([10 80])


figure
plot(welch_freq,mean(totalaveragenorm([2:2:14],:),1)./mean(totalaveragenorm([1:2:14],:),1))





