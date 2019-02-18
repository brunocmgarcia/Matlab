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

%
load('/Users/guettlec/Desktop/burststruct.mat')
load VAR_baselineschluessel
baselineschluessel=baselineschluessel(10:end,:);
%

clearvars -except burststruct
close all
allLD=[1 2 4 5 7 8 9; 23 24 26 28 30 32 33; 35 36 38 40 42 44 45; 47 48 50 51 52 54 55; 66 67 69 70 71 73 74]';
starttimes=[];
height=[];
length=[];
AUC=[];
for i=1:size(allLD,1)
    for ii=1:size(allLD,2)
        starttimes{i,ii}=(burststruct(allLD(i,ii)).LD.start)./(500*60); %now minutes
        height{i,ii}=burststruct(allLD(i,ii)).LD.maxheight;
        length{i,ii}=burststruct(allLD(i,ii)).LD.length;
        AUC{i,ii}=burststruct(allLD(i,ii)).LD.AUC;
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
        end
    end
end

% hist_height_counts = cell2mat(arrayfun(@(x)permute(x{:},[3 1 2]),hist_height_counts,'UniformOutput',0));
% reshape(cat(1,A{:}),[size(C), numel(C{1})])


hist_height_counts = cell2mat(cellfun(@(x)reshape(x,1,1,1,[]),hist_height_counts,'un',0));
hist_length_counts = cell2mat(cellfun(@(x)reshape(x,1,1,1,[]),hist_length_counts,'un',0));


%% highest/lowest/longest/shortest über zeit
figure
subplot(2,2,1)
title('highest')
hold on
farbe=parula(7);
for i=1:7
    highest_mean(i,:)=[squeeze(nanmean(hist_height_counts(i,:,:,4),2))];
    highest_SEM(i,:)=[squeeze(nanstd(hist_height_counts(i,:,:,4),[],2))]./sqrt(5);  
    plot([1:10],highest_mean(i,:),'Color',farbe(i,:))
    jbfill([1:10],highest_mean(i,:)+highest_SEM(i,:),highest_mean(i,:)-highest_SEM(i,:),farbe(i,:),farbe(i,:),0,0.2);
end
hold off

subplot(2,2,2)
title('lowest')
hold on
farbe=parula(7);
for i=1:7   
    lowest_mean(i,:)=[squeeze(nanmean(hist_height_counts(i,:,:,1),2))];
    lowest_SEM(i,:)=[squeeze(nanstd(hist_height_counts(i,:,:,1),[],2))]./sqrt(5);
    plot([1:10],lowest_mean(i,:),'Color',farbe(i,:))
    jbfill([1:10],lowest_mean(i,:)+lowest_SEM(i,:),lowest_mean(i,:)-lowest_SEM(i,:),farbe(i,:),farbe(i,:),0,0.2);
end
hold off

subplot(2,2,3)
title('longest')
hold on
farbe=parula(7);
for i=1:7    
    longest_mean(i,:)=[squeeze(nanmean(hist_length_counts(i,:,:,4),2))];
    longest_SEM(i,:)=[squeeze(nanstd(hist_length_counts(i,:,:,4),[],2))]./sqrt(5);
    plot([1:10],longest_mean(i,:),'Color',farbe(i,:))
    jbfill([1:10],longest_mean(i,:)+longest_SEM(i,:),longest_mean(i,:)-longest_SEM(i,:),farbe(i,:),farbe(i,:),0,0.2);
end
hold off

subplot(2,2,4)
title('shortest')
hold on
farbe=parula(7);
for i=1:7   
    shortest_mean(i,:)=[squeeze(nanmean(hist_length_counts(i,:,:,1),2))];
    shortest_SEM(i,:)=[squeeze(nanstd(hist_length_counts(i,:,:,1),[],2))]./sqrt(5);
    plot([1:10],shortest_mean(i,:),'Color',farbe(i,:))
    jbfill([1:10],shortest_mean(i,:)+shortest_SEM(i,:),shortest_mean(i,:)-shortest_SEM(i,:),farbe(i,:),farbe(i,:),0,0.2);
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


%%
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



