%% s190123_findmaxgammapowerandtime

clear all
close all

if ~ispc
    cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/180/TFRsWithNaN')
   
else
    cd('F:/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/180//TFRsWithNaN')
  
end

if exist('GammaMax')~=7
    mkdir('GammaMax')
end

ordner=dir('*ArtCorr.mat');
files={ordner.name}';


for file_i=1:length(files)
    file=files(file_i);
    dateiname=file{:};
    load(dateiname)

    my_foi=TFRhann.freq;
    

    time=TFRhann.time';
    
    filteredTFR=squeeze(TFRhann.powspctrm);
    filteredTFR=medfilt1(filteredTFR,15,[],2,'omitnan'); 
       for i=1:size(filteredTFR,2)
            maxpoweringamma(i)=(max(max(filteredTFR(80:130,i),2)));
       end
      
           
       filteredmaxpoweringamma=medfilt1(maxpoweringamma,4000,[],2,'omitnan');
       maxfilteredmaxpoweringamma=max(filteredmaxpoweringamma);
       maxfilteredmaxpoweringamma_80=maxfilteredmaxpoweringamma*0.8;
       maxfilteredmaxpoweringamma_20=maxfilteredmaxpoweringamma*0.2;
       maxline=@(x)max(filteredmaxpoweringamma);
       fuenfundneunzigprozent=max(filteredmaxpoweringamma)*.95;
       fuenfundneunziglin=@(x)fuenfundneunzigprozent;
       zwanziglin=@(x)maxfilteredmaxpoweringamma_20;
       achziglin=@(x)maxfilteredmaxpoweringamma_80;        
      crossing20=(filteredmaxpoweringamma-maxfilteredmaxpoweringamma_20);
      crossing20(crossing20<0)=0;
      crossing20=find(crossing20,1);
      
    crossing80=(filteredmaxpoweringamma-maxfilteredmaxpoweringamma_80);
      crossing80(crossing80<0)=0;
      crossing80=find(crossing80,1);
     
     
      
      risetimeline=@(x)((filteredmaxpoweringamma(crossing80)-filteredmaxpoweringamma(crossing20))/(crossing80-crossing20))*x+(((crossing80*filteredmaxpoweringamma(crossing20))-(crossing20*filteredmaxpoweringamma(crossing80)))/(crossing80-crossing20));
       
      
       subtractedfilteredmaxpoweringamma=filteredmaxpoweringamma;
     subtractedfilteredmaxpoweringamma(filteredmaxpoweringamma<fuenfundneunzigprozent)=NaN;
     peakstart=find(filteredmaxpoweringamma>fuenfundneunzigprozent,1,'first');
     peakend=find(filteredmaxpoweringamma(peakstart:end)<fuenfundneunzigprozent,1,'first')+peakstart;
     peaktime=find(filteredmaxpoweringamma(peakstart:peakend)==max(filteredmaxpoweringamma(peakstart:peakend)),1,'first')+peakstart;
     peakline=@(x)max(filteredmaxpoweringamma(peakstart:peakend));
     figure('Units','Normalized','Position',[0 0 1 1])
     hold on
     plot(maxpoweringamma,'Color',[.5 .5 .5])
     plot(filteredmaxpoweringamma,'r')
     fplot(maxline,[1 length(maxpoweringamma)],'k')
     fplot(fuenfundneunziglin,[1 length(maxpoweringamma)],'k')
     fplot(zwanziglin,[1 length(maxpoweringamma)],'k')
     fplot(achziglin,[1 length(maxpoweringamma)],'k')
     plot([crossing20 crossing20], get(gca,'ylim'),'k')
      plot([crossing80 crossing80], get(gca,'ylim'),'k')
          fplot(risetimeline,[crossing20 crossing80],'b')

     
    
    fplot(peakline,[1 length(maxpoweringamma)],'b')
     plot([peaktime peaktime],get(gca,'ylim'),'b')
    text(1,.8,[ ...
        'peakpower: ' num2str(max(filteredmaxpoweringamma(peakstart:peakend)),4) char(10) ...
        'peaktime: ' num2str(time(peaktime)/60) 'min' char(10) ...
        'riseslope: ' num2str((filteredmaxpoweringamma(crossing80)-filteredmaxpoweringamma(crossing20))/(crossing80-crossing20)) char(10) ...
        'risetime: ' num2str(time(crossing80-crossing20)/60) 'min'...
        ],'Units','Normalized')
    
     hold off
     xticks([1:(length(time)/10):(length(time)) length(time)])
     xticklabels(string(num2str(([time(1:(length(time)/10):end); time(end)])/60)))
     ylim([0 5e8])
     saveas(gca,[cd '/GammaMax/' dateiname(1:10) '.tif'])
     savefig([cd '/GammaMax/' dateiname(1:10) '.fig'])
     GammaMax.time(file_i,1)=time(peaktime)/60;
     GammaMax.pow(file_i,1)=max(filteredmaxpoweringamma(peakstart:peakend));
     GammaMax.slope(file_i,1)=((filteredmaxpoweringamma(crossing80)-filteredmaxpoweringamma(crossing20))/(crossing80-crossing20));
     GammaMax.risetime(file_i,1)=time(crossing80-crossing20)/60;
     close all
     clearvars -except GammaMax file_i files
end

save([cd '/GammaMax/GammaMax.mat'],'GammaMax')
load VAR_wanted181129

%wanted=wanted(1:5,:);
set(0, 'DefaultTextInterpreter', 'none')

%wanted=wanted';
wanted=wanted(:,[1 3 4 5 7]);
xachsentiere={'CG04','CG06','CG07','CG08','CG10'};



for i=1:size(wanted,1)
test(:,i)=GammaMax.pow(wanted(i,:));
end

figure('Name', 'Max Power')
allpower=nanmean(test,1);
allpowerstd=(sqrt(var(test,1)));
allpowersem=allpowerstd/(sqrt(length(xachsentiere)));

hold on
bar(allpower,'FaceColor', 'k', 'EdgeColor', 'k')
errorbar([1:size(test,2)],allpower, zeros(size(test,2),1),allpowersem,'.', 'Color', 'k')
hold off
xticklabels({'','L-Dopa 01','L-Dopa 04','L-Dopa 10','L-Dopa 16','L-Dopa 21','AntA', 'AntB'})
ylabel('max gamma [a.u.]')
title('Max FTG power')  

clearvars test
for i=1:size(wanted,1)
test(:,i)=GammaMax.freq(wanted(i,:));
end

figure('Name', 'time to max power')
alltime=nanmean(test,1);
alltimestd=(sqrt(var(test,1)));
alltimesem=alltimestd/(sqrt(length(xachsentiere)));

hold on
bar(alltime,'FaceColor', 'k', 'EdgeColor', 'k')
errorbar([1:size(test,2)],alltime, zeros(size(test,2),1),alltimesem,'.', 'Color', 'k')
hold off
xticklabels({'','L-Dopa 01','L-Dopa 04','L-Dopa 10','L-Dopa 16','L-Dopa 21','AntA', 'AntB'})
ylabel('time to max power [min]')
title('time to max power')  
clearvars test
