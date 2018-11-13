clear all
close all

tiere=['CG04';'CG05';'CG06';'CG07';'CG08';'CG09';'CG10'];
for jj=1:7
figure('name',tiere(jj,:))
cd('/Users/guettlec/Desktop/downsampled_reref_m1/pwelch')
ordner=dir('*.mat');
files={ordner.name}';
wanted=find(contains(files, 'postLD180'));
files=files(wanted);
wanted=find(contains(files, tiere(jj,:)));
files=files(wanted); 


 farben=parula(length(files));
for i=1:length(files)
    file=files(i);
    file=file{:}
    
   
    
   load(file);
   firstfifteenmin=median(pxx(1:450,:),1);
   
   sixtytoeighty=(pxx(1801:2250,:));
   
%    
%    
%    
%    sixtytoeighty=sixtytoeighty./firstfifteenmin;
%    [maxvalues, maxfreq]=max(sixtytoeighty(:,[42:65])');
%    maxfreq=welch_freq(42+maxfreq);
%    
%    finalfreq(i)=median(maxfreq);
%    finalval(i)=median(maxvalues);
    
%    figure
    
    hold on
%    subplot(2,1,1)
    plot(welch_freq,median(sixtytoeighty) , 'Color', farben(i,:))
    ylim([0 1.5e8])
xlim([0 150])
    hold off
%    hold on
%    subplot(2,1,2)
%    plot(welch_freq, firstfifteenmin, 'Color', farben(i,:))
%    ylim('auto')
%xlim([0 150])
%    
%    hold off
%    ylim([0 40])
    clearvars -except i files finalfreq finalval farben tiere jj
end
end
