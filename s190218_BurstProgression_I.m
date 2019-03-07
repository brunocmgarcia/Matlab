%% 190218_BurstProgression_I 

% clear all
% close all 
% clc

% %% erstelle basestruct.
% load VAR_baselineschluessel
% baselineschluessel=baselineschluessel(10:end,:);
% cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/180/burstCenterOfMass')
% ordner=dir('*.mat');
% files={ordner.name}';
% 
% for file_i=1:length(baselineschluessel)
%     
%     datei180=baselineschluessel(file_i,1);
%     datei180=datei180{:}(1:end-18);
%     datei180=[datei180 '_burst.mat']
%     datei10=baselineschluessel(file_i,2);
%     datei10=datei10{:}(1:end-18);
%     datei10=[datei10 '_burst.mat']
%     load(datei180)
%     basestruct=load(['/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/Ruhe10/burstCenterOfMass/' datei10]);
%     P75rs=basestruct.P75rs;
%     for i=1:length(basestruct.rs_NumBlockStart)
%         ausschnitt=basestruct.datrectsmooth(basestruct.rs_NumBlockStart(i):basestruct.rs_NumBlockEnd(i))-P75rs;
%         maxheightBL(1,i)=max(ausschnitt);
%         AUCBL(1,i)=trapz(ausschnitt,2);
%     end
%     clearvars ausschnitt i
%     
%     for i=1:length(rs_NumBlockStartold)
%         ausschnitt=datrectsmooth(rs_NumBlockStartold(i):rs_NumBlockEndold(i))-P75rs;
%         maxheight(1,i)=max(ausschnitt);
%         AUC(1,i)=trapz(ausschnitt,2);
%     end
%     clearvars ausschnitt i
%     
%     burststruct(file_i).BL.maxheight=maxheightBL;
%     burststruct(file_i).LD.maxheight=maxheight;
%     burststruct(file_i).BL.AUC=AUCBL;
%     burststruct(file_i).LD.AUC=AUC;
%     burststruct(file_i).BL.length=basestruct.rs_NumBlockLength;
%     burststruct(file_i).LD.length=rs_NumBlockLengthold;
%     burststruct(file_i).BL.start=basestruct.rs_NumBlockStart;
%     burststruct(file_i).LD.start=rs_NumBlockStartold;
%     burststruct(file_i).BL.end=basestruct.rs_NumBlockEnd;
%     burststruct(file_i).LD.end=rs_NumBlockEndold;
%     burststruct(file_i).P75=P75rs;
%     burststruct(file_i).BL.dat=basestruct.datrectsmooth;
%     burststruct(file_i).LD.dat=datrectsmooth;
%     
% clearvars -except burststruct file_i files baselineschluessel
% end
% save('burststruct','burststruct','-v7.3')


%% do something with it.
% cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/180/burstCenterOfMass')
% load('burststruct.mat')
% load VAR_baselineschluessel


% load('/Users/guettlec/Desktop/burststruct.mat')
% load VAR_baselineschluessel
% baselineschluessel=baselineschluessel(10:end,:);


clearvars -except burststruct
close all
allLD=[1 2 4 5 7 8 9; 23 24 26 28 30 32 33; 35 36 38 40 42 44 45; 47 48 50 51 52 54 55; 66 67 69 70 71 73 74]';
starttimes=[];

height=[];
length=[];
AUC=[];
heightBL=[];
lengthBL=[];
AUCBL=[];
for i=1:size(allLD,1)
    for ii=1:size(allLD,2)
        starttimes{i,ii}=(burststruct(allLD(i,ii)).LD.start)./(500*60); %now minutes
        height{i,ii}=burststruct(allLD(i,ii)).LD.maxheight;
        length{i,ii}=burststruct(allLD(i,ii)).LD.length;
        AUC{i,ii}=burststruct(allLD(i,ii)).LD.AUC;
        starttimesBL{i,ii}=(burststruct(allLD(i,ii)).BL.start)./(500*60); %now minutes
        heightBL{i,ii}=burststruct(allLD(i,ii)).BL.maxheight;
        lengthBL{i,ii}=burststruct(allLD(i,ii)).BL.length;
        AUCBL{i,ii}=burststruct(allLD(i,ii)).BL.AUC;
    end
end

[~,~,timebins]=cellfun(@histcounts, starttimes,repmat({[0 10 15 20 30 50 70 90 110 130 150 170 180]},7,5), 'Uni',0);
timebins=cellfun(@(x) x.*(x~=3), timebins, 'Uni',0);
timebins=cellfun(@(x) x-((x>3)*2), timebins, 'Uni',0); % zauberei. alles um die zeit zwischen 15:20 (laufband) zu entfernen.

for i=1:7
    for ii=1:5
        for iii=1:10
            [hist_height_counts{i,ii,iii},~,hist_height_binind{i,ii,iii}]=histcounts(height{i,ii}(timebins{i,ii}==iii),[0 1 2 3 inf]);
            hist_height_counts{i,ii,iii}=hist_height_counts{i,ii,iii}./sum(hist_height_counts{i,ii,iii});           
            [hist_length_counts{i,ii,iii},~,hist_length_binind{i,ii,iii}]=histcounts(length{i,ii}(timebins{i,ii}==iii),[.05 .1 .15 .2 inf]);
            hist_length_counts{i,ii,iii}=hist_length_counts{i,ii,iii}./sum(hist_length_counts{i,ii,iii});           
            hist_height_COV(i,ii,iii)=mad(height{i,ii}(timebins{i,ii}==iii),1)/median(height{i,ii}(timebins{i,ii}==iii),2);
            hist_length_COV(i,ii,iii)=mad(length{i,ii}(timebins{i,ii}==iii),1)/median(length{i,ii}(timebins{i,ii}==iii),2);
        end
    end
end

% hist_height_counts = cell2mat(arrayfun(@(x)permute(x{:},[3 1 2]),hist_height_counts,'UniformOutput',0));
% reshape(cat(1,A{:}),[size(C), numel(C{1})])


hist_height_counts = cell2mat(cellfun(@(x)reshape(x,1,1,1,[]),hist_height_counts,'un',0));
hist_length_counts = cell2mat(cellfun(@(x)reshape(x,1,1,1,[]),hist_length_counts,'un',0));
hist_height_counts(:,:,:,[2 3])=NaN;
hist_length_counts(:,:,:,[2 3])=NaN;
hist_height_counts(:,:,:,1)=1-hist_height_counts(:,:,:,1);
hist_length_counts(:,:,:,1)=1-hist_length_counts(:,:,:,1);

