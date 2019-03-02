%% s190301_burstcorr_allthebursts % 250 statt 25

clear all
close all
clc

load('/Users/guettlec/Desktop/burststruct.mat')
load VAR_baselineschluessel
baselineschluessel=baselineschluessel(10:end,:);


%clearvars -except burststruct
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

for i=1:5 %7
    for ii=1:5
        for iii=1:10
            burst_height_mean(i,ii,iii)=mean(height{i,ii}(timebins{i,ii}==iii));
            burst_length_mean(i,ii,iii)=mean(length{i,ii}(timebins{i,ii}==iii));
        end
    end
end

%% burst length X height

x=burst_length_mean(:);
y=burst_height_mean(:);
[r2_1 r2_2 pR pP sR sP]=linearregression(x,y,'burst length','burst height',1)
hold on
scatter(x,y,40,'o','filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[.7 .7 .7])
xlim([min(x) prctile(x,95)])
ylim([min(y) prctile(y,95)])

