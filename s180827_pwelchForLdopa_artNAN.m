%% s180827_pwelchForLdopa_artNAN


clear all
cd('/Users/guettlec/Desktop/downsampled_reref_m1')



ordner=dir('*.mat');
files={ordner.name}';
abschnittlaenge=1000; % = 2s

for i=1:length(files)
    file=files(i);
    file=file{:};
    
   
    
   load(file);
   
   cfg=[];
   cfg.artfctdef.zvalue.channel     = 1;
      cfg.artfctdef.zvalue.hilbert    = 'yes';
 cfg.artfctdef.zvalue.cutoff      = 4;
   cfg.artfctdef.zvalue.trlpadding  = 0;
   cfg.artfctdef.zvalue.artpadding  = 0.1;
   cfg.artfctdef.zvalue.fltpadding  = 0;
   % feedback
   cfg.artfctdef.zvalue.interactive = 'no';
 
   [cfg, artifact] = ft_artifact_zvalue(cfg, data);
   
   %artifact=data.time{1,1}(artifact);
   for arti_i=1:size(artifact,1)
    data.trial{1,1}(artifact(arti_i,1):artifact(arti_i,2))=nan;
   end
   
   data.trial{1,1}=data.trial{1,1}-nanmean(data.trial{1,1});
   
   
   if data.sampleinfo(2)>abschnittlaenge
   
    zaehler=0;
    passtnicht=mod((length(data.trial{1,1}-abschnittlaenge)-1),abschnittlaenge);
    for ii=1:abschnittlaenge:(length(data.trial{1,1}-abschnittlaenge)-(1+passtnicht))
        zaehler=zaehler+1;
        if ~any(isnan(data.trial{1,1}(ii:(ii+abschnittlaenge-1))))
        [pxx(zaehler,:,:), welch_freq(:,1)]=pwelch(data.trial{1,1}(ii:(ii+abschnittlaenge-1)), [], [], [], data.fsample, 'psd');  % mit hanning statt hamming
        end
    end

    pxx=squeeze(pxx);
   
   
   
    cd pwelchArtDef
    
    save([file(1:end-4) '_pWELCH_artdef.mat'],'pxx', 'welch_freq')  % function form 
    cd ..
   end
    clearvars -except i files abschnittlaenge 
end

% 
% %data.trial{1,1}(abs(data.trial{1,1})>(i*100000))=NaN;
% % figure
% % spectrogram(data.trial{1,1}, hanning(5000), 2500, 1024, 500, 'yaxis');
% 
%  % entspricht 2min
% 
% %[pxx, welch_freq]=pwelch(data.trial{1,1}(1:1000), [], [], [], data.fsample); 
% 
% b=hot(size(pxx,1));
% figure
% hold on
% zaehler=0;
% for i=1:size(pxx,1)
%    zaehler=zaehler+1;
%     plot(welch_freq, pxx(i,:), 'Color', b(zaehler,:))
% end
% hold off
% 
% figure
%  plot(welch_freq, mean(pxx,1))
% 
% 
% % spectrogram(x,window,noverlap,f,fs)
% % spectrogram(x,window,noverlap,nfft)
% % 
% % 
% % [pxx(:,:,i), welch_freq(:,1)]=pwelch(welch(:,:,i), hanning(757), [], [], data.fsample);  % mit hanning statt hamming
% % 
% % 
% % 
% 
clear all
cd('/Users/guettlec/Desktop/downsampled_reref_m1/pwelchArtDef')
ordner=dir('*.mat');
files={ordner.name}';
wanted=find(contains(files, 'postLD180'));
files=files(wanted);
wanted=find(contains(files, 'CG04'));
files=files(wanted);


for i=1:length(files)
    file=files(i);
    file=file{:}
    
   
    
   load(file);
   firstfifteenmin=median(pxx(1:450,:),1);
   sixtytoeighty=(pxx(1801:2250,:));
   
   
   
   sixtytoeighty=sixtytoeighty./firstfifteenmin;
   [maxvalues, maxfreq]=max(sixtytoeighty(:,[42:65])');
   maxfreq=welch_freq(42+maxfreq);
   
   finalfreq(i)=median(maxfreq);
   finalval(i)=median(maxvalues);
    
   figure
   hold on
   %plot(welch_freq, firstfifteenmin)
   plot(welch_freq, median(sixtytoeighty,1))
   
   hold off
   ylim([0 40])
    clearvars -except i files finalfreq finalval
end
figure
subplot(2,1,1)
plot(finalfreq)
ylim([80 120])
subplot(2,1,2)
plot(finalval)
ylim([0 50])
