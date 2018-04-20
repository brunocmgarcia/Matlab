%%s180301_run_pwelch_over_appended_trials_STR 
% THETA FOKUS
% 
% 
clear all
%close all
Liste=dir('*CG04*LB20*');
Liste={Liste.name}';
figure
for datei_i=1:length(Liste)
    
    aktuelle_datei=Liste(datei_i);
    load(aktuelle_datei{:})
    
    cfg=[];
    cfg.demean='yes';
    cfg.reref='yes';
    cfg.refchannel = 31;
    cfg.refmethod='avg';
    
    data=ft_preprocessing(cfg,data);
    
    
    %data=specialreref(data);
    
    
    
%     cfg=[];
%     cfg.resamplefs=500;
%     data=ft_resampledata(cfg,data);
     cfg=[];
        cfg.length=0.9;
        data = ft_redefinetrial(cfg, data);

         for i=1:length(data.trial) 
            welch(:,:,i)=(data.trial{1,i}([1:15],:)')/800;
            %[pxx(:,:,i), welch_freq(:,1)]=pmtm(welch(:,:,i),[],[],2000);
            %[pxx(:,:,i), welch_freq(:,1)]=pwelch(welch(:,:,i), [], [], [], data.fsample);  % mit hamming(auto) 
            [pxx(:,:,i), welch_freq(:,1)]=(pwelch(welch(:,:,i), hanning(450), [], 2048, 500, 'psd'));  % mit hanning statt hamming
            
        end

        welch=pxx;
        clearvars pxx
        welch_average=mean(welch,3);
        
%         h=s171109_normalizegame(welch_average, welch_freq)
%     uiwait(h)
%       
    

    [c norm_index_unten1] = min(abs(welch_freq-1));
    [c norm_index_oben1] = min(abs(welch_freq-4));
    clearvars c
    
    [c norm_index_unten2] = min(abs(welch_freq-12));
    [c norm_index_oben2] = min(abs(welch_freq-15));
    clearvars c
    
    normfaktor=mean(welch_average([norm_index_unten1:norm_index_oben1 norm_index_unten2:norm_index_oben2],:));
    
    
    
    
    welch_average_norm= bsxfun(@rdivide, welch_average, normfaktor);
        welch_average=(welch_average_norm);
      
        subplot(3,5,datei_i)
      
        mygca(datei_i) = gca;
        %figure('NumberTitle', 'off', 'Name', aktuelle_datei{:});
        if datei_i==1
            baseline=welch_average;
            %welch_average=welch_average./baseline;
            total_average=welch_average;
        else
        %welch_average=welch_average./baseline;
        total_average=cat(3,total_average,welch_average);
        end
        plot(welch_freq,welch_average(:,:))
          title(aktuelle_datei{1,1}(1:15), 'Interpreter', 'none', 'FontSize', 8)  
          xlabel('Frequency [Hz]', 'FontSize', 8)
          ylabel('Power [a.u.]', 'FontSize', 8)

%         xlim([8 90])
%         ylim([0 5])
        drawnow
    
        clearvars -except Liste datei_i total_average baseline mygca total_average2 total_average4
end

 set(mygca, 'Xlim', [2 15])
 set(mygca, 'XTick', 2:2:15)
 set(mygca, 'Ylim', [0 6])
 set(mygca, 'XMinorGrid', 'on')
 set(mygca, 'YGrid', 'on')