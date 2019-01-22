%% stand: 4:7 und center of mass frequencys aus 181218_LDopa_PeakFreqGaussParams

clear all
clc
close all
cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/180/TFRsWithNaN/fooofed/MAT_processed')
load results
load VAR_wanted181129

%wanted=wanted(1:5,:);
set(0, 'DefaultTextInterpreter', 'none')

%wanted=wanted';
wanted=wanted(:,[1 3 4 5 7]);
xachsentiere={'CG04','CG06','CG07','CG08','CG10'};
%wanted=wanted(:,[1 2 3 4 5 6 7]);
%xachsentiere={'CG04','CG05','CG06','CG07','CG08','CG09','CG10'};



p=results.masterpeakpowerlogBL;
%f=results.masterpeakfreq;
load VAR_centerofmasspeakfreqs
x=1:size(p,2);
farben=parula(size(wanted,1));
figure
axis tight
subplot(2,3,4:5)
colormap(farben);

hold on
for i=1:size(wanted,1)
test(:,:,i)=p(wanted(i,:),:);
mittelwert(i,:)=nanmean(test(:,:,i),1);
standardabweichung(i,:)=nanstd(test(:,:,i),1);
SEM = standardabweichung(i,:) ./ sqrt(size(wanted,2));
oben(i,:)=mittelwert(i,:)+SEM;
unten(i,:)=mittelwert(i,:)-SEM;
plot(x,mittelwert(i,:), 'Color', farben(i,:))

jbfill(x,oben(i,:),unten(i,:),farben(i,:),farben(i,:),0,0.2);


end
colorbar('Ticks', (1/size(wanted,1)/2):(1/size(wanted,1)):1,'TickLabels',{'L-Dopa 01','L-Dopa 04','L-Dopa 10','L-Dopa 16','L-Dopa 21','AntA', 'AntB'})
xlabel('time post L-Dopa injection [min]')
xticklabels({'0-10','10-30','30-50','50-70','70-90','90-110','110-130','130-150','150-170','170-180'})
xticks(1:10)
ylabel('AUC fooofed log10(Power) - basline, 70-130 Hz')
title('Mean of all animals ± SEM of FTG') 
ylim([0 15])
hold off





for i=1:size(wanted,1)
testfreq(:,:,i)=f(wanted(i,:),:);
end


subplot(2,3,2)
b=bar(squeeze(nanmean(testfreq(:,4:7,:),2)), 'Grouped','FaceColor','g');
ylim([75 135])
%xticklabels({'CG04','CG05','CG06','CG07','CG08','CG09','CG10'})
xticklabels(xachsentiere)
xlabel('animal #')
ylabel('freq [Hz]')
title('peak frequency')  

for i=1:5
b(i).FaceColor = farben(i,:);
end
legend({'L-Dopa 01','L-Dopa 04','L-Dopa 10','L-Dopa 16','L-Dopa 21','AntA', 'AntB'})



normalisation=nanmean(testfreq(:,4:7,1),2); % 50-130min freq der ersten ldopa injection für jedes tier
testfreq=testfreq-normalisation;

figure%subplot(2,3,3)
hold on

for i=1:size(wanted,1)
mittelwertfreq(i,:)=nanmean(testfreq(:,4:7,i),1); 
totalmittelwert(i)=nanmean(mittelwertfreq(i,:),2);
varianzfreq(i,:)=nanvar(testfreq(:,4:7,i),1); 
totalstd(i)=sqrt(mean(varianzfreq(i,:),2));
SEMfreq(i) = totalstd(i) ./ sqrt(size(wanted,2));
% obenfreq(i,:)=mittelwertfreq(i,:)+SEMfreq;
% untenfreq(i,:)=mittelwertfreq(i,:)-SEMfreq;
bar(i,totalmittelwert(i), 0.8,'FaceColor', 'k', 'EdgeColor', 'k')
errorbar(i,totalmittelwert(i), 0,SEMfreq(i), 'Color', 'k')
end
%ylim([87 103])
hold off
xlabel('# L-Dopa Inj.')
xticklabels({'LD 01','LD 04','LD 10','LD 16','LD 21','AntA', 'AntB'})
xticks(1:7)
ylabel('increase of peakfreq [Hz]')
title('Mean increase of peakfreq 50-130min post Injection') 

subplot(2,3,6)
colormap(farben);

hold on
for i=1:size(wanted,1)
%testfreq(:,:,i)=f(wanted(i,:),:);
mittelwertfreq(i,:)=nanmean(testfreq(:,4:7,i),1);
standardabweichungfreq(i,:)=nanstd(testfreq(:,4:7,i),1);
SEMfreq = standardabweichungfreq(i,:) ./ sqrt(length(testfreq(:,4:7,i)));
obenfreq(i,:)=mittelwertfreq(i,:)+SEMfreq;
untenfreq(i,:)=mittelwertfreq(i,:)-SEMfreq;
plot(x(4:7),mittelwertfreq(i,:), 'Color', farben(i,:))

jbfill(x(4:7),obenfreq(i,:),untenfreq(i,:),farben(i,:),farben(i,:),0,0.2);


end
colorbar('Ticks', (1/size(wanted,1)/2):(1/size(wanted,1)):1,'TickLabels',{'L-Dopa 01','L-Dopa 04','L-Dopa 10','L-Dopa 16','L-Dopa 21','AntA', 'AntB'})
xlabel('time post L-Dopa injection [min]')
xticklabels({'0-10','10-30','30-50','50-70','70-90','90-110','110-130','130-150','150-170','170-180'})
xticks(1:10)
ylabel('increase of peakfreq [Hz]')
title('Mean increase of frequency ± SEM [Hz]') 

hold off



subplot(2,3,1)
b=bar(squeeze(nanmean(test(:,4:7,:),2)), 'Grouped','FaceColor','g');
ylim([-.5 25])
%xticklabels({'CG04','CG05','CG06','CG07','CG08','CG09','CG10'})
xticklabels(xachsentiere)

xlabel('animal #')
ylabel('AUC fooofed log10(Power) - basline, 70-130 Hz')
title('Mean of FTG power 50-130min post injection')  

for i=1:5
b(i).FaceColor = farben(i,:);
end
legend({'L-Dopa 01','L-Dopa 04','L-Dopa 10','L-Dopa 16','L-Dopa 21','AntA', 'AntB'})

figure('Name', 'Average Power')
allpower=squeeze(nanmean(test(:,4:7,:),2));
allpowerstd=(sqrt(var(allpower,0,1)));%/(sqrt(length(xachsentiere)))
allpowersem=allpowerstd/(sqrt(length(xachsentiere)));
allpower=nanmean(allpower,1);
hold on
bar(allpower,'FaceColor', 'k', 'EdgeColor', 'k')
errorbar([1:size(test,3)],allpower, zeros(size(test,3),1),allpowersem,'.', 'Color', 'k')
hold off
xticklabels({'','L-Dopa 01','L-Dopa 04','L-Dopa 10','L-Dopa 16','L-Dopa 21','AntA', 'AntB'})
ylabel('AUC fooofed log10(Power) - basline, 70-130 Hz')
title('Mean of FTG power 50-130min post injection')  