%% highest/lowest/longest/shortest über zeit
figure
subplot(1,2,1)
title('highest')
hold on
farbe=parula(7);
for i=1:7
    highest_mean(i,:)=[squeeze(nanmean(hist_height_counts(i,:,:,4),2))];
    highest_SEM(i,:)=[squeeze(nanstd(hist_height_counts(i,:,:,4),[],2))]./sqrt(5);  
    plot([1:10],highest_mean(i,:),'Color',farbe(i,:))
    jbfill([1:10],highest_mean(i,:)+highest_SEM(i,:),highest_mean(i,:)-highest_SEM(i,:),farbe(i,:),farbe(i,:),0,0.2);
end
for i=1:7   
    lowest_mean(i,:)=-1.*(([squeeze(nanmean(hist_height_counts(i,:,:,1),2))]));
    lowest_SEM(i,:)=-1.*(([squeeze(nanstd(hist_height_counts(i,:,:,1),[],2))]./sqrt(5)));
    plot([1:10],lowest_mean(i,:),'Color',farbe(i,:))
    jbfill([1:10],lowest_mean(i,:)+lowest_SEM(i,:),lowest_mean(i,:)-lowest_SEM(i,:),farbe(i,:),farbe(i,:),0,0.2);
end
hold off
ylim([-.9 .7])

% subplot(2,2,2)
% title('lowest')
% hold on
% farbe=parula(7);
% for i=1:7   
%     lowest_mean(i,:)=[squeeze(nanmean(hist_height_counts(i,:,:,1),2))];
%     lowest_SEM(i,:)=[squeeze(nanstd(hist_height_counts(i,:,:,1),[],2))]./sqrt(5);
%     plot([1:10],lowest_mean(i,:),'Color',farbe(i,:))
%     jbfill([1:10],lowest_mean(i,:)+lowest_SEM(i,:),lowest_mean(i,:)-lowest_SEM(i,:),farbe(i,:),farbe(i,:),0,0.2);
% end
% hold off

subplot(1,2,2)
title('longest')
hold on
farbe=parula(7);
for i=1:7    
    longest_mean(i,:)=[squeeze(nanmean(hist_length_counts(i,:,:,4),2))];
    longest_SEM(i,:)=[squeeze(nanstd(hist_length_counts(i,:,:,4),[],2))]./sqrt(5);
    plot([1:10],longest_mean(i,:),'Color',farbe(i,:))
    jbfill([1:10],longest_mean(i,:)+longest_SEM(i,:),longest_mean(i,:)-longest_SEM(i,:),farbe(i,:),farbe(i,:),0,0.2);
end
for i=1:7   
    shortest_mean(i,:)=-1.*([squeeze(nanmean(hist_length_counts(i,:,:,1),2))]);
    shortest_SEM(i,:)=-1.*([squeeze(nanstd(hist_length_counts(i,:,:,1),[],2))]./sqrt(5));
    plot([1:10],shortest_mean(i,:),'Color',farbe(i,:))
    jbfill([1:10],shortest_mean(i,:)+shortest_SEM(i,:),shortest_mean(i,:)-shortest_SEM(i,:),farbe(i,:),farbe(i,:),0,0.2);
end
hold off
ylim([-.9 .7])
% subplot(2,2,4)
% title('shortest')
% hold on
% farbe=parula(7);
% for i=1:7   
%     shortest_mean(i,:)=[squeeze(nanmean(hist_length_counts(i,:,:,1),2))];
%     shortest_SEM(i,:)=[squeeze(nanstd(hist_length_counts(i,:,:,1),[],2))]./sqrt(5);
%     plot([1:10],shortest_mean(i,:),'Color',farbe(i,:))
%     jbfill([1:10],shortest_mean(i,:)+shortest_SEM(i,:),shortest_mean(i,:)-shortest_SEM(i,:),farbe(i,:),farbe(i,:),0,0.2);
% end
% hold off

%% COV (aber als MAD./median) over time for height and length
figure
subplot(2,1,1)
title('COV height')
hold on
farbe=parula(7);
for i=1:7
    height_COV_mean(i,:)=[squeeze(nanmean(hist_height_COV(i,:,:),2))];
    height_COV_SEM(i,:)=[squeeze(nanstd(hist_height_COV(i,:,:),[],2))]./sqrt(5);  
    plot([1:10],height_COV_mean(i,:),'Color',farbe(i,:))
    jbfill([1:10],height_COV_mean(i,:)+height_COV_SEM(i,:),height_COV_mean(i,:)-height_COV_SEM(i,:),farbe(i,:),farbe(i,:),0,0.2);
end
hold off

subplot(2,1,2)
title('COV length')
hold on
farbe=parula(7);
for i=1:7
    length_COV_mean(i,:)=[squeeze(nanmean(hist_length_COV(i,:,:),2))];
    length_COV_SEM(i,:)=[squeeze(nanstd(hist_length_COV(i,:,:),[],2))]./sqrt(5);  
    plot([1:10],length_COV_mean(i,:),'Color',farbe(i,:))
    jbfill([1:10],length_COV_mean(i,:)+length_COV_SEM(i,:),length_COV_mean(i,:)-length_COV_SEM(i,:),farbe(i,:),farbe(i,:),0,0.2);
end
hold off


%% longest./shortest und highest./lowest

figure
subplot(1,2,1)
title('highest./lowest')
hold on
farbe=parula(7);
for i=1:7
    highest_div_lowest_mean(i,:)=nanmean([squeeze(hist_height_counts(i,:,:,4)./hist_height_counts(i,:,:,1))],1);
    highest_div_lowest_SEM(i,:)=(nanstd([squeeze(hist_height_counts(i,:,:,4)./hist_height_counts(i,:,:,1))],[],1)/sqrt(5));  
    plot([1:10],highest_div_lowest_mean(i,:),'Color',farbe(i,:))
    jbfill([1:10],highest_div_lowest_mean(i,:)+highest_div_lowest_SEM(i,:),highest_div_lowest_mean(i,:)-highest_div_lowest_SEM(i,:),farbe(i,:),farbe(i,:),0,0.2);
end
hold off

subplot(1,2,2)
title('longest./shortest')
hold on
farbe=parula(7);
for i=1:7   
    longest_div_shortest_mean(i,:)=nanmean([squeeze(hist_length_counts(i,:,:,4)./hist_length_counts(i,:,:,1))],1);
    longest_div_shortest_SEM(i,:)=(nanstd([squeeze(hist_length_counts(i,:,:,4)./hist_length_counts(i,:,:,1))],[],1)/sqrt(5));  
    plot([1:10],longest_div_shortest_mean(i,:),'Color',farbe(i,:))
    jbfill([1:10],longest_div_shortest_mean(i,:)+longest_div_shortest_SEM(i,:),longest_div_shortest_mean(i,:)-longest_div_shortest_SEM(i,:),farbe(i,:),farbe(i,:),0,0.2);
