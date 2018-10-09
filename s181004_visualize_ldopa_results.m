clear all
clc
load results
load VAR_wanted181004
%wanted=wanted';
%wanted=wanted(:,[1 3 4 5 7]);

p=results.masterpeakpowerlogBL;
x=1:size(p,2);
farben=parula(size(wanted,1));
figure
subplot(1,2,2)
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
title('Mean of all animals ± SEM of FTG') 

hold off
subplot(1,2,1)
b=bar(squeeze(nanmean(test(:,4:7,:),2)), 'Grouped','FaceColor','g');
ylim([-.5 25])
xticklabels({'CG04','CG05','CG06','CG07','CG08','CG09','CG10'})
xlabel('animal #')
ylabel('AUC fooofed log10(Power) - basline, 70-130 Hz')
title('Mean of FTG power 50-130min post injection')  

for i=1:5
b(i).FaceColor = farben(i,:);
end
legend({'L-Dopa 01','L-Dopa 04','L-Dopa 10','L-Dopa 16','L-Dopa 21'})

