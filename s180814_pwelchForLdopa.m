%% s180814_pwelchForLdopa


clear all
cd('/Users/guettlec/Desktop/downsampled_reref_m1')


clear all
ordner=dir('*.mat');
files={ordner.name}';
abschnittlaenge=1000;

for i=1:length(files)
    file=files(i);
    file=file{:};
    
   
    
   load(file);
   
   if data.sampleinfo(2)>abschnittlaenge
   
    zaehler=0;
    passtnicht=mod((length(data.trial{1,1}-abschnittlaenge)-1),abschnittlaenge);
    for ii=1:abschnittlaenge:(length(data.trial{1,1}-abschnittlaenge)-(1+passtnicht))
        zaehler=zaehler+1;
        [pxx(zaehler,:,:), welch_freq(:,1)]=pwelch(data.trial{1,1}(ii:(ii+abschnittlaenge-1)), [], [], [], data.fsample, 'psd');  % mit hanning statt hamming

    end

    pxx=squeeze(pxx);
   
   
   
    cd pwelch
    
    save([file(1:end-4) '_pWELCH.mat'],'pxx', 'welch_freq')  % function form 
    cd ..
   end
    clearvars -except i files abschnittlaenge 
end


%data.trial{1,1}(abs(data.trial{1,1})>(i*100000))=NaN;
% figure
% spectrogram(data.trial{1,1}, hanning(5000), 2500, 1024, 500, 'yaxis');

 % entspricht 2min

%[pxx, welch_freq]=pwelch(data.trial{1,1}(1:1000), [], [], [], data.fsample); 

b=hot(size(pxx,1));
figure
hold on
zaehler=0;
for i=1:size(pxx,1)
   zaehler=zaehler+1;
    plot(welch_freq, pxx(i,:), 'Color', b(zaehler,:))
end
hold off

figure
 plot(welch_freq, mean(pxx,1))


% spectrogram(x,window,noverlap,f,fs)
% spectrogram(x,window,noverlap,nfft)
% 
% 
% [pxx(:,:,i), welch_freq(:,1)]=pwelch(welch(:,:,i), hanning(757), [], [], data.fsample);  % mit hanning statt hamming
% 
% 
% 

clear all
cd('/Users/guettlec/Desktop/downsampled_reref_m1/pwelch')
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
    
%    figure
%    hold on
%    %plot(welch_freq, firstfifteenmin)
%    plot(welch_freq, sixtytoeighty)
%    
%    hold off
%    ylim([0 40])
    clearvars -except i files finalfreq finalval
end
figure
subplot(2,1,1)
plot(finalfreq)
ylim([80 120])
subplot(2,1,2)
plot(finalval)
ylim([0 50])