end
hold off

%% rate over time
%MISSING


%% average burst height and length over time
figure
subplot(1,2,1)
hold on
title('average burst height over time')
for i=1:7
    flat_timebins=timebins{i,:};
    flat_height=height{i,:};
    for ii=1:10
        avheight_mean(i,ii)=nanmean([flat_height(flat_timebins==ii)]);
        avheight_SEM(i,ii)=(nanstd([flat_height(flat_timebins==ii)]))/sqrt(5);
    end
 
    plot([1:10],avheight_mean(i,:),'Color',farbe(i,:))
    jbfill([1:10],avheight_mean(i,:)+avheight_SEM(i,:),avheight_mean(i,:)-avheight_SEM(i,:),farbe(i,:),farbe(i,:),0,0.2);
    clearvars flat_timebins flat_height

end
hold off

subplot(1,2,2)
hold on
title('average burst length over time')
for i=1:7
    flat_timebins=timebins{i,:};
    flat_length=length{i,:};
    for ii=1:10
        avlength_mean(i,ii)=nanmean([flat_length(flat_timebins==ii)]);
        avlength_SEM(i,ii)=(nanstd([flat_length(flat_timebins==ii)]))/sqrt(5);
    end
 
    plot([1:10],avlength_mean(i,:),'Color',farbe(i,:))
    jbfill([1:10],avlength_mean(i,:)+avlength_SEM(i,:),avlength_mean(i,:)-avlength_SEM(i,:),farbe(i,:),farbe(i,:),0,0.2);
    clearvars flat_timebins flat_height

end
hold off

%% grandaverage burst height and length LD vs BL

figure


for i=1:5
    for ii=1:5
        GA_height_temp=height{i,ii};
        GA_length_temp=length{i,ii};
        GA_timebins_temp=timebins{i,ii};
        GA_height(i,ii)=mean(GA_height_temp(GA_timebins_temp>3 & GA_timebins_temp<8),2);
        GA_length(i,ii)=mean(GA_length_temp(GA_timebins_temp>3 & GA_timebins_temp<8),2);
        GA_heightBL(i,ii)=mean(heightBL{i,ii},2); 
        GA_lengthBL(i,ii)=mean(lengthBL{i,ii},2);  
    end
end
GA_height=GA_height';
GA_heightBL=GA_heightBL';
GA_length=GA_length';
GA_lengthBL=GA_lengthBL';

figure
hold on
title('Grandaverage BL vs LD burst height')
plotSingleBarSEM([mean(GA_heightBL,2) mean(GA_height,2)])
hold off

figure
hold on
title('Grandaverage BL vs LD burst length')
plotSingleBarSEM([mean(GA_lengthBL,2) mean(GA_length,2)])
hold off

%% new correlations: über zeit etc

load VAR_5x10x7_corr % aimforcorr/freq4/power4 als 5x10x7
%freqforcorrelation=freqforcorrelation-mean(freqforcorrelation(:,5:6,1),2);
% hist_height_counts hist_length_counts are 7x5x10x4
longestburstforcorrelation=permute(squeeze(hist_length_counts(:,:,:,4)),[2 3 1]);
shortestburstforcorrelation=permute(squeeze(hist_length_counts(:,:,:,1)),[2 3 1]);
highestburstforcorrelation=permute(squeeze(hist_height_counts(:,:,:,4)),[2 3 1]);
lowestburstforcorrelation=permute(squeeze(hist_height_counts(:,:,:,1)),[2 3 1]);
hist_length_COV_forcorrelation=permute(hist_length_COV,[2 3 1]);
hist_height_COV_forcorrelation=permute(hist_height_COV,[2 3 1]);


