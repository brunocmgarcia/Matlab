%%s180428c_M1power_trialappend_onlygoodchannels_psd_averageanimals
clear all
close all
clc
aktuellerordner=cd;
cd('F:\Auswertung\FINAL180416\02_downsampledTo500Hz')

IncludedAnimals={'CG02';'CG04';'CG05';'CG06';'CG07'};
load VAR_datakey
goodchannels{1}=datakey.key(78).includedchannels;
goodchannels{2}=datakey.key(240).includedchannels;
goodchannels{3}=datakey.key(370).includedchannels;
goodchannels{4}=datakey.key(500).includedchannels;
goodchannels{5}=datakey.key(636).includedchannels;


IncludedParad={'Ruhe';'LB10';'LB20'};
totalpsd=zeros(length(IncludedAnimals),length(IncludedParad),5,32,2049);
for paradigm_i=1:size(IncludedParad,1)
    for animal_i=1:size(IncludedAnimals,1)
            tier=(IncludedAnimals(animal_i));
            tier=tier{:};
            paradigm=(IncludedParad(paradigm_i));
            paradigm=paradigm{:};
            Liste=dir(['*' tier '*' paradigm '*']);
            Liste={Liste.name}';
          
          
            for datei_i=1:length(Liste)

                aktuelle_datei=Liste(datei_i);
                load(aktuelle_datei{:})
                
                goodsnrchannels=find(~cellfun('isempty', strfind(data.label, 'SNR'))); 
                [goodsnrchannelsind verwerfen]=find(ismember(goodsnrchannels,cell2mat(goodchannels(animal_i))));
                goodsnrchannels=goodsnrchannels(goodsnrchannelsind);                 
                goodstriatumchannels=find(~cellfun('isempty', strfind(data.label, 'STR'))); 
                [goodstriatumchannelsind verwerfen]=find(ismember(goodstriatumchannels,cell2mat(goodchannels(animal_i))));
                goodstriatumchannels=goodstriatumchannels(goodstriatumchannelsind);
                clearvars goodsnrchannelsind goodstriatumchannelsind verwerfen
                
                cfg=[];
                cfg.demean='yes';
                cfg.reref='yes';
                cfg.refchannel=31;
                cfg.refmethod='avg';

                data=ft_preprocessing(cfg,data);


                 cfg=[];
                           cfg.artfctdef.zvalue.channel     = 30;
                           cfg.artfctdef.zvalue.cutoff      = 3;
                           cfg.artfctdef.zvalue.trlpadding  = 0;
                           cfg.artfctdef.zvalue.artpadding  = .2;
                           cfg.artfctdef.zvalue.fltpadding  = 0;

                           % algorithmic parameters
                           cfg.artfctdef.zvalue.bpfilter   = 'yes';
                           cfg.artfctdef.zvalue.bpfilttype = 'but';
                           cfg.artfctdef.zvalue.bpfreq     = [.5 12];
                           cfg.artfctdef.zvalue.bpfiltord  = 2;   %2
                           cfg.artfctdef.zvalue.hilbert    = 'yes';

                           % feedback
                           cfg.artfctdef.zvalue.interactive = 'no';

                           [cfg, artifact_low] = ft_artifact_zvalue(cfg, data);
                           cfg.artfctdef.reject = 'partial';
                           data=ft_rejectartifact(cfg,data);

              % data=specialreref(data);



                 cfg=[];
                    cfg.length=0.9;
                    data = ft_redefinetrial(cfg, data);  

             

            %%
                     for i=1:length(data.trial) 
                         daten=(data.trial{1,i}(:,:)')/800;
                         %daten=mean(daten,2);
                         welch(:,:,i)=daten;

            %             welch(:,:,i)=(data.trial{1,i}([16:29],:)')/800;

                        %[pxx(:,:,i), welch_freq(:,1)]=pmtm(welch(:,:,i),[],[],2000);
                        %[pxx(:,:,i), welch_freq(:,1)]=pwelch(welch(:,:,i), [], [], [], data.fsample);  % mit hamming(auto) 
                        [pxx(:,:,i), welch_freq(:,1)]=(pwelch(welch(:,:,i), hanning(175), [], 4096, 500, 'psd'));  % mit hanning statt hamming

                        if i==1
                            [c norm_index_unten1] = min(abs(welch_freq-4));
                            [c norm_index_oben1] = min(abs(welch_freq-14));
                            clearvars c
                            [c norm_index_unten2] = min(abs(welch_freq-55));
                            [c norm_index_oben2] = min(abs(welch_freq-65));
                            clearvars c
                        end

                normfaktor=mean(pxx([norm_index_unten1:norm_index_oben1],:,i));
                pxx(:,:,i)= bsxfun(@rdivide, (pxx(:,:,i)), normfaktor);
                normfaktor=mean(pxx([norm_index_unten2:norm_index_oben2],:,i));
                pxx(:,:,i)= bsxfun(@minus, (pxx(:,:,i)), normfaktor);
                
                        
                        
            %             normfaktor= repmat(welch_freq,1,size(pxx(:,:,i),2));
            %             normfaktor=(normfaktor.^2);
            %             normfaktor=1./normfaktor;
            %            



                    end

                    welch=pxx;
                    clearvars pxx
                    
%                     welch=
%                     a = bsxfun(@rdivide, a, nanmean(a(:,[1:2 5:6]),2));
                    
                    
                    welch_trial_average_striatum=mean(welch(:,goodstriatumchannels,:),3);
                    welch_trial_average_striatum=mean(welch_trial_average_striatum,2);
                    welch_trial_average_striatumall=mean(welch(:,[1:15],:),3);
                    welch_trial_average_striatumall=mean(welch_trial_average_striatumall,2);
                    welch_trial_average_snr=mean(welch(:,goodsnrchannels,:),3);
                    welch_trial_average_snr=mean(welch_trial_average_snr,2);
                    welch_trial_average_snrall=mean(welch(:,[16:29],:),3);
                    welch_trial_average_snrall=mean(welch_trial_average_snrall,2);
                    welch_trial_average_m1=mean(welch(:,30,:),3);
%                     figure
%                     subplot(1,2,1)
%                     plot(welch_freq,welch_trial_average_striatum)
%                     subplot(1,2,2)
%                     plot(welch_freq,welch_trial_average_striatumall)
            

            %     
            % % %  variante mit 1/f^2 scaling   
            % %     normfaktor= repmat(welch_freq,1,size(welch_average,2));
            % %     normfaktor=(normfaktor.^2);
            % %     normfaktor=1./normfaktor;
            % %     
            %     
            %     
%                 welch_average_norm= bsxfun(@rdivide, welch_average, normfaktor);
 %          totalpsd=zeros(length(IncludedAnimals),length(IncludedParad),5,32,2049);     
           totalpsd(animal_i,paradigm_i,1,str2num(aktuelle_datei{1, 1}(8:9))+1,:)=welch_trial_average_striatum;
           totalpsd(animal_i,paradigm_i,2,str2num(aktuelle_datei{1, 1}(8:9))+1,:)=welch_trial_average_striatumall;
           totalpsd(animal_i,paradigm_i,3,str2num(aktuelle_datei{1, 1}(8:9))+1,:)=welch_trial_average_snr;
           totalpsd(animal_i,paradigm_i,4,str2num(aktuelle_datei{1, 1}(8:9))+1,:)=welch_trial_average_snrall;
           totalpsd(animal_i,paradigm_i,5,str2num(aktuelle_datei{1, 1}(8:9))+1,:)=welch_trial_average_m1 ;%cave:not normalized!
                
                
%                     subplot(3,6,datei_i)
% 
%                     mygca(datei_i) = gca;
% 
%                     plot(welch_freq,welch_average(:,:))
%                       title(aktuelle_datei{1,1}(1:15), 'Interpreter', 'none', 'FontSize', 8)  
%                       xlabel('Frequency [Hz]', 'FontSize', 8)
%                       ylabel('Power [a.u.]', 'FontSize', 8)
% 
%         
% 
%                     peakdetect_lower=15;
%                     peakdetect_upper=45;
% 
%               try
% 
%                     [pks,locs] = findpeaks(welch_average_norm);
%                     if isempty((welch_freq(locs(welch_freq(locs)>peakdetect_lower & welch_freq(locs)<peakdetect_upper))))==0
% 
%                     peaks_locs{datei_i}=(welch_freq(locs(welch_freq(locs)>peakdetect_lower & welch_freq(locs)<peakdetect_upper)));
%                     peaks_height{datei_i}=(pks(find((welch_freq(locs)>peakdetect_lower & welch_freq(locs)<peakdetect_upper))));
%                      hold on
%                      scatter(cell2mat(peaks_locs(datei_i)),cell2mat(peaks_height(datei_i))); 
%                      hold off
%                     end
%                     
%               catch
%               end
%                     drawnow
                    clearvars welch welch_average normfaktor welch_average_norm tier paradigm normfaktor ...
                        norm_index_unten2 norm_index_unten1 norm_index_oben2 norm_index_oben1 i daten data cfg ...
                        artifact_low welch_trial_average_m1 welch_trial_average_snr welch_trial_average_snrall ...
                        welch_trial_average_striatum welch_trial_average_striatumall goodsnrchannels goodstriatumchannels
            end
% 
%              set(mygca, 'Xlim', [4 65])
%              set(mygca, 'XTick', 5:10:65)
%              set(mygca, 'Ylim', [0 1.5])   % 1.5
%              set(mygca, 'XMinorGrid', 'on')
%              set(mygca, 'YGrid', 'on')
% try
%             for i=1:length(peaks_locs)
%                 date_peaks_locs{i}=ones(length(peaks_locs{i}),1)*i;
%             end
% %             save([cd '\' datestr(datetime('now'),  'yymmdd', 2000) '\' Liste{1}(1:end-9) 'peaks.mat'], 'date_peaks_locs', 'peaks_locs') 
%             [date_peaks_locs]=cell2mat(date_peaks_locs(:));
%             [peaks_locs]=cell2mat(peaks_locs(:));
% 
% 
% 
%              subplot(3,6,17:18)
%              hold on
%                 scatter(date_peaks_locs,peaks_locs)
%                 xlim([0 length(Liste)])
%                 ylim([peakdetect_lower peakdetect_upper])
%                 set(gca, 'XTick', 1:1:length(Liste))
%                 hold off
%                 set(gca, 'YTick', peakdetect_lower:2:peakdetect_upper)
%               hold off
% catch
% end
              
           
    end
end
cd(aktuellerordner)
save totalpsd_reref31_normeverytrial totalpsd welch_freq

clearvars -except totalpsd welch_freq 

for channel_i=1:5
    for paradigm_i=1:3
        myfig=figure('Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
        title(['Paradigma: ' num2str(paradigm_i) ' / ChannelID: ' num2str(channel_i)])
        for animal_i=1:5
        subplot(2,3,animal_i)
        mycolormap=jet(size(totalpsd,4));
        for timepoint=[1 4:size(totalpsd,4)]
            hold on
                plot(welch_freq,squeeze(totalpsd(animal_i,paradigm_i,channel_i,timepoint,:)), 'Color', mycolormap(timepoint,:))
            hold off
        end
            set(gca, 'Xlim', [5 65])
            set(gca, 'XTick', 5:5:65)
            set(gca, 'Ylim', [0 1])   % 1.5
            set(gca, 'XMinorGrid', 'on')
            set(gca, 'YGrid', 'on')
            %title(aktuelle_datei{1,1}(1:15), 'Interpreter', 'none', 'FontSize', 8)  
            xlabel('Frequency [Hz]', 'FontSize', 8)
            ylabel('Power [a.u.]', 'FontSize', 8)
        end
        subplot(2,3,6)
        for timepoint=[1 4:size(totalpsd,4)]
            hold on
                plot(welch_freq,squeeze(nanmean(totalpsd(:,paradigm_i,channel_i,timepoint,:),1)), 'Color', mycolormap(timepoint,:))
            hold off
        end
            set(gca, 'Xlim', [5 65])
            set(gca, 'XTick', 5:5:65)
            set(gca, 'Ylim', [0 1])   % 1.5
            set(gca, 'XMinorGrid', 'on')
            set(gca, 'YGrid', 'on')
            %title(aktuelle_datei{1,1}(1:15), 'Interpreter', 'none', 'FontSize', 8)  
            xlabel('Frequency [Hz]', 'FontSize', 8)
            ylabel('Power [a.u.]', 'FontSize', 8)
            saveas(myfig,['Parad0' num2str(paradigm_i) '_chantype0' num2str(channel_i) '.png'])
            savefig(myfig, ['Parad0' num2str(paradigm_i) '_chantype0' num2str(channel_i)])
            close(myfig)
    end
end
%cd('F:\Auswertung\FINAL180416\M1_powerpsd')
%saveallopenfigures