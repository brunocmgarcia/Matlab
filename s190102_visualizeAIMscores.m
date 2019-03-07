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


%% standard aim visual
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
AIMforcorrelation=GlobalAIMmatrix(animals,[2 3 5:12],TP); % tiere, minuten, tage

cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/180/TFRsWithNaN/fooofed/MAT_processed')
load results
load VAR_wanted181129
wantedTP=TP;
wantedTPindex=find(wantedTP>5);
wantedTP(wantedTPindex)=wantedTP(wantedTPindex)-1;
wanted=wanted(wantedTP,animals);

load  VAR_centerofmasspeakfreqs 


p=results.masterpeakpowerlogBL;
for i=1:size(wanted,1)
powerforcorrelation(:,:,i)=p(wanted(i,:),:); % tier x zeit x TP
end

for i=1:size(wanted,1)
freqforcorrelation(:,:,i)=f(wanted(i,:),:); % tier x zeit x TP
end

backupfreqforcorrelation=freqforcorrelation;

normalisation=nanmean(freqforcorrelation(:,4:7,1),2); % 50-130min freq der ersten ldopa injection für jedes tier
% normalisation=min(min(testfreq(:,:,:),[],2),[],3);
% normalisation=100;
normfreqforcorrelation=freqforcorrelation-normalisation;


backupAIMforcorrelation=AIMforcorrelation;
backuppowerforcorrelation=powerforcorrelation;

% AIMforcorrelation=AIMforcorrelation(:,4:7,:);
% powerforcorrelation=powerforcorrelation(:,4:7,:);

AIMforcorrelation=AIMforcorrelation(:,:,1:5);
% AIMforcorrelation=log(AIMforcorrelation(:)+1-min(AIMforcorrelation(:)));% logtransform, und aufpassen das nichts negativ wird
AIMforcorrelation=AIMforcorrelation(:);

powerforcorrelation=powerforcorrelation(:,:,1:5);
% powerforcorrelation=log(powerforcorrelation(:)+1-min(powerforcorrelation(:))); % logtransform, und aufpassen das nichts negativ wird
powerforcorrelation=powerforcorrelation(:);

% excludeVals=find(AIMforcorrelation<=0);
% powerforcorrelation(excludeVals)=[];
% AIMforcorrelation(excludeVals)=[];
% excludeVals=find(powerforcorrelation<=0);
% powerforcorrelation(excludeVals)=[];
% AIMforcorrelation(excludeVals)=[];
freqforcorrelation=freqforcorrelation(:,:,1:5);
normfreqforcorrelation=normfreqforcorrelation(:,:,1:5);

