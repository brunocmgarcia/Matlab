%% s190102_visualizeAIMscores

clear all
close all
clc
load VAR_Global_AIM_matrix

TP=[1 2 3 4 5 7 8]; % = TP101 104 110 116 121 300 400
zeitstrahl=[0 5 20 30 40 60 80 100 120 140 160 180];
animals=[1 3 4 5 7]; % CG4 678 10
%animals=[2 5]; % nonresponders
%animals=[1 2 3 4 5 6 7]; % all

farbe=parula(length(TP));
figure('units','normalized','Position', [0 0 1 1])
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
colorbar('Ticks', (1/length(TP)/2):(1/length(TP)):1,'TickLabels',{'l-dopa 1','l-dopa 4','l-dopa 10','l-dopa 16','l-dopa 21','l-dopa + raclopride', 'l-dopa + halobenzazepine'})
xlabel('time post L-Dopa injection [min]')
xticklabels({'0','5','20','30','40','60','80','100','120','140','160','180'})
xticks(zeitstrahl)
ylabel('Global AIM score')
title('Global AIM score ± SEM') 
hold off

figure('units','centimeters','InnerPosition', [10 10 6.9 4.3])
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
errorbar([1:size(meanTP,1)],mean(meanTP(:,6:9),2), zeros(size(meanTP,1),1),(mean(stdTP(:,6:9),2)),'.', 'Color', 'k')
hold off
xticklabels({'','L-Dopa 01','L-Dopa 04','L-Dopa 10','L-Dopa 16','L-Dopa 21','AntA', 'AntB'})
ylabel('Global AIM score')
title('Global AIM score ± STD') 

for_stats=squeeze(mean(GlobalAIMmatrix(animals,(6:9),TP),2));
AIMforcorrelation=GlobalAIMmatrix(animals,[2 3 5:12],TP);

cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/180/TFRsWithNaN/fooofed/MAT_processed')
load results
load VAR_wanted181129
wantedTP=TP;
wantedTPindex=find(wantedTP>5);
wantedTP(wantedTPindex)=wantedTP(wantedTPindex)-1;
wanted=wanted(wantedTP,animals);


p=results.masterpeakpowerlogBL;
for i=1:size(wanted,1)
powerforcorrelation(:,:,i)=p(wanted(i,:),:); % tier x zeit x TP
end

backupAIMforcorrelation=AIMforcorrelation;
backuppowerforcorrelation=powerforcorrelation;

% AIMforcorrelation=AIMforcorrelation(:,4:7,:);
% powerforcorrelation=powerforcorrelation(:,4:7,:);

AIMforcorrelation=AIMforcorrelation(:);
powerforcorrelation=powerforcorrelation(:);

% excludeVals=find(AIMforcorrelation<=0);
% powerforcorrelation(excludeVals)=[];
% AIMforcorrelation(excludeVals)=[];
% excludeVals=find(powerforcorrelation<=0);
% powerforcorrelation(excludeVals)=[];
% AIMforcorrelation(excludeVals)=[];



linearregression(AIMforcorrelation,powerforcorrelation,'global AIM','gamma power',1)

for i=1:length(TP)
    AIMforcorrelation=backupAIMforcorrelation(:,:,i);
    powerforcorrelation=backuppowerforcorrelation(:,:,i);
    AIMforcorrelation=AIMforcorrelation(:);
    powerforcorrelation=powerforcorrelation(:);

%     excludeVals=find(AIMforcorrelation<=0);
%     powerforcorrelation(excludeVals)=[];
%     AIMforcorrelation(excludeVals)=[];
%     excludeVals=find(powerforcorrelation<=0);
%     powerforcorrelation(excludeVals)=[];
%     AIMforcorrelation(excludeVals)=[];



    [r2_1(i) r2_2(i) pR(i) pP(i) sR(i) sP(i)]=linearregression(AIMforcorrelation,powerforcorrelation,'global AIM','gamma power',0);
end

figure 
bar(pR)
xticklabels({'L-Dopa 01','L-Dopa 04','L-Dopa 10','L-Dopa 16','L-Dopa 21','AntA', 'AntB'})
ylabel('spearman rho')
title('spearmans rho over time') 

figure

hold on
scatter(reshape(backupAIMforcorrelation(:,:,1:5),[],1),reshape(backuppowerforcorrelation(:,:,1:5),[],1),30,'black')
scatter(reshape(backupAIMforcorrelation(:,:,6),[],1),reshape(backuppowerforcorrelation(:,:,6),[],1),30,'red')
scatter(reshape(backupAIMforcorrelation(:,:,7),[],1),reshape(backuppowerforcorrelation(:,:,7),[],1),30,'green')
hold off
legend({'L-Dopa','racloprid', 'halobenzazepine'})
xlabel('Global AIM')
ylabel('FTG Power')
title('L-Dopa vs Antagonists') 

%% mit freq
figure

hold on
load VAR_centerofmasspeakfreqs
for i=1:size(wanted,1)
testfreq(:,:,i)=f(wanted(i,:),:);
end
normalisation=nanmean(testfreq(:,4:7,1),2); % 50-130min freq der ersten ldopa injection für jedes tier
% normalisation=min(min(testfreq(:,:,:),[],2),[],3);
% normalisation=80;
testfreq=testfreq-normalisation;

scatter(reshape(backupAIMforcorrelation(:,4:7,1:5),[],1),reshape(testfreq(:,4:7,1:5),[],1),30,'black')
scatter(reshape(backupAIMforcorrelation(:,4:7,6),[],1),reshape(testfreq(:,4:7,6),[],1),30,'red')
scatter(reshape(backupAIMforcorrelation(:,4:7,7),[],1),reshape(testfreq(:,4:7,7),[],1),30,'green')

hold off
legend({'L-Dopa','racloprid', 'halobenzazepine'})

xlabel('Global AIM')
ylabel('Frequency Verschiebung [Hz]')
title('AIM vs frequency') 

linearregression(reshape(backupAIMforcorrelation(:,4:7,1:7),[],1),(reshape(testfreq(:,4:7,1:7),[],1)),'Global AIM','Frequency Verschiebung [Hz]',1)


figure
hold on
load VAR_centerofmasspeakfreqs
for i=1:size(wanted,1)
testfreq(:,:,i)=f(wanted(i,:),:);
end
normalisation=nanmean(testfreq(:,4:7,1),2);% 50-130min freq der ersten ldopa injection für jedes tier
% normalisation=min(min(testfreq(:,:,:),[],2),[],3);
% normalisation=80;
testfreq=testfreq-normalisation;
scatter(reshape(backupAIMforcorrelation(:,:,1:5),[],1),reshape(testfreq(:,:,1:5),[],1).*reshape(backuppowerforcorrelation(:,:,1:5),[],1),30,'black')
scatter(reshape(backupAIMforcorrelation(:,:,6),[],1),reshape(testfreq(:,:,6),[],1).*reshape(backuppowerforcorrelation(:,:,6),[],1),30,'red')
scatter(reshape(backupAIMforcorrelation(:,:,7),[],1),reshape(testfreq(:,:,7),[],1).*reshape(backuppowerforcorrelation(:,:,7),[],1),30,'green')
hold off
legend({'L-Dopa','racloprid', 'halobenzazepine'})
ylabel('Frequency Verschiebung x power')
xlabel('Global AIM')
title('L-Dopa vs Antagonists') 

linearregression(reshape(backupAIMforcorrelation(:,:,1:7),[],1),(reshape(testfreq(:,:,1:7),[],1)).*(reshape(backuppowerforcorrelation(:,:,1:7),[],1)),'Global AIM','Frequency Verschiebung x power',1)