linearregression(reshape(highestburstforcorrelation(:,:,1:5),[],1),reshape(powerforcorrelation(:,:,1:5),[],1), 'highest bursts','power',1)
hold on
scatter(reshape(highestburstforcorrelation(:,:,1:5),[],1),reshape(powerforcorrelation(:,:,1:5),[],1),40,'o','filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[.7 .7 .7])
hold off

linearregression(reshape(lowestburstforcorrelation(:,:,1:5),[],1),reshape(powerforcorrelation(:,:,1:5),[],1), 'lowest bursts','power',1)
hold on
scatter(reshape(lowestburstforcorrelation(:,:,1:5),[],1),reshape(powerforcorrelation(:,:,1:5),[],1),40,'o','filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[.7 .7 .7])
hold off

linearregression(reshape(longestburstforcorrelation(:,:,1:5),[],1),reshape(powerforcorrelation(:,:,1:5),[],1), 'longest bursts','power',1)
hold on
scatter(reshape(longestburstforcorrelation(:,:,1:5),[],1),reshape(powerforcorrelation(:,:,1:5),[],1),40,'o','filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[.7 .7 .7])
hold off

linearregression(reshape(shortestburstforcorrelation(:,:,1:5),[],1),reshape(powerforcorrelation(:,:,1:5),[],1), 'shortest bursts','power',1)
hold on
scatter(reshape(shortestburstforcorrelation(:,:,1:5),[],1),reshape(powerforcorrelation(:,:,1:5),[],1),40,'o','filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[.7 .7 .7])
hold off

linearregression(reshape(highestburstforcorrelation(:,:,1:5),[],1),reshape(AIMforcorrelation(:,:,1:5),[],1), 'highest bursts','AIM',1)
hold on
scatter(reshape(highestburstforcorrelation(:,:,1:5),[],1),reshape(AIMforcorrelation(:,:,1:5),[],1),40,'o','filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[.7 .7 .7])
hold off

linearregression(reshape(lowestburstforcorrelation(:,:,1:5),[],1),reshape(AIMforcorrelation(:,:,1:5),[],1), 'lowest bursts','AIM',1)
hold on
scatter(reshape(lowestburstforcorrelation(:,:,1:5),[],1),reshape(AIMforcorrelation(:,:,1:5),[],1),40,'o','filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[.7 .7 .7])
hold off

linearregression(reshape(longestburstforcorrelation(:,:,1:5),[],1),reshape(AIMforcorrelation(:,:,1:5),[],1), 'longest bursts','AIM',1)
hold on
scatter(reshape(longestburstforcorrelation(:,:,1:5),[],1),reshape(AIMforcorrelation(:,:,1:5),[],1),40,'o','filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[.7 .7 .7])
hold off

linearregression(reshape(shortestburstforcorrelation(:,:,1:5),[],1),reshape(AIMforcorrelation(:,:,1:5),[],1), 'shortest bursts','AIM',1)
hold on
scatter(reshape(shortestburstforcorrelation(:,:,1:5),[],1),reshape(AIMforcorrelation(:,:,1:5),[],1),40,'o','filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[.7 .7 .7])
hold off

linearregression(reshape(hist_height_COV_forcorrelation(:,:,1:5),[],1),reshape(AIMforcorrelation(:,:,1:5),[],1), 'burstheight COV','AIM',1)
hold on
scatter(reshape(hist_height_COV_forcorrelation(:,:,1:5),[],1),reshape(AIMforcorrelation(:,:,1:5),[],1),40,'o','filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[.7 .7 .7])
hold off

linearregression(reshape(hist_length_COV_forcorrelation(:,:,1:5),[],1),reshape(AIMforcorrelation(:,:,1:5),[],1), 'burstlength COV','AIM',1)
hold on
scatter(reshape(hist_length_COV_forcorrelation(:,:,1:5),[],1),reshape(AIMforcorrelation(:,:,1:5),[],1),40,'o','filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[.7 .7 .7])
hold off


%% PCA

figure
totalforcorr=...
    [reshape(highestburstforcorrelation(:,:,1:5),[],1)...
    reshape(lowestburstforcorrelation(:,:,1:5),[],1)...
    reshape(longestburstforcorrelation(:,:,1:5),[],1)...
    reshape(shortestburstforcorrelation(:,:,1:5),[],1)...
    reshape(powerforcorrelation(:,:,1:5),[],1)...
    reshape(freqforcorrelation(:,:,1:5),[],1)...
    reshape(AIMforcorrelation(:,:,1:5),[],1)...
    reshape(hist_height_COV_forcorrelation(:,:,1:5),[],1)...
    reshape(hist_length_COV_forcorrelation(:,:,1:5),[],1)...
    ];

rng(666);
randindices=randperm(size(totalforcorr,1))';
totalforcorr=totalforcorr(randindices,:);

totalforcorrlabels={'highest','lowest','longest','shortest','power','freq','AIM','heightCOV','lengthCOV'};
totalforcorr=totalforcorr(all(~isnan(totalforcorr),2),:);
[pca_COEFF, pca_SCORE, pca_LATENT, pca_TSQUARED, pca_EXPLAINED, pca_MU] = pca(zscore(totalforcorr(:,[1:6])));
subplot(1,2,1)
biplot(pca_COEFF(:,[1 2 6]),'Scores',pca_SCORE(:,[1 2 6]),'Varlabels',totalforcorrlabels(1,[1:6]))
subplot(1,2,2)
colorcode=totalforcorr(:,7);
%colorcode=colorcode./max(colorcode);
colorcode(colorcode<=3)=0;
colorcode(colorcode>3)=1;
colormap(prism)

 scatter3(pca_SCORE(:,1),pca_SCORE(:,2),pca_SCORE(:,6),40,colorcode,'filled')


% colorcode(colorcode==0)=0;
% colorcode(colorcode>0)=1;
%  
figure
colormap(prism)
counter=0;
for i=[1:size(pca_COEFF,1)]
    for ii=[1:size(pca_COEFF,1)]
        counter=counter+1;
        subplot(size(pca_COEFF,1),size(pca_COEFF,1),counter)
        scatter(pca_SCORE(:,i),pca_SCORE(:,ii),5,colorcode,'filled')
    end
end


% counter=0;
% for i=1:6
%     for ii=1:6
%         counter=counter+1;
%         figure('Name',char(sprintf('PCA %i gegen PCA %i',i,ii)))
%         colormap(prism)
%         scatter(pca_SCORE(:,i),pca_SCORE(:,ii),20,colorcode,'filled')
%     end
% end

%% ROC AIM > 0
colorcode=totalforcorr(:,7);
colorcode(colorcode==0)=0;
colorcode(colorcode>0)=1;
[roc_x, roc_y,roc_t, roc_AUC]=perfcurve(colorcode,totalforcorr(:,5),1,'nboot',1000);
figure
title('power for AIM>0')
hold on
plot(roc_x, roc_y)
legend(num2str(roc_AUC),'Location','best')
hold off

[roc_x, roc_y,roc_t, roc_AUC]=perfcurve(colorcode,totalforcorr(:,6),1);
figure
title('freq for AIM>0')
hold on
plot(roc_x, roc_y)
legend(num2str(roc_AUC),'Location','best')

[roc_x, roc_y,roc_t, roc_AUC]=perfcurve(colorcode,totalforcorr(:,1),1);
figure
title('highest for AIM>0')
hold on
plot(roc_x, roc_y)
legend(num2str(roc_AUC),'Location','best')

[roc_x, roc_y,roc_t, roc_AUC]=perfcurve(colorcode,totalforcorr(:,3),1,'nboot',2000);
figure
title('longest for AIM>0')
hold on
plot(roc_x, roc_y)
legend(num2str(roc_AUC),'Location','best')
hold off

[roc_x, roc_y,roc_t, roc_AUC]=perfcurve(colorcode,(totalforcorr(:,2)),1);
figure
title('lowest for AIM>0')
hold on
plot(roc_x, roc_y)
legend(num2str(roc_AUC),'Location','best')

[roc_x, roc_y,roc_t, roc_AUC]=perfcurve(colorcode,(totalforcorr(:,4)),1);
figure
title('shortest for AIM>0')
hold on
plot(roc_x, roc_y)
legend(num2str(roc_AUC),'Location','best')

[roc_x, roc_y,roc_t, roc_AUC]=perfcurve(colorcode,pca_SCORE(:,1),1);
figure
title('PCA1 for AIM>0')
hold on
plot(roc_x, roc_y)
legend(num2str(roc_AUC),'Location','best')

[roc_x, roc_y,roc_t, roc_AUC]=perfcurve(colorcode,pca_SCORE(:,2),1);
figure
title('PCA2 for AIM>0')
hold on
plot(roc_x, roc_y)
legend(num2str(roc_AUC),'Location','best')

%% simple ROCs for AIM > 3
for cutoff=[0 3]
    colorcode=totalforcorr(:,7);
    colorcode(colorcode<=cutoff)=0;
    colorcode(colorcode>cutoff)=1;

    for i=[1 2 3 4 5 6 8 9]
        clearvars roc_x roc_y roc_t roc_AUC roc_optrocpt

        [roc_x, roc_y,roc_t, roc_AUC, roc_optrocpt]=perfcurve(colorcode,totalforcorr(:,i),1,'nboot',1000);
        figure('Name',sprintf('pure %s for AIM>%i, nboot 1000', totalforcorrlabels{1,i},cutoff))
        subplot(1,2,1)
        hold on
        plot(roc_x(:,2:3), roc_y(:,2:3),'Color',[.5 .5 .5]) % ci
        plot(roc_x(:,1), roc_y(:,1),'k') % mean
        plot([0 1],[roc_optrocpt(2) roc_optrocpt(2)],'k')
        plot([roc_optrocpt(1) roc_optrocpt(1)],[0 1],'k')
        legend(num2str(roc_AUC),'Location','best')
        xlabel('false positive rate (1-specificity)'); ylabel('true positive rate (sensitivity)')
        xlim([0 1]); ylim([0 1]); axis tight; axis square
        hold off
        subplot(1,2,2)
        plot(roc_x(:,1), roc_t)
        legend(sprintf('sens: %.2f spez: %.2f',(1-roc_optrocpt(1))*100,(roc_optrocpt(2))*100),'Location','best')
        xlabel('false positive rate (1-specificity)'); ylabel('threshold')
        axis tight; axis square
        hold off

    end
end

for cutoff=[0 3]
    colorcode=totalforcorr(:,7);
    colorcode(colorcode<=cutoff)=0;
    colorcode(colorcode>cutoff)=1;
   
        clearvars roc_x roc_y roc_t roc_AUC roc_optrocpt
        [roc_x, roc_y,roc_t, roc_AUC, roc_optrocpt]=perfcurve(colorcode,pca_SCORE(:,1),1,'nboot',1000);
        figure('Name',sprintf('pure PCA1 for AIM>%i, nboot 1000',cutoff))

        subplot(1,2,1)
        hold on
        plot(roc_x(:,2:3), roc_y(:,2:3),'b') % ci
        plot(roc_x(:,1), roc_y(:,1),'r') % mean
        legend(num2str(roc_AUC),'Location','best')
        xlabel('false positive rate (1-specificity)'); ylabel('true positive rate (sensitivity)')
        xlim([0 1]); ylim([0 1]); axis tight
        hold off
        subplot(1,2,2)
        plot(roc_x(:,1), roc_t)
        legend(sprintf('sens: %.2f spez: %.2f',(1-roc_optrocpt(1))*100,(roc_optrocpt(2))*100),'Location','best')
        xlabel('false positive rate (1-specificity)'); ylabel('threshold')
        axis tight
        hold off
        
end



% %% ROC GLM with PCA1 : PCA4 for AIM>0 OLD VERSION, No validation!
% clearvars glm_partition glm_scores glm_scores2 glm_final glm_X glm_Y glm_T glm_AUC glm_optrocpt colorcode glm_pred glm_resp
% 
% colorcode=totalforcorr(:,7); 
% colorcode(colorcode<=0)=0;
% colorcode(colorcode>0)=1; % colorcode now is 1 for every AIM > 0 and 0 if aim is 0
% glm_pred=pca_SCORE(:,1:4); % predictors are PC1 through 4 (of 6)
% glm_resp=colorcode; 
% glm_mdl=fitglm(glm_pred,glm_resp,'Distribution','Binomial','Link','logit');
% glm_scores=glm_mdl.Fitted.Probability; % same as predict scores from trained with all and tested on all. 
% glm_scores2=predict(fitglm(glm_pred,glm_resp,'Distribution','Binomial','Link','logit'), glm_pred);
% [glm_X, glm_Y, glm_T, glm_AUC, glm_optrocpt]=perfcurve(colorcode,glm_scores,1); % 'nboot' 100 bootstrapping here instead of val?
% figure
% title('GLM with PC1:4 for AIM>0')
% subplot(1,2,1)
% hold on
% plot(glm_X, glm_Y)
% legend(num2str(glm_AUC),'Location','best')
% hold off
% subplot(1,2,2)
% plot(glm_X, glm_T)
% legend(sprintf('sens: %.2f spez: %.2f',(1-glm_optrocpt(1))*100,(glm_optrocpt(2))*100),'Location','best')

%% ROC GLM with PCA1 : PCA4 for AIM0-3 mit training test split kfold 10 oder leaveout 1
for cutoff=0:3
clearvars glm_partition glm_final glm_X glm_Y glm_T glm_AUC glm_optrocpt colorcode glm_pred glm_resp
colorcode=totalforcorr(:,7);
colorcode(colorcode<=cutoff)=0;
colorcode(colorcode>cutoff)=1;
glm_pred=pca_SCORE(:,[1:4]);
glm_resp=colorcode;

% rng(666)
% glm_partition=cvpartition(size(glm_resp,1),'k',10);
rng(666)
glm_partition=cvpartition(size(glm_resp,1),'LeaveOut');


for i=1:glm_partition.NumTestSets
    glm_final(1,i)={glm_resp(test(glm_partition,i))};
    glm_final(2,i)={predict(fitglm(glm_pred(training(glm_partition,i),:),glm_resp(training(glm_partition,i)),'Distribution','Binomial','Link','logit'), glm_pred(test(glm_partition,i),:))};
    
end

[glm_X, glm_Y, glm_T, glm_AUC, glm_optrocpt]=perfcurve(glm_final(1,:),glm_final(2,:),1); % kein bootstrap sonder alle k-folds

figure('Name',sprintf('GLM with PC1:4 for AIM>%i, validation type=%s, testsets=%i',cutoff,glm_partition.Type, glm_partition.NumTestSets))
subplot(1,2,1)
hold on
plot(glm_X(:,2:3), glm_Y(:,2:3),'b') % ci
plot(glm_X(:,1), glm_Y(:,1),'r') % mean
legend(num2str(glm_AUC),'Location','best')
xlabel('false positive rate (1-specificity)'); ylabel('true positive rate (sensitivity)')
xlim([0 1]); ylim([0 1]); axis tight
hold off
subplot(1,2,2)
plot(glm_X(:,1), glm_T)
legend(sprintf('sens: %.2f spez: %.2f',(1-glm_optrocpt(1))*100,(glm_optrocpt(2))*100),'Location','best')
xlabel('false positive rate (1-specificity)'); ylabel('threshold')
axis tight
drawnow
end


%% ROC GLM with all burst parameters for AIM0-5 mit training test split kfold 10 oder leaveout 1
for cutoff=0:3
clearvars glm_partition glm_final glm_X glm_Y glm_T glm_AUC glm_optrocpt colorcode glm_pred glm_resp
colorcode=totalforcorr(:,7);
colorcode(colorcode<=cutoff)=0;
colorcode(colorcode>cutoff)=1;
glm_pred=zscore(totalforcorr(:,[1:6]),[],1);
glm_resp=colorcode;

% rng(666)
% glm_partition=cvpartition(size(glm_resp,1),'k',10);
rng(666)
glm_partition=cvpartition(size(glm_resp,1),'LeaveOut');


for i=1:glm_partition.NumTestSets
    glm_final(1,i)={glm_resp(test(glm_partition,i))};
    glm_final(2,i)={predict(fitglm(glm_pred(training(glm_partition,i),:),glm_resp(training(glm_partition,i)),'Distribution','Binomial','Link','logit'), glm_pred(test(glm_partition,i),:))};
    
end

[glm_X, glm_Y, glm_T, glm_AUC, glm_optrocpt]=perfcurve(glm_final(1,:),glm_final(2,:),1); % kein bootstrap sonder alle k-folds

figure('Name',sprintf('GLM with all burst params for AIM>%i, validation type=%s, testsets=%i',cutoff,glm_partition.Type, glm_partition.NumTestSets))
subplot(1,2,1)
hold on
plot(glm_X(:,2:3), glm_Y(:,2:3),'b') % ci
plot(glm_X(:,1), glm_Y(:,1),'r') % mean
legend(num2str(glm_AUC),'Location','best')
xlabel('false positive rate (1-specificity)'); ylabel('true positive rate (sensitivity)')
xlim([0 1]); ylim([0 1]); axis tight
hold off
subplot(1,2,2)
plot(glm_X(:,1), glm_T)
legend(sprintf('sens: %.2f spez: %.2f',(1-glm_optrocpt(1))*100,(glm_optrocpt(2))*100),'Location','best')
xlabel('false positive rate (1-specificity)'); ylabel('threshold')
axis tight
drawnow
end

%% now just the low aims.

for cutoff=1
clearvars glm_partition  cutoff glm_final glm_X glm_Y glm_T glm_AUC glm_optrocpt colorcode glm_pred glm_resp
cutoff=totalforcorr(:,7);
cutoff(cutoff==0)=[];
cutoff=quantile(cutoff,[.025 .3]);
colorcode=totalforcorr(:,7);
colorcode(colorcode<cutoff(1) | colorcode>cutoff(2))=0;
colorcode(colorcode~=0)=1;
glm_pred=pca_SCORE(:,[1:4]);
glm_resp=colorcode;

% rng(666)
% glm_partition=cvpartition(size(glm_resp,1),'k',10);
rng(666)
glm_partition=cvpartition(size(glm_resp,1),'LeaveOut');

for i=1:glm_partition.NumTestSets
    glm_final(1,i)={glm_resp(test(glm_partition,i))};
    glm_final(2,i)={predict(fitglm(glm_pred(training(glm_partition,i),:),glm_resp(training(glm_partition,i)),'quadratic','Distribution','binomial','Link','logit'), glm_pred(test(glm_partition,i),:))};
   
end

[glm_X, glm_Y, glm_T, glm_AUC, glm_optrocpt]=perfcurve(glm_final(1,:),glm_final(2,:),1); % kein bootstrap sonder alle k-folds

figure('Name',sprintf('GLM with PC1:3 for AIM>%i, validation type=%s, testsets=%i',cutoff,glm_partition.Type, glm_partition.NumTestSets))
subplot(1,2,1)
hold on
plot(glm_X(:,2:3), glm_Y(:,2:3),'b') % ci
plot(glm_X(:,1), glm_Y(:,1),'r') % mean
legend(num2str(glm_AUC),'Location','best')
xlabel('false positive rate (1-specificity)'); ylabel('true positive rate (sensitivity)')
xlim([0 1]); ylim([0 1]); axis tight
hold off
subplot(1,2,2)
plot(glm_X(:,1), glm_T)
legend(sprintf('sens: %.2f spez: %.2f',(1-glm_optrocpt(1))*100,(glm_optrocpt(2))*100),'Location','best')
xlabel('false positive rate (1-specificity)'); ylabel('threshold')
axis tight
drawnow
end

%% partial corrected correlation all params
clc
clearvars pcc_total pcc_rho pcc_pval pcc_possiblecomb pcc_pval_temp pcc_rho_temp zeroorder_rho zeroorder_p
pcc_possiblecomb=nchoosek([1 2 3 4 5 6 8 9],2);
counter=0;
for i=[1 2 3 4 5 6 8 9]
    for ii=[1 2 3 4 5 6 8 9]
         if i~=ii
            counter=counter+1;
            pcc_possiblecomb(counter,1)=i;      
            pcc_possiblecomb(counter,2)=ii;
         end
    end
end

for i=1:size(pcc_possiblecomb,1)
    [pcc_rho, pcc_pval]=partialcorr(totalforcorr(:,[pcc_possiblecomb(i,1), pcc_possiblecomb(i,2), 7]),'Type','Spearman','Rows','complete');
    [zeroorder_rho, zeroorder_p]=corr(totalforcorr(:,[pcc_possiblecomb(i,1), 7]),'Type','Spearman','Rows','complete');
     
    
    
%     
%     pcc_rho=array2table(pcc_rho,'VariableNames',totalforcorrlabels([pcc_possiblecomb(i,1), pcc_possiblecomb(i,2), 7]),'RowNames',totalforcorrlabels([pcc_possiblecomb(i,1), pcc_possiblecomb(i,2), 7]));
%     pcc_pval=array2table(pcc_pval,'VariableNames',totalforcorrlabels([pcc_possiblecomb(i,1), pcc_possiblecomb(i,2), 7]),'RowNames',totalforcorrlabels([pcc_possiblecomb(i,1), pcc_possiblecomb(i,2), 7]));
%     
        
%     
%     pcc_total(i,1)={pcc_rho};
%     pcc_total(i,2)={pcc_pval};
      pcc_total(i,1)={'rho:'};
      pcc_total(i,2)={round(pcc_rho(1,3),3)};
      pcc_total(i,3)={'p-value:'};
      pcc_total(i,4)={round(pcc_pval(1,3),3)};
      pcc_total(i,5)={['aim X ' totalforcorrlabels{pcc_possiblecomb(i,1)}]};
      pcc_total(i,6)={['corrected for ' totalforcorrlabels{pcc_possiblecomb(i,2)}]};
      pcc_total(i,7)={'zero order corr:'};
      pcc_total(i,8)={'rho:'};
      pcc_total(i,9)={round(zeroorder_rho(1,2),3)};
      pcc_total(i,10)={'p-value:'};
      pcc_total(i,11)={round(zeroorder_p(1,2),3)};
      pcc_total(i,12)={'0-order minus partial rho:'};
      pcc_total(i,13)={round(pcc_total{i,9},3)-round(pcc_total{i,2},3)};
%   
    
%     disp(pcc_total{i,2})
end

%% partial corrected correlation PCs
clc
clearvars pcc_total pcc_rho pcc_pval pcc_possiblecomb pcc_pval_temp pcc_rho_temp zeroorder_rho zeroorder_p
counter=0;
for i=1:6
    for ii=1:6
         if i~=ii
            counter=counter+1;
            pcc_possiblecomb(counter,1)=i;      
            pcc_possiblecomb(counter,2)=ii;
         end
    end
end


for i=1:size(pcc_possiblecomb,1)
    [pcc_rho, pcc_pval]=partialcorr([pca_SCORE(:,pcc_possiblecomb(i,1)) pca_SCORE(:,pcc_possiblecomb(i,2)) totalforcorr(:,7)],'Type','Spearman','Rows','complete');
    [zeroorder_rho, zeroorder_p]=corr([pca_SCORE(:,pcc_possiblecomb(i,1)) totalforcorr(:,7)],'Type','Spearman','Rows','complete');
     
    
    
%     
%     pcc_rho=array2table(pcc_rho,'VariableNames',totalforcorrlabels([pcc_possiblecomb(i,1), pcc_possiblecomb(i,2), 7]),'RowNames',totalforcorrlabels([pcc_possiblecomb(i,1), pcc_possiblecomb(i,2), 7]));
%     pcc_pval=array2table(pcc_pval,'VariableNames',totalforcorrlabels([pcc_possiblecomb(i,1), pcc_possiblecomb(i,2), 7]),'RowNames',totalforcorrlabels([pcc_possiblecomb(i,1), pcc_possiblecomb(i,2), 7]));
%     
        
%     
%     pcc_total(i,1)={pcc_rho};
%     pcc_total(i,2)={pcc_pval};
      pcc_total(i,1)={'rho:'};
      pcc_total(i,2)={round(pcc_rho(1,3),3)};
      pcc_total(i,3)={'p-value:'};
      pcc_total(i,4)={round(pcc_pval(1,3),3)};
      pcc_total(i,5)={['aim X PC' num2str(pcc_possiblecomb(i,1))]};
      pcc_total(i,6)={['corrected for PC' num2str(pcc_possiblecomb(i,2))]};
      pcc_total(i,7)={'zero order corr:'};
      pcc_total(i,8)={'rho:'};
      pcc_total(i,9)={round(zeroorder_rho(1,2),3)};
      pcc_total(i,10)={'p-value:'};
      pcc_total(i,11)={round(zeroorder_p(1,2),3)};
      pcc_total(i,12)={'0-order minus partial rho:'};
      pcc_total(i,13)={round(pcc_total{i,9},3)-round(pcc_total{i,2},3)};
%   
    
%     disp(pcc_total{i,2})
end

%% ranked selection approach for PC1:6 --> GLM
clc
clearvars pcc_total pcc_rho_b pcc_pval_b pcc_rho others included_PCs_doublecheck included_PCs reihenfolge pcc_pval pcc_possiblecomb pcc_pval_temp pcc_rho_temp zeroorder_rho zeroorder_p
counter=0;
for i=1:size(pca_SCORE,2)
    [zeroorder_rho(i), zeroorder_p(i)]=corr(pca_SCORE(:,i), totalforcorr(:,7),'Type','Spearman','Rows','complete');
end

[~, reihenfolge]=sort(abs(zeroorder_rho),'descend');

% reihenfolge ist jetzt absteigend die zeroordercorr von PCs.
% weiteres vorgehen: stepwise reinnehmen solange p>0.05 bleibt wenn
% korrigiert wird für das, das schon drin ist. 
included_PCs=[reihenfolge(1)];
for i=2:6 % den ersten braucht man ja nicht
    included_PCs=[included_PCs reihenfolge(i)];
    [pcc_rho(i-1), pcc_pval(i-1)]=partialcorr(pca_SCORE(:,reihenfolge(i)), totalforcorr(:,7), pca_SCORE(:,included_PCs(1:end-1)),'Type','Spearman','Rows','complete');
    if pcc_pval(i-1)>.05
        included_PCs=included_PCs(1:end-1);
    end
end
included_PCs_doublecheck=[];
for i=1:size(included_PCs,2)
    included_PCs_doublecheck=[included_PCs_doublecheck included_PCs(i)];
    others=[1:size(included_PCs,2)];
    others=others(find(others~=i));
    [pcc_rho_b(i), pcc_pval_b(i)]=partialcorr(pca_SCORE(:,included_PCs(i)), totalforcorr(:,7), pca_SCORE(:,included_PCs(others)),'Type','Spearman','Rows','complete');
    if pcc_pval_b(i)>.05
        included_PCs_doublecheck=included_PCs_doublecheck(1:end-1);
    end
end


for cutoff=0:3
clearvars glm_partition glm_final glm_X glm_Y glm_T glm_AUC glm_optrocpt colorcode glm_pred glm_resp
colorcode=totalforcorr(:,7);
colorcode(colorcode<=cutoff)=0;
colorcode(colorcode>cutoff)=1;
glm_pred=pca_SCORE(:,included_PCs_doublecheck);
glm_resp=colorcode;

rng(666)
glm_partition=cvpartition(size(glm_resp,1),'k',10);
% rng(666)
% glm_partition=cvpartition(size(glm_resp,1),'LeaveOut');


for i=1:glm_partition.NumTestSets
    glm_final(1,i)={glm_resp(test(glm_partition,i))};
    glm_final(2,i)={predict(fitglm(glm_pred(training(glm_partition,i),:),glm_resp(training(glm_partition,i)),'Distribution','Binomial','Link','logit'), glm_pred(test(glm_partition,i),:))};
    
end

[glm_X, glm_Y, glm_T, glm_AUC, glm_optrocpt]=perfcurve(glm_final(1,:),glm_final(2,:),1); % kein bootstrap sonder alle k-folds

figure('Name',sprintf('GLM with partl. corr. selected PCs for AIM>%i, validation type=%s, testsets=%i',cutoff,glm_partition.Type, glm_partition.NumTestSets))
subplot(1,2,1)
hold on
plot(glm_X(:,2:3), glm_Y(:,2:3),'Color',[.5 .5 .5]) % ci
plot(glm_X(:,1), glm_Y(:,1),'k') % mean
plot([0 1],[glm_optrocpt(2) glm_optrocpt(2)],'k')
plot([glm_optrocpt(1) glm_optrocpt(1)],[0 1],'k')
legend(num2str(glm_AUC),'Location','best')
xlabel('false positive rate (1-specificity)'); ylabel('true positive rate (sensitivity)')
xlim([0 1]); ylim([0 1]); axis tight; axis square
hold off
subplot(1,2,2)
plot(glm_X(:,1), glm_T)
legend(sprintf('sens: %.2f spez: %.2f',(1-glm_optrocpt(1))*100,(glm_optrocpt(2))*100),'Location','best')
xlabel('false positive rate (1-specificity)'); ylabel('threshold')
axis tight; axis square
drawnow
end
%% ranked selection approach for all param --> GLM
clc
clearvars pcc_total pcc_rho_b pcc_pval_b pcc_rho others included_PCs_doublecheck included_PCs reihenfolge pcc_pval pcc_possiblecomb pcc_pval_temp pcc_rho_temp zeroorder_rho zeroorder_p
totalforcorr_pred=totalforcorr(:,[1 2 3 4 5 6 8 9]);
totalforcorr_res=totalforcorr(:,7);
totalforcorr_pred_label=totalforcorrlabels(:,[1 2 3 4 5 6 8 9]);
totalforcorr_res_label=totalforcorrlabels(:,7);
counter=0;
for i=1:size(totalforcorr_pred,2)
    [zeroorder_rho(i), zeroorder_p(i)]=corr(totalforcorr_pred(:,i), totalforcorr_res,'Type','Spearman','Rows','complete');
end

[~, reihenfolge]=sort(abs(zeroorder_rho),'descend');
%totalforcorr_pred_label{reihenfolge}

% reihenfolge ist jetzt absteigend die zeroordercorr von params..
% weiteres vorgehen: stepwise reinnehmen solange p>0.05 bleibt wenn
% korrigiert wird für das, das schon drin ist. 
included_PCs=[reihenfolge(1)];
for i=2:size(totalforcorr_pred,2) % den ersten braucht man ja nicht
    included_PCs=[included_PCs reihenfolge(i)];
    [pcc_rho(i-1), pcc_pval(i-1)]=partialcorr(totalforcorr_pred(:,reihenfolge(i)), totalforcorr_res, totalforcorr_pred(:,included_PCs(1:end-1)),'Type','Spearman','Rows','complete');
    if pcc_pval(i-1)>.05
        included_PCs=included_PCs(1:end-1);
    end
end
included_PCs_doublecheck=[]; 
% jetzt nochmal die die drin sind untereinander 
% checken ob etwas verworfen werden kann --> wird für ein parameter
% das p grösser 0.05 wenn ich für die anderen werte korrigiere?
for i=1:size(included_PCs,2)
    included_PCs_doublecheck=[included_PCs_doublecheck included_PCs(i)];
    others=[1:size(included_PCs,2)];
    others=others(find(others~=i));
    [pcc_rho_b(i), pcc_pval_b(i)]=partialcorr(totalforcorr_pred(:,included_PCs(i)), totalforcorr_res, totalforcorr_pred(:,included_PCs(others)),'Type','Spearman','Rows','complete');
    if pcc_pval_b(i)>.05
        included_PCs_doublecheck=included_PCs_doublecheck(1:end-1);
    end
end


for cutoff=0:3
clearvars glm_partition glm_final glm_X glm_Y glm_T glm_AUC glm_optrocpt colorcode glm_pred glm_resp
colorcode=totalforcorr(:,7);
colorcode(colorcode<=cutoff)=0;
colorcode(colorcode>cutoff)=1;
glm_pred=totalforcorr_pred(:,included_PCs_doublecheck);
glm_resp=colorcode;

% rng(666)
% glm_partition=cvpartition(size(glm_resp,1),'k',10);
rng(666)
glm_partition=cvpartition(size(glm_resp,1),'LeaveOut');


for i=1:glm_partition.NumTestSets
    glm_final(1,i)={glm_resp(test(glm_partition,i))};
    glm_final(2,i)={predict(fitglm(glm_pred(training(glm_partition,i),:),glm_resp(training(glm_partition,i)),'Distribution','Binomial','Link','logit'), glm_pred(test(glm_partition,i),:))};
    
end

[glm_X, glm_Y, glm_T, glm_AUC, glm_optrocpt]=perfcurve(glm_final(1,:),glm_final(2,:),1); % kein bootstrap sonder alle k-folds

figure('Name',sprintf('GLM with partl. corr. selected params for AIM>%i, validation type=%s, testsets=%i',cutoff,glm_partition.Type, glm_partition.NumTestSets))
subplot(1,2,1)
hold on
plot(glm_X(:,2:3), glm_Y(:,2:3),'b') % ci
plot(glm_X(:,1), glm_Y(:,1),'r') % mean
legend(num2str(glm_AUC),'Location','best')
xlabel('false positive rate (1-specificity)'); ylabel('true positive rate (sensitivity)')
xlim([0 1]); ylim([0 1]); axis tight
hold off
subplot(1,2,2)
plot(glm_X(:,1), glm_T)
legend(sprintf('sens: %.2f spez: %.2f',(1-glm_optrocpt(1))*100,(glm_optrocpt(2))*100),'Location','best')
xlabel('false positive rate (1-specificity)'); ylabel('threshold')
axis tight
drawnow
end


%% über zeit, alle nur ldopa.

% 
% 
% a=a-(mean(a));
% b=b-(mean(b));
% ptsx=linspace(0,prctile(a,100),51);
% ptsy=linspace(0,prctile(b,100),51);
% ptsx=linspace(0,5,51);
% ptsy=linspace(0,2,51);
% [N,~,~,indA,indB]=histcounts2(a,b,ptsx,ptsy);
% 
% [xG,yG]=meshgrid(-5:5);
% mysigma=2.5;
% g=exp(-xG.^2./(2.*mysigma.^2)-yG.^2./(2.*mysigma.^2));
% g=g./sum(g(:));
% 
% subplot(1,2,1)
% scatter(a,b,'.')
% subplot(1,2,2)
% imagesc(ptsx,ptsy,conv2(N,g,'same'));
% set(gca,'Ydir','normal')
% 