% linearregression(powerforcorrelation,freqforcorrelation(:),'ftg power', 'meanfreq',1)
% hold on
% scatter(powerforcorrelation,freqforcorrelation(:),40,'o','filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[.7 .7 .7])
% 
% hold off
% ylim([80 120])
% xlim([-2 24])

linearregression(freqforcorrelation(:),powerforcorrelation, 'meanfreq','ftg power',1)
hold on
scatter(freqforcorrelation(:),powerforcorrelation,40,'o','filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[.7 .7 .7])

hold off

xlim([80 120])
ylim([0 25])

linearregression(normfreqforcorrelation(:),powerforcorrelation, 'meanfreqverschiebung','ftg power',1)
hold on
scatter(normfreqforcorrelation(:),powerforcorrelation,40,'o','filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[.7 .7 .7])

hold off
xlim([-5 25])
ylim([0 25])
title('normalizedfreqXPower')


[~, ~, ~, ~, sR_powerXAim, sP_powerXaim]=linearregression(powerforcorrelation,AIMforcorrelation,'gamma power','global AIM',1);
hold on; scatter(powerforcorrelation,AIMforcorrelation,40,'o','filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[.7 .7 .7]); hold off;

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



    [r2_1(i) r2_2(i) pR(i) pP(i) sR(i) sP(i)]=linearregression(powerforcorrelation, AIMforcorrelation,'gamma power','global AIM',0);
end

figure 
bar(sR)
rhoovertime=sP;
xticklabels({'L-Dopa 01','L-Dopa 04','L-Dopa 10','L-Dopa 16','L-Dopa 21','AntA', 'AntB'})
ylabel('spearman rho')
title('spearmans rho over time') 

%% Power vs AIM, L-dopa vs antagn. in verschiedenen Varianten

figure
hold on
scatter(reshape(backuppowerforcorrelation(:,:,1:5),[],1),reshape(backupAIMforcorrelation(:,:,1:5),[],1),20,'o','filled','MarkerFaceColor',[.7 .7 .7],'MarkerEdgeColor',[.7 .7 .7])
scatter(reshape(backuppowerforcorrelation(:,:,6),[],1),reshape(backupAIMforcorrelation(:,:,6),[],1),30,'^','k','filled')
%scatter(reshape(backuppowerforcorrelation(:,:,7),[],1),reshape(backupAIMforcorrelation(:,:,7),[],1),30,'s','k','filled')
hold off
legend({'L-Dopa','racloprid'})
ylabel('Global AIM')
xlabel('FTG Power')
title('L-Dopa vs Antagonists') 
xlim([-1.2 25])

figure
hold on
scatter(reshape(backuppowerforcorrelation(:,:,1:5),[],1),reshape(backupAIMforcorrelation(:,:,1:5),[],1),20,'o','filled','MarkerFaceColor',[.7 .7 .7],'MarkerEdgeColor',[.7 .7 .7])
%scatter(reshape(backuppowerforcorrelation(:,:,6),[],1),reshape(backupAIMforcorrelation(:,:,6),[],1),30,'^','k','filled')
scatter(reshape(backuppowerforcorrelation(:,:,7),[],1),reshape(backupAIMforcorrelation(:,:,7),[],1),30,'s','k','filled')
hold off
legend({'L-Dopa','halobenzazepine'})
ylabel('Global AIM')
xlabel('FTG Power')
title('L-Dopa vs Antagonists') 
xlim([-1.2 25])

figure
hold on
scatter(reshape(backuppowerforcorrelation(:,:,1:5),[],1),reshape(backupAIMforcorrelation(:,:,1:5),[],1),20,'o','filled','MarkerFaceColor',[.7 .7 .7],'MarkerEdgeColor',[.7 .7 .7])
scatter(reshape(backuppowerforcorrelation(:,:,6),[],1),reshape(backupAIMforcorrelation(:,:,6),[],1),30,'^','k','filled')
scatter(reshape(backuppowerforcorrelation(:,:,7),[],1),reshape(backupAIMforcorrelation(:,:,7),[],1),30,'s','k','filled')
hold off
legend({'L-Dopa','racloprid','halobenzazepine'})
ylabel('Global AIM')
xlabel('FTG Power')
title('L-Dopa vs Antagonists') 

%% AIM vs freq
figure

hold on
load VAR_centerofmasspeakfreqs
for i=1:size(wanted,1)
testfreq(:,:,i)=f(wanted(i,:),:);
end
normalisation=nanmean(testfreq(:,4:7,1),2); % 50-130min freq der ersten ldopa injection für jedes tier
% normalisation=min(min(testfreq(:,:,:),[],2),[],3);
% normalisation=80;
%testfreq=testfreq-normalisation;

scatter(reshape(testfreq(:,4:7,1:5),[],1),reshape(backupAIMforcorrelation(:,4:7,1:5),[],1),20,'o','filled','MarkerFaceColor',[.7 .7 .7],'MarkerEdgeColor',[.7 .7 .7])
scatter(reshape(testfreq(:,4:7,6),[],1),reshape(backupAIMforcorrelation(:,4:7,6),[],1),'^','k','filled')
scatter(reshape(testfreq(:,4:7,7),[],1),reshape(backupAIMforcorrelation(:,4:7,7),[],1),30,'s','k','filled')

hold off
legend({'L-Dopa','racloprid', 'halobenzazepine'})

ylabel('Global AIM')
xlabel('Frequency [Hz]')
title('AIM vs frequency') 

linearregression(reshape(testfreq(:,4:7,1:5),[],1),(reshape(backupAIMforcorrelation(:,4:7,1:5),[],1)),'Frequency [Hz]','Global AIM',1)
hold on; scatter(reshape(testfreq(:,4:7,1:5),[],1),(reshape(backupAIMforcorrelation(:,4:7,1:5),[],1)),40,'o','filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[.7 .7 .7]); hold off

%% AIM vs freqverschiebung
figure

hold on
load VAR_centerofmasspeakfreqs
for i=1:size(wanted,1)
testfreq(:,:,i)=f(wanted(i,:),:);
end
normalisation=nanmean(testfreq(:,4:7,1),2); % 50-130min freq der ersten ldopa injection für jedes tier
% normalisation=min(min(testfreq(:,:,:),[],2),[],3);
% normalisation=100;
testfreq=testfreq-normalisation;

scatter(reshape(testfreq(:,4:7,1:5),[],1),reshape(backupAIMforcorrelation(:,4:7,1:5),[],1),40,'o','filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[.7 .7 .7])
% scatter(reshape(testfreq(:,4:7,6),[],1),reshape(backupAIMforcorrelation(:,4:7,6),[],1),'^','k','filled')
% scatter(reshape(testfreq(:,4:7,7),[],1),reshape(backupAIMforcorrelation(:,4:7,7),[],1),30,'s','k','filled')

hold off
legend({'L-Dopa'})

ylabel('Global AIM')
xlabel('Frequency Verschiebung [Hz]')
title('AIM vs frequency') 

linearregression(reshape(testfreq(:,4:7,1:5),[],1),(reshape(backupAIMforcorrelation(:,4:7,1:5),[],1)),'Frequency Verschiebung [Hz]','Global AIM',1)
hold on; scatter(reshape(testfreq(:,4:7,1:5),[],1),(reshape(backupAIMforcorrelation(:,4:7,1:5),[],1)),40,'o','filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[.7 .7 .7]); hold off
xlim([-5 25])
ylim([0 40])



%% Frequency Verschiebung x power, rauslassen. 
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

