%%s180227_run_pwelch_over_appended_trials (from folder trialapppend)
% TODO: normlaize über angezeigte frequenzen sowie auslassung beta. 5-15
% und 40-65...
% CAVE: NUR FÜR M1 FUNKTIONIERT DAS HIER GUT
clearvars -except 
%close all

if exist(datestr(datetime('now'),  'yymmdd', 2000)) ~= 7
    mkdir(datestr(datetime('now'),  'yymmdd', 2000))
end
    

exist('180301')
    
Liste=dir('*CG04*Ruhe*');
Liste={Liste.name}';

figure
for datei_i=1:length(Liste)
    
    aktuelle_datei=Liste(datei_i);
    load(aktuelle_datei{:})
    
   
               
    
    cfg=[];
    cfg.demean='yes';
    cfg.reref='yes';
    cfg.refchannel=31;
    cfg.refmethod='avg';
    
    data=ft_preprocessing(cfg,data);
    
    
     cfg=[];
                 cfg.artfctdef.zvalue.channel     = 30;
               cfg.artfctdef.zvalue.cutoff      = 2;
               cfg.artfctdef.zvalue.trlpadding  = 0;
               cfg.artfctdef.zvalue.artpadding  = 1;
               cfg.artfctdef.zvalue.fltpadding  = 0;

               % algorithmic parameters
               cfg.artfctdef.zvalue.bpfilter   = 'yes';
               cfg.artfctdef.zvalue.bpfilttype = 'but';
               cfg.artfctdef.zvalue.bpfreq     = [1 12];
               cfg.artfctdef.zvalue.bpfiltord  = 4;
               cfg.artfctdef.zvalue.hilbert    = 'yes';

               % feedback
               cfg.artfctdef.zvalue.interactive = 'no';

               [cfg, artifact_low] = ft_artifact_zvalue(cfg, data);
               cfg.artfctdef.reject = 'partial';
               data=ft_rejectartifact(cfg,data);
    
    %data=specialreref(data);
    
    
    
%     cfg=[];
%     cfg.resamplefs=500;
%     data=ft_resampledata(cfg,data);
     cfg=[];
        cfg.length=0.9;
        data = ft_redefinetrial(cfg, data);  
        
        
       
%%
         for i=1:length(data.trial) 
            welch(:,:,i)=(data.trial{1,i}(30,:)')/800;
            %[pxx(:,:,i), welch_freq(:,1)]=pmtm(welch(:,:,i),[],[],2000);
            %[pxx(:,:,i), welch_freq(:,1)]=pwelch(welch(:,:,i), [], [], [], data.fsample);  % mit hamming(auto) 
            [pxx(:,:,i), welch_freq(:,1)]=(pwelch(welch(:,:,i), hanning(100), [], 2048, 500, 'power'));  % mit hanning statt hamming
            
%             normfaktor= repmat(welch_freq,1,size(pxx(:,:,i),2));
%             normfaktor=(normfaktor.^2);
%             normfaktor=1./normfaktor;
%             pxx(:,:,i)= bsxfun(@rdivide, pxx(:,:,i), normfaktor);
       
            
            
        end

        welch=pxx;
        clearvars pxx
        welch_average=mean(welch,3);
        
%         h=s171109_normalizegame(welch_average, welch_freq)
%     uiwait(h)
%       
    
% 
    [c norm_index_unten1] = min(abs(welch_freq-4));
    [c norm_index_oben1] = min(abs(welch_freq-8));
    clearvars c
    
    [c norm_index_unten2] = min(abs(welch_freq-55));
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
      
        subplot(3,5,datei_i)
      
        mygca(datei_i) = gca;
        %figure('NumberTitle', 'off', 'Name', aktuelle_datei{:});
%         if datei_i==1
%             baseline=welch_average;
% %             welch_average=welch_average./baseline;
%             total_average=welch_average;
%         else
% %         welch_average=welch_average-baseline;
%         total_average=cat(3,total_average,welch_average);
%         end
        plot(welch_freq,welch_average(:,:))
          title(aktuelle_datei{1,1}(1:14), 'Interpreter', 'none', 'FontSize', 8)  
          xlabel('Frequency [Hz]', 'FontSize', 8)
          ylabel('Power [a.u.]', 'FontSize', 8)

%         xlim([8 90])
%         ylim([0 5])
        drawnow
        [pks,locs] = findpeaks(welch_average_norm);
        if isempty((welch_freq(locs(welch_freq(locs)>13 & welch_freq(locs)<45))))==0

        peaks_locs{datei_i}=(welch_freq(locs(welch_freq(locs)>13 & welch_freq(locs)<45)));
        peaks_height{datei_i}=(pks(find((welch_freq(locs)>13 & welch_freq(locs)<45))));
         hold on
         scatter(cell2mat(peaks_locs(datei_i)),cell2mat(peaks_height(datei_i))); 
         hold off
        end
        clearvars -except LocFig Liste datei_i peaks_locs peaks_height total_average baseline mygca total_average2 total_average4 welch_freq
end

 set(mygca, 'Xlim', [4 65])
 set(mygca, 'XTick', 5:10:65)
 set(mygca, 'Ylim', [0 1.5])
 set(mygca, 'XMinorGrid', 'on')
 set(mygca, 'YGrid', 'on')
 
for i=1:length(peaks_locs)
    date_peaks_locs{i}=ones(length(peaks_locs{i}),1)*i;
end
save([cd '\' datestr(datetime('now'),  'yymmdd', 2000) '\' Liste{1}(1:end-9) 'peaks.mat'], 'date_peaks_locs', 'peaks_locs') 
[date_peaks_locs]=cell2mat(date_peaks_locs(:));
[peaks_locs]=cell2mat(peaks_locs(:));



 figure
 hold on
    scatter(date_peaks_locs,peaks_locs)
    xlim([0 length(Liste)])
    ylim([12 46])
    set(gca, 'XTick', 1:1:length(Liste))
    hold off
    set(gca, 'YTick', 12:2:46)
  hold off