clear all
clc
cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/180/TFRsWithNaN/fooofed/MAT_processed')
load results
load VAR_wanted181004
%wanted=wanted';
wanted=wanted(:,[1 3 4 5 7]);

p=results.masterpeakpowerlogBL;
f=results.masterpeakfreq;
x=1:size(p,2);
farben=parula(size(wanted,1));
figure
axis tight
subplot(2,3,4)
colormap(farben);

hold on
for i=1:size(wanted,1)
test(:,:,i)=p(wanted(i,:),:);
mittelwert(i,:)=nanmean(test(:,:,i),1);
standardabweichung(i,:)=nanstd(test(:,:,i),1);
SEM = standardabweichung(i,:) ./ sqrt(length(test(:,:,i)));
oben(i,:)=mittelwert(i,:)+SEM;
unten(i,:)=mittelwert(i,:)-SEM;
plot(x,mittelwert(i,:), 'Color', farben(i,:))

jbfill(x,oben(i,:),unten(i,:),farben(i,:),farben(i,:),0,0.2);


end
colorbar('Ticks', 0.1:0.2:1,'TickLabels',{'L-Dopa 01','L-Dopa 04','L-Dopa 10','L-Dopa 16','L-Dopa 21'})
xlabel('time post L-Dopa injection [min]')
xticklabels({'0-10','10-30','30-50','50-70','70-90','90-110','110-130','130-150','150-170','170-180'})
xticks(1:10)
ylabel('AUC fooofed log10(Power) - basline, 70-130 Hz')
title('Mean of all animals � SEM of FTG') 

hold off




for i=1:size(wanted,1)
testfreq(:,:,i)=f(wanted(i,:),:);
end


subplot(2,3,2)
b=bar(squeeze(nanmean(testfreq(:,4:7,:),2)), 'Grouped','FaceColor','g');
ylim([75 113])
%xticklabels({'CG04','CG05','CG06','CG07','CG08','CG09','CG10'})
xticklabels({'CG04','CG06','CG07','CG08','CG10'})
xlabel('animal #')
ylabel('freq [Hz]')
title('peak frequency')  

for i=1:5
b(i).FaceColor = farben(i,:);
end
legend({'L-Dopa 01','L-Dopa 04','L-Dopa 10','L-Dopa 16','L-Dopa 21'})



normalisation=nanmean(testfreq(:,4:7,1),2); % 50-130min freq der ersten ldopa injection für jedes tier
testfreq=testfreq-normalisation;

subplot(2,3,6)
hold on

for i=1:size(wanted,1)
mittelwertfreq(i,:)=nanmean(testfreq(:,4:7,i),1); 
totalmittelwert(i)=nanmean(mittelwertfreq(i,:),2);
varianzfreq(i,:)=nanvar(testfreq(:,4:7,i),1); 
totalstd(i)=sqrt(mean(varianzfreq(i,:),2));
SEMfreq(i) = totalstd(i) ./ sqrt(7);
% obenfreq(i,:)=mittelwertfreq(i,:)+SEMfreq;
% untenfreq(i,:)=mittelwertfreq(i,:)-SEMfreq;
bar(i,totalmittelwert(i), 0.4,'FaceColor', 'k', 'EdgeColor', 'k')
errorbar(i,totalmittelwert(i), 0,SEMfreq(i), 'Color', 'k')
end
%ylim([87 103])
hold off
xlabel('# L-Dopa Inj.')
xticklabels({'L-Dopa 01','L-Dopa 04','L-Dopa 10','L-Dopa 16','L-Dopa 21'})
xticks(1:5)
ylabel('freq [Hz]')
title('Mean increase of peakfreq 50-130min post Injection') 

subplot(2,3,5)
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
colorbar('Ticks', 0.1:0.2:1,'TickLabels',{'L-Dopa 01','L-Dopa 04','L-Dopa 10','L-Dopa 16','L-Dopa 21'})
xlabel('time post L-Dopa injection [min]')
xticklabels({'0-10','10-30','30-50','50-70','70-90','90-110','110-130','130-150','150-170','170-180'})
xticks(1:10)
ylabel('freq [Hz]')
title('Mean increase of frequency ± SEM [Hz]') 

hold off



subplot(2,3,1)
b=bar(squeeze(nanmean(test(:,4:7,:),2)), 'Grouped','FaceColor','g');
ylim([-.5 25])
%xticklabels({'CG04','CG05','CG06','CG07','CG08','CG09','CG10'})
xticklabels({'CG04','CG06','CG07','CG08','CG10'})

xlabel('animal #')
ylabel('AUC fooofed log10(Power) - basline, 70-130 Hz')
title('Mean of FTG power 50-130min post injection')  

for i=1:5
b(i).FaceColor = farben(i,:);
end
legend({'L-Dopa 01','L-Dopa 04','L-Dopa 10','L-Dopa 16','L-Dopa 21'})




