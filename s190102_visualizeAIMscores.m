%% s190102_visualizeAIMscores

clear all
close all
clc
load VAR_Global_AIM_matrix

TP=[1 2 3 4 5 7 8]; % = TP101 104 110 116 121 300 400
zeitstrahl=[0 5 20 30 40 60 80 100 120 140 160 180];
%animals=[1 3 4 7]; % responders
animals=[1 2 3 4 5 6 7]; % all

farbe=parula(length(TP));
figure
axis tight
colormap(farbe);
hold on
for i=1:length(TP)
meanTP(i,:)=    mean(GlobalAIMmatrix(animals,:,TP(i)),1);
stdTP(i,:)=    std(GlobalAIMmatrix(animals,:,TP(i)),1);
SEMTP(i,:)= stdTP(i,:)./sqrt(length(animals));
plot(zeitstrahl,meanTP(i,:),'Color',farbe(i,:));
oben(i,:)=meanTP(i,:)+SEMTP(i,:);
unten(i,:)=meanTP(i,:)-SEMTP(i,:);
jbfill(zeitstrahl,oben(i,:),unten(i,:),farbe(i,:),farbe(i,:),0,0.2);
end
colorbar('Ticks', (1/length(TP)/2):(1/length(TP)):1,'TickLabels',{'L-Dopa 01','L-Dopa 04','L-Dopa 10','L-Dopa 16','L-Dopa 21','AntA', 'AntB'})
xlabel('time post L-Dopa injection [min]')
xticklabels({'0','5','20','30','40','60','80','100','120','140','160','180'})
xticks(zeitstrahl)
ylabel('Global AIM score')
title('Global AIM score ± SEM') 
hold off

figure
hold on
bar(mean(meanTP(:,6:9),2),'FaceColor', 'k', 'EdgeColor', 'k')
errorbar([1:size(meanTP,1)],mean(meanTP(:,6:9),2), zeros(size(meanTP,1),1),mean(SEMTP(:,6:9),2),'.', 'Color', 'k')
hold off
xticklabels({'','L-Dopa 01','L-Dopa 04','L-Dopa 10','L-Dopa 16','L-Dopa 21','AntA', 'AntB'})
ylabel('Global AIM score')
title('Global AIM score ± SEM') 

%%

figure
axis tight
colormap(farbe);
hold on
for i=1:length(TP)
meanTP(i,:)=    mean(GlobalAIMmatrix(animals,:,TP(i)),1);
stdTP(i,:)=    std(GlobalAIMmatrix(animals,:,TP(i)),1);
SEMTP(i,:)= stdTP(i,:)./sqrt(length(animals));
plot(zeitstrahl,meanTP(i,:),'Color',farbe(i,:));
oben(i,:)=meanTP(i,:)+stdTP(i,:);
unten(i,:)=meanTP(i,:)-stdTP(i,:);
jbfill(zeitstrahl,oben(i,:),unten(i,:),farbe(i,:),farbe(i,:),0,0.2);
end
colorbar('Ticks', (1/length(TP)/2):(1/length(TP)):1,'TickLabels',{'L-Dopa 01','L-Dopa 04','L-Dopa 10','L-Dopa 16','L-Dopa 21','AntA', 'AntB'})
xlabel('time post L-Dopa injection [min]')
xticklabels({'0','5','20','30','40','60','80','100','120','140','160','180'})
xticks(zeitstrahl)
ylabel('Global AIM score')
title('Global AIM score ± STD') 
hold off

figure
hold on
bar(mean(meanTP(:,6:9),2),'FaceColor', 'k', 'EdgeColor', 'k')
errorbar([1:size(meanTP,1)],mean(meanTP(:,6:9),2), zeros(size(meanTP,1),1),mean(stdTP(:,6:9),2),'.', 'Color', 'k')
hold off
xticklabels({'','L-Dopa 01','L-Dopa 04','L-Dopa 10','L-Dopa 16','L-Dopa 21','AntA', 'AntB'})
ylabel('Global AIM score')
title('Global AIM score ± STD') 

for_stats=squeeze(mean(GlobalAIMmatrix(animals,(6:9),TP),2));
%linearregression(masterpeakfreq,masterpeakpowerlogBL,'freq [Hz]','gamma power')

