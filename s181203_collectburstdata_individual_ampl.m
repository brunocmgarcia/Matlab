%%s181203_collectburstdata_individual_ampl // +rate

clear all
close all 
clc

% for AMPL: % histogram_einstellungMax=150 %(2500 );%5e+6;
histogram_einstellungMax=3;
histogram_einstellung=0:histogram_einstellungMax/3:histogram_einstellungMax;
histogram_einstellung=[histogram_einstellung inf];

histogram_einstellung_norm='probability';


load VAR_baselineschluessel
baselineschluessel=baselineschluessel(10:end,:);
cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/180/burstCenterOfMass')
ordner=dir('*.mat');
files={ordner.name}';

for file_i=1:length(baselineschluessel)
    
    datei180=baselineschluessel(file_i,1);
    datei180=datei180{:}(1:end-18);
    datei180=[datei180 '_burst.mat']
    datei10=baselineschluessel(file_i,2);
    datei10=datei10{:}(1:end-18);
    datei10=[datei10 '_burst.mat']
    load(datei180)
    basestruct=load(['/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/Ruhe10/burstCenterOfMass/' datei10]);
    baserate(file_i)=length(basestruct.rs_NumBlockStart)/(length(basestruct.datrectsmooth(basestruct.datrectsmooth~=0))/500);
    if length(datrectsmooth)>3900000
        datrectsmooth4rate=datrectsmooth(1500000:3900000);% 50-130min
    else
        datrectsmooth4rate=datrectsmooth(1500000:end);
    end
    length(datrectsmooth)
    rate(file_i)=length(rs_NumBlockStart)/(length(datrectsmooth4rate(datrectsmooth4rate~=0))/500); %weil 3000:7800 sekunden ausschnitt
    clearvars datrectsmooth4rate
    P75rs=basestruct.P75rs; %set P75 to baseline P75

    for i=1:length(basestruct.rs_NumBlockStart)
        ausschnitt=basestruct.datrectsmooth(basestruct.rs_NumBlockStart(i):basestruct.rs_NumBlockEnd(i))-P75rs;
        maxheightBL(1,i)=max(ausschnitt);
        AUCBL(1,i)=trapz(ausschnitt,2);
    end
    clearvars ausschnitt i
    
    for i=1:length(rs_NumBlockStart)
        ausschnitt=datrectsmooth(rs_NumBlockStart(i):rs_NumBlockEnd(i))-P75rs;
        maxheight(1,i)=max(ausschnitt);
        AUC(1,i)=trapz(ausschnitt,2);
    end
    clearvars ausschnitt i
    
    figure
    subplot(1,2,1)
  %ampl%  myhist180=histogram(AUC, histogram_einstellung,  'Normalization', histogram_einstellung_norm);
    myhist180=histogram(maxheight, histogram_einstellung,  'Normalization', histogram_einstellung_norm);

    subplot(1,2,2)
 %ampl%   myhist10=histogram(AUCBL, histogram_einstellung,  'Normalization', histogram_einstellung_norm);
    myhist10=histogram(maxheightBL, histogram_einstellung,  'Normalization', histogram_einstellung_norm);

    totalbinprob180(file_i,:)=myhist180.Values;
    totalbinprob10(file_i,:)=myhist10.Values;
    totalp75_180(file_i,:)=P75rs;
    totalp75_10(file_i,:)=basestruct.P75rs;
    
    LDaverageAUC(file_i,:)=mean(AUC);
    BLaverageAUC(file_i,:)=mean(AUCBL);
    lengthBL=basestruct.rs_NumBlockLength;
    lengthLD=rs_NumBlockLength;
    LDaverageLength(file_i,:)=mean(lengthLD);
    BLaverageLength(file_i,:)=mean(lengthBL);
    LDaverageMaxHeigth(file_i,:)=mean(maxheight);
    BLaverageMaxHeigth(file_i,:)=mean(maxheightBL);
    
%    save(['/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/180/burstCenterOfMass/correlation/' num2str(file_i)],'AUC','AUCBL','maxheightBL','maxheight', 'lengthLD','lengthBL');
close all
clearvars -except BLaverageMaxHeigth LDaverageMaxHeigth rate LDaverageLength BLaverageLength baserate BLaverageAUC LDaverageAUC totalp75_10 totalp75_180 totalbinprob180 histogram_einstellung_norm histogram_einstellung totalbinprob10 files file_i baselineschluessel
end

%%
excludeanimals1=find(contains(baselineschluessel(:,1),'CG05'));
excludeanimals2=find(contains(baselineschluessel(:,1),'CG09'));
excludeanimals3=find(contains(baselineschluessel(:,1),'CG08'));
%excludeanimals1=[]; %rausnehmen bei bedarf
%excludeanimals2=[];
excludeanimals3=[];
excludeanimals=[excludeanimals1; excludeanimals2; excludeanimals3;];

%animals=['CG04';'CG05';'CG06';'CG07';'CG08';'CG09';'CG10']; % händisch
animals=['CG04';'CG06';'CG07';'CG08';'CG10'];


TP101=find(contains(baselineschluessel(:,1),'101'));
TP101=setdiff(TP101,excludeanimals);

TP104=find(contains(baselineschluessel(:,1),'104'));
TP104=setdiff(TP104,excludeanimals);

TP110=find(contains(baselineschluessel(:,1),'110'));
TP110=setdiff(TP110,excludeanimals);

TP116=find(contains(baselineschluessel(:,1),'116'));
TP116=setdiff(TP116,excludeanimals);

TP121=find(contains(baselineschluessel(:,1),'121'));
TP121=setdiff(TP121,excludeanimals);

TP300=find(contains(baselineschluessel(:,1),'300'));
TP300=setdiff(TP300,excludeanimals);

TP400=find(contains(baselineschluessel(:,1),'400'));
TP400=setdiff(TP400,excludeanimals);

%% individual animals individual histograms for LD and BL, maxheight
baselinefig=figure('Name', 'Baseline','Units','Normalized','Position',[0 0 1 1]);
ldopafig=figure('Name', 'LDopa','Units','Normalized','Position',[0 0 1 1]);


for i=1:length(TP101)  
mean10TP101=totalbinprob10(TP101(i,1),:);
mean180TP101=totalbinprob180(TP101(i,1),:);
mean10TP104=totalbinprob10(TP104(i,1),:);
mean180TP104=totalbinprob180(TP104(i,1),:);
mean10TP110=totalbinprob10(TP110(i,1),:);
mean180TP110=totalbinprob180(TP110(i,1),:);
mean10TP116=totalbinprob10(TP116(i,1),:);
mean180TP116=totalbinprob180(TP116(i,1),:);
mean10TP121=totalbinprob10(TP121(i,1),:);
mean180TP121=totalbinprob180(TP121(i,1),:);
mean10TP300=totalbinprob10(TP300(i,1),:);
mean180TP300=totalbinprob180(TP300(i,1),:);
mean10TP400=totalbinprob10(TP400(i,1),:);
mean180TP400=totalbinprob180(TP400(i,1),:);


p75_10TP101=totalp75_10(TP101(i,1),:);
p75_10TP104=totalp75_10(TP104(i,1),:);
p75_10TP110=totalp75_10(TP110(i,1),:);
p75_10TP116=totalp75_10(TP116(i,1),:);
p75_10TP121=totalp75_10(TP121(i,1),:);
p75_10TP300=totalp75_10(TP300(i,1),:);
p75_10TP400=totalp75_10(TP400(i,1),:);


meandevelopment=[mean10TP101;mean180TP101; mean180TP104; mean180TP110; mean180TP116; ...
    mean180TP121; mean180TP300; mean180TP400]';

baselinedev=[mean10TP101; mean10TP104; mean10TP110; mean10TP116; ...
    mean10TP121; mean10TP300; mean10TP400]';


figure(baselinefig);
subplot(2,4,i)
title(['Baseline burst development animal #' animals(i,:)])
hold on
baselineforplot=baselinedev;
% baselineforplot(11,:)=sum(baselineforplot(11:end,:),1);
% baselineforplot(12:end,:)=[];
if i==1
    totalbaselineforplot=baselineforplot;
else
    totalbaselineforplot=cat(3,totalbaselineforplot,baselineforplot);
end
bar(baselineforplot,'BarWidth',0.5,'EdgeColor','none');

xticklabels(split(cellstr([num2str(histogram_einstellung(2:end-1)) ' >' num2str(histogram_einstellung(end-1))]))')
xticks(1:length(histogram_einstellung)-1)
xlabel('burst height zscore')
ylabel(histogram_einstellung_norm)
legend({'TP101','TP104','TP110','TP116', 'TP121', 'D1ant', 'D2ant'})
hold off

figure(ldopafig);
subplot(2,4,i)
title(['burst development animal #' animals(i,:)])
hold on
ldopaforplot=meandevelopment;
% ldopaforplot(11,:)=sum(ldopaforplot(11:end,:),1);
% ldopaforplot(12:end,:)=[];
if i==1
    totalLDopaProb=ldopaforplot;
else
    totalLDopaProb=cat(3,totalLDopaProb,ldopaforplot);
end
bar(ldopaforplot,'BarWidth',0.5,'EdgeColor','none');

xticklabels(split(cellstr([num2str(histogram_einstellung(2:end-1)) ' >' num2str(histogram_einstellung(end-1))]))')
xticks(1:length(histogram_einstellung)-1)
xlabel('burst height zscore')
ylabel(histogram_einstellung_norm)


legend({'TP101BL','TP101','TP104','TP110','TP116', 'TP121', 'D1ant', 'D2ant'})

hold off
end

%% Average burst development histograms, individual for LD and BL
figure('Units','Normalized','Position',[0 0 1 1]);
title('Average Baseline burst development')
hold on
bar(squeeze(mean(totalbaselineforplot,3)),'BarWidth',0.5,'EdgeColor','none');
xticklabels(split(cellstr([num2str(histogram_einstellung(2:end-1)) ' >' num2str(histogram_einstellung(end-1))]))')
xticks(1:length(histogram_einstellung)-1);
xlabel('burst height zscore')
ylabel(histogram_einstellung_norm)
ngroups=size(squeeze(mean(totalbaselineforplot,3)),1);
nbars=size(squeeze(mean(totalbaselineforplot,3)),2);
groupwidth=min(0.8, nbars/(nbars+1.5));
BLerrorbarx=squeeze(mean(permute(totalbaselineforplot,[3 1 2]),1));
BLerrorbary=squeeze(std(permute(totalbaselineforplot,[3 1 2])));
for i=1:nbars
    x=(1:ngroups)-groupwidth/2+(2*i-1)*groupwidth/(2*nbars);
    
    errorbar(x,BLerrorbarx(:,i),[],BLerrorbary(:,i),'k','linestyle','none');
end
legend({'TP101','TP104','TP110','TP116', 'TP121', 'D1ant', 'D2ant'})
hold off


figure('Units','Normalized','Position',[0 0 1 1]);
title('Average L-Dopa burst development')
hold on
bar(squeeze(mean(totalLDopaProb,3)),'BarWidth',0.5,'EdgeColor','none');
xticklabels(split(cellstr([num2str(histogram_einstellung(2:end-1)) ' >' num2str(histogram_einstellung(end-1))]))')
xticks(1:length(histogram_einstellung)-1);

xlabel('burst height zscore')
ylabel(histogram_einstellung_norm)
ngroups=size(squeeze(mean(totalLDopaProb,3)),1);
nbars=size(squeeze(mean(totalLDopaProb,3)),2);
groupwidth=min(0.8, nbars/(nbars+1.5));
LDerrorbarx=squeeze(mean(permute(totalLDopaProb,[3 1 2]),1));
LDerrorbary=squeeze(std(permute(totalLDopaProb,[3 1 2])));
for i=1:nbars
    x=(1:ngroups)-groupwidth/2+(2*i-1)*groupwidth/(2*nbars);
    
    errorbar(x,LDerrorbarx(:,i),[],LDerrorbary(:,i),'k','linestyle','none');
end
legend({'TP101BL','TP101','TP104','TP110','TP116', 'TP121', 'D1ant', 'D2ant'})
hold off


%% average amplitudes as AUC for LD and BL
figure('Units','Normalized','Position',[0 0 1 1]);
subplot(1,2,1)
title('Average Baseline burst amplitude')
hold on
meanBLaverageAUC=mean(...
    [BLaverageAUC(TP101),...
    BLaverageAUC(TP104),...
    BLaverageAUC(TP110),...
    BLaverageAUC(TP116),...
    BLaverageAUC(TP121),...
    BLaverageAUC(TP300),...
    BLaverageAUC(TP400)],1);
stdBLaverageAUC=std(...
    [BLaverageAUC(TP101),...
    BLaverageAUC(TP104),...
    BLaverageAUC(TP110),...
    BLaverageAUC(TP116),...
    BLaverageAUC(TP121),...
    BLaverageAUC(TP300),...
    BLaverageAUC(TP400)]);

bar(meanBLaverageAUC,'BarWidth',0.5,'EdgeColor','none','FaceColor','black');
xticklabels({'TP101','TP104','TP110','TP116', 'TP121', 'D1ant', 'D2ant'})
xticks(1:7)
ylabel('burst amplitude [AUC]')
ylim([0 1600])
errorbar(1:7,meanBLaverageAUC,[],stdBLaverageAUC,'k','linestyle','none');
hold off

subplot(1,2,2)
title('Average L-Dopa burst amplitude')
hold on
meanLDaverageAUC=mean(...
    [LDaverageAUC(TP101),...
    LDaverageAUC(TP104),...
    LDaverageAUC(TP110),...
    LDaverageAUC(TP116),...
    LDaverageAUC(TP121),...
    LDaverageAUC(TP300),...
    LDaverageAUC(TP400)],1);
stdLDaverageAUC=std(...
    [LDaverageAUC(TP101),...
    LDaverageAUC(TP104),...
    LDaverageAUC(TP110),...
    LDaverageAUC(TP116),...
    LDaverageAUC(TP121),...
    LDaverageAUC(TP300),...
    LDaverageAUC(TP400)]);

bar(meanLDaverageAUC,'BarWidth',0.5,'EdgeColor','none','FaceColor','black');
xticklabels({'TP101','TP104','TP110','TP116', 'TP121', 'D1ant', 'D2ant'})
xticks(1:7)
ylabel('burst amplitude [AUC]')
ylim([0 1600])
errorbar(1:7,meanLDaverageAUC,[],stdLDaverageAUC,'k','linestyle','none');
hold off

%% average amplitudes as AUC for LD and BL as grouped bars

figure
hold on;
kombiniertaverageAUC=[meanBLaverageAUC',meanLDaverageAUC'];
kombiniertaverageAUCplot=bar(kombiniertaverageAUC,'BarWidth',0.8);
kombiniertaverageAUCplotstd=[stdBLaverageAUC',stdLDaverageAUC'];
kombiniertaverageAUCplotstd=kombiniertaverageAUCplotstd/(sqrt(5));


  for i=1:2:length(kombiniertaverageAUCplot)
        set(kombiniertaverageAUCplot(1,i),'FaceColor',[0 0 0]);
        set(kombiniertaverageAUCplot(1,i),'EdgeColor',[0 0 0], 'LineWidth', 1); 

   end
        for i=2:2:length(kombiniertaverageAUCplot)
        set(kombiniertaverageAUCplot(1,i),'FaceColor',[.5 .5 .5])
        set(kombiniertaverageAUCplot(1,i),'EdgeColor',[.5 .5 .5], 'LineWidth', 1) %farbenkombiniert(i,:)
 
        end

ngroups=7;
nbars=2;
groupwidth=min(0.8, nbars/(nbars+1.5));
for i=1:nbars
    x=(1:ngroups)-groupwidth/2+(2*i-1)*groupwidth/(2*nbars);
    
    errorbar(x,kombiniertaverageAUC(:,i),[],kombiniertaverageAUCplotstd(:,i),'k','linestyle','none');
end     
        
ylim([0 1400]);         
xticks([1:7])
yticks([0:200:1400])
xticklabels({'l-dopa 1','l-dopa 4','l-dopa 10','l-dopa 16', 'l-dopa 21', 'raclopride', 'halobenzazepine'})
ylabel('burst amplitude [AUC]')
legend({'respective baselines','50-130min post injection'},'Location','best') 
hold off;

%% average amplitudes as MaxHeight for LD and BL SEM
figure('Units','Normalized','Position',[0 0 1 1]);
subplot(1,2,1)
title('Average Baseline burst amplitude zscore')
hold on
meanBLaverageMaxHeigth=mean(...
    [BLaverageMaxHeigth(TP101),...
    BLaverageMaxHeigth(TP104),...
    BLaverageMaxHeigth(TP110),...
    BLaverageMaxHeigth(TP116),...
    BLaverageMaxHeigth(TP121),...
    BLaverageMaxHeigth(TP300),...
    BLaverageMaxHeigth(TP400)],1);
stdBLaverageMaxHeigth=std(...
    [BLaverageMaxHeigth(TP101),...
    BLaverageMaxHeigth(TP104),...
    BLaverageMaxHeigth(TP110),...
    BLaverageMaxHeigth(TP116),...
    BLaverageMaxHeigth(TP121),...
    BLaverageMaxHeigth(TP300),...
    BLaverageMaxHeigth(TP400)]);

bar(meanBLaverageMaxHeigth,'BarWidth',0.5,'EdgeColor','none','FaceColor','black');
xticklabels({'TP101','TP104','TP110','TP116', 'TP121', 'D1ant', 'D2ant'})
xticks(1:7)
ylabel('burst amplitude [zscore]')
%ylim([0 1600])
errorbar(1:7,meanBLaverageMaxHeigth,[],stdBLaverageMaxHeigth,'k','linestyle','none');
hold off

subplot(1,2,2)
title('Average L-Dopa burst amplitude zscore')
hold on
meanLDaverageMaxHeigth=mean(...
    [LDaverageMaxHeigth(TP101),...
    LDaverageMaxHeigth(TP104),...
    LDaverageMaxHeigth(TP110),...
    LDaverageMaxHeigth(TP116),...
    LDaverageMaxHeigth(TP121),...
    LDaverageMaxHeigth(TP300),...
    LDaverageMaxHeigth(TP400)],1);
stdLDaverageMaxHeigth=std(...
    [LDaverageMaxHeigth(TP101),...
    LDaverageMaxHeigth(TP104),...
    LDaverageMaxHeigth(TP110),...
    LDaverageMaxHeigth(TP116),...
    LDaverageMaxHeigth(TP121),...
    LDaverageMaxHeigth(TP300),...
    LDaverageMaxHeigth(TP400)]);

bar(meanLDaverageMaxHeigth,'BarWidth',0.5,'EdgeColor','none','FaceColor','black');
xticklabels({'TP101','TP104','TP110','TP116', 'TP121', 'D1ant', 'D2ant'})
xticks(1:7)
ylabel('burst amplitude [zscore]')
%ylim([0 1600])
errorbar(1:7,meanLDaverageMaxHeigth,[],stdLDaverageMaxHeigth,'k','linestyle','none');
hold off

%% average amplitudes as MaxHeight for LD and BL as grouped bars SEM

figure
hold on;
kombiniertaverageMaxHeight=[meanBLaverageMaxHeigth',meanLDaverageMaxHeigth'];
kombiniertaverageMaxHeightplot=bar(kombiniertaverageMaxHeight,'BarWidth',0.8);
kombiniertaverageMaxHeightplotstd=[stdBLaverageMaxHeigth',stdLDaverageMaxHeigth'];
kombiniertaverageMaxHeightplotstd=kombiniertaverageMaxHeightplotstd/(sqrt(5));


  for i=1:2:length(kombiniertaverageMaxHeightplot)
        set(kombiniertaverageMaxHeightplot(1,i),'FaceColor',[0 0 0]);
        set(kombiniertaverageMaxHeightplot(1,i),'EdgeColor',[0 0 0], 'LineWidth', 1); 

   end
        for i=2:2:length(kombiniertaverageMaxHeightplot)
        set(kombiniertaverageMaxHeightplot(1,i),'FaceColor',[.5 .5 .5])
        set(kombiniertaverageMaxHeightplot(1,i),'EdgeColor',[.5 .5 .5], 'LineWidth', 1) %farbenkombiniert(i,:)
 
        end

ngroups=7;
nbars=2;
groupwidth=min(0.8, nbars/(nbars+1.5));
for i=1:nbars
    x=(1:ngroups)-groupwidth/2+(2*i-1)*groupwidth/(2*nbars);
    
    errorbar(x,kombiniertaverageMaxHeight(:,i),[],kombiniertaverageMaxHeightplotstd(:,i),'k','linestyle','none');
end     
        
%ylim([0 1400]);         
xticks([1:7])
%yticks([0:200:1400])
xticklabels({'l-dopa 1','l-dopa 4','l-dopa 10','l-dopa 16', 'l-dopa 21', 'raclopride', 'halobenzazepine'})
ylabel('burst amplitude [zscore]')
legend({'respective baselines','50-130min post injection'},'Location','best') 
hold off;



%% grouplevel burst development zscore histograms, grouped histogram view. SEM!

finalfig=figure('Name','Burst Amp Probability Baseline vs. L-Dopa, SEM!', 'Units','Normalized','Position',[0 0 1 1]);
hold on
kombiniert=[squeeze(mean(totalLDopaProb(:,2:end,:),3)) squeeze(mean(totalbaselineforplot,3))];
kombiniert(:,2:2:end)=squeeze(mean(totalLDopaProb(:,2:end,:),3));
kombiniert(:,1:2:end)=squeeze(mean(totalbaselineforplot,3));
kombinierterbarplot=bar(kombiniert,'BarWidth',0.5,'EdgeColor','none');
xticklabels(split(cellstr([num2str(histogram_einstellung(2:end-1)) ' >' num2str(histogram_einstellung(end-1))])))
xticks(1:length(histogram_einstellung))
xlabel('burst amplitude [ZSCORE above 75th prctl bl zscore]')
ylabel(histogram_einstellung_norm)
farbenkombiniert=parula(7);
farbenkombiniert=[farbenkombiniert;farbenkombiniert];
farbenkombiniert(1:2:end,:)=parula(7);
farbenkombiniert(2:2:end,:)=parula(7);
   for i=1:length(kombinierterbarplot)
        set(kombinierterbarplot(1,i),'FaceColor',farbenkombiniert(i,:));
        set(kombinierterbarplot(1,i),'EdgeColor',farbenkombiniert(i,:), 'LineWidth', 1); 

   end
        for i=1:2:length(kombinierterbarplot)
        set(kombinierterbarplot(1,i),'FaceColor','none')
        set(kombinierterbarplot(1,i),'EdgeColor',farbenkombiniert(i,:), 'LineWidth', 1) %farbenkombiniert(i,:)
 
        end
ngroups=size(kombiniert,1);
nbars=size(kombiniert,2);
groupwidth=min(0.8, nbars/(nbars+1.5));
LDerrorbarx=[squeeze(mean(permute(totalLDopaProb(:,2:end,:),[3 1 2]),1)), squeeze(mean(permute(totalbaselineforplot,[3 1 2]),1))];
LDerrorbarx(:,2:2:end)=squeeze(mean(permute(totalLDopaProb(:,2:end,:),[3 1 2]),1));
LDerrorbarx(:,1:2:end)=squeeze(mean(permute(totalbaselineforplot,[3 1 2]),1));
LDerrorbary=[squeeze(std(permute(totalLDopaProb(:,2:end,:),[3 1 2]))), squeeze(std(permute(totalbaselineforplot,[3 1 2])))];
LDerrorbary(:,2:2:end)=(squeeze(std(permute(totalLDopaProb(:,2:end,:),[3 1 2])))/sqrt(5)); % cave: nur hier als SEM
LDerrorbary(:,1:2:end)=(squeeze(std(permute(totalbaselineforplot,[3 1 2])))/sqrt(5)); %SEM!
for i=1:nbars
    x=(1:ngroups)-groupwidth/2+(2*i-1)*groupwidth/(2*nbars);
    
    errorbar(x,LDerrorbarx(:,i),[],LDerrorbary(:,i),'k','linestyle','none','CapSize',2);
end
legend(kombinierterbarplot(1,[1 2:2:end]),{'Individual Baselines','TP101','TP104','TP110','TP116', 'TP121', 'D1ant', 'D2ant'},'Location','northeast') 
hold off
%ylim([0 1])

%% baserate SEM
baserate=baserate';
rate=rate';
for i=1:length(TP101)  
rate10TP101=baserate(TP101(i,1),:);
rate180TP101=rate(TP101(i,1),:);
rate10TP104=baserate(TP104(i,1),:);
rate180TP104=rate(TP104(i,1),:);
rate10TP110=baserate(TP110(i,1),:);
rate180TP110=rate(TP110(i,1),:);
rate10TP116=baserate(TP116(i,1),:);
rate180TP116=rate(TP116(i,1),:);
rate10TP121=baserate(TP121(i,1),:);
rate180TP121=rate(TP121(i,1),:);
rate10TP300=baserate(TP300(i,1),:);
rate180TP300=rate(TP300(i,1),:);
rate10TP400=baserate(TP400(i,1),:);
rate180TP400=rate(TP400(i,1),:);
ratedevelopment=[rate180TP101; rate180TP104; rate180TP110; rate180TP116; ...
    rate180TP121; rate180TP300; rate180TP400]';

baselineratedevelopment=[rate10TP101; rate10TP104; rate10TP110; rate10TP116; ...
    rate10TP121; rate10TP300; rate10TP400]';
if i==1
    totalbaselineratedevelopment=baselineratedevelopment;
else
    totalbaselineratedevelopment=cat(1,totalbaselineratedevelopment,baselineratedevelopment);
end
if i==1
    totalratedevelopment=ratedevelopment;
else
    totalratedevelopment=cat(1,totalratedevelopment,ratedevelopment);
end
end

figure('Name','base rate development, SEM!');
hold on;
kombiniertrate=[mean(totalbaselineratedevelopment,1)',mean(totalratedevelopment,1)'];
kombiniertrateplot=bar(kombiniertrate,'BarWidth',0.8);
kombiniertrateplotstds=[std(totalbaselineratedevelopment,1)',std(totalratedevelopment,1)'];
kombiniertrateplotstds=kombiniertrateplotstds/sqrt(5);
%errorbar(1:7,mean(totalratedevelopment,1),[],std(totalratedevelopment,1),'k','linestyle','none');


  for i=1:2:length(kombiniertrateplot)
        set(kombiniertrateplot(1,i),'FaceColor',[0 0 0]);
        set(kombiniertrateplot(1,i),'EdgeColor',[0 0 0], 'LineWidth', 1); 

   end
        for i=2:2:length(kombiniertrateplot)
        set(kombiniertrateplot(1,i),'FaceColor',[.5 .5 .5])
        set(kombiniertrateplot(1,i),'EdgeColor',[.5 .5 .5], 'LineWidth', 1) %farbenkombiniert(i,:)
 
        end

ngroups=7;
nbars=2;
groupwidth=min(0.8, nbars/(nbars+1.5));
for i=1:nbars
    x=(1:ngroups)-groupwidth/2+(2*i-1)*groupwidth/(2*nbars);
    
    errorbar(x,kombiniertrate(:,i),[],kombiniertrateplotstds(:,i),'k','linestyle','none');
end     
        
ylim([0 5]);         
xticks([1:7])
yticks([0:5])
xticklabels({'l-dopa 1','l-dopa 4','l-dopa 10','l-dopa 16', 'l-dopa 21', 'raclopride', 'halobenzazepine'})
ylabel('burst rate [bursts/s]')
legend({'respective baselines','50-130min post injection'},'Location','best') 
hold off;

%% baserate SEM, grand average
totalratedevelopmentGrand=totalratedevelopment(:,1:5); % no antagonists
totalbaselineratedevelopmentGrand=totalbaselineratedevelopment(:,1:5);
totalratedevelopmentGrand=totalratedevelopmentGrand(:);
totalbaselineratedevelopmentGrand=totalbaselineratedevelopmentGrand(:);
figure
plotSingleBarSEM([totalbaselineratedevelopmentGrand totalratedevelopmentGrand])

%% average length SEM!

figure('Units','Normalized','Position',[0 0 1 1]);
subplot(1,2,1)
title('Average Baseline burst length, SEM!')
hold on
meanBLaverageLength=mean(...
    [BLaverageLength(TP101),...
    BLaverageLength(TP104),...
    BLaverageLength(TP110),...
    BLaverageLength(TP116),...
    BLaverageLength(TP121),...
    BLaverageLength(TP300),...
    BLaverageLength(TP400)],1);
stdBLaverageLength=std(...
    [BLaverageLength(TP101),...
    BLaverageLength(TP104),...
    BLaverageLength(TP110),...
    BLaverageLength(TP116),...
    BLaverageLength(TP121),...
    BLaverageLength(TP300),...
    BLaverageLength(TP400)]);

stdBLaverageLength=stdBLaverageLength/sqrt(5); %SEM bei 5 tieren

bar(meanBLaverageLength,'BarWidth',0.5,'EdgeColor','none','FaceColor','black');
xticklabels({'TP101','TP104','TP110','TP116', 'TP121', 'D1ant', 'D2ant'})
xticks(1:7)
ylabel('burst amplitude [Length]')
%ylim([0 1600])
errorbar(1:7,meanBLaverageLength,[],stdBLaverageLength,'k','linestyle','none');
hold off

subplot(1,2,2)
title('Average L-Dopa burst length')
hold on
meanLDaverageLength=mean(...
    [LDaverageLength(TP101),...
    LDaverageLength(TP104),...
    LDaverageLength(TP110),...
    LDaverageLength(TP116),...
    LDaverageLength(TP121),...
    LDaverageLength(TP300),...
    LDaverageLength(TP400)],1);
stdLDaverageLength=std(...
    [LDaverageLength(TP101),...
    LDaverageLength(TP104),...
    LDaverageLength(TP110),...
    LDaverageLength(TP116),...
    LDaverageLength(TP121),...
    LDaverageLength(TP300),...
    LDaverageLength(TP400)]);

stdLDaverageLength=stdLDaverageLength/(sqrt(5));

bar(meanLDaverageLength,'BarWidth',0.5,'EdgeColor','none','FaceColor','black');
xticklabels({'TP101','TP104','TP110','TP116', 'TP121', 'D1ant', 'D2ant'})
xticks(1:7)
ylabel('burst amplitude [Length]')
%ylim([0 1600])
errorbar(1:7,meanLDaverageLength,[],stdLDaverageLength,'k','linestyle','none');
hold off

%% kombi averages lenght SEM

figure
hold on;
kombiniertaverageLength=[meanBLaverageLength',meanLDaverageLength'];
kombiniertaverageLengthplot=bar(kombiniertaverageLength,'BarWidth',0.8);
kombiniertaverageLengthplotstd=[stdBLaverageLength',stdLDaverageLength'];
kombiniertaverageLengthplotstd=kombiniertaverageLengthplotstd/(sqrt(5)); %SEM


  for i=1:2:length(kombiniertaverageLengthplot)
        set(kombiniertaverageLengthplot(1,i),'FaceColor',[0 0 0]);
        set(kombiniertaverageLengthplot(1,i),'EdgeColor',[0 0 0], 'LineWidth', 1); 

   end
        for i=2:2:length(kombiniertaverageLengthplot)
        set(kombiniertaverageLengthplot(1,i),'FaceColor',[.5 .5 .5])
        set(kombiniertaverageLengthplot(1,i),'EdgeColor',[.5 .5 .5], 'LineWidth', 1) %farbenkombiniert(i,:)
 
        end

ngroups=7;
nbars=2;
groupwidth=min(0.8, nbars/(nbars+1.5));
for i=1:nbars
    x=(1:ngroups)-groupwidth/2+(2*i-1)*groupwidth/(2*nbars);
    
    errorbar(x,kombiniertaverageLength(:,i),[],kombiniertaverageLengthplotstd(:,i),'k','linestyle','none');
end     
        
%ylim([0 1400]);         
xticks([1:7])
%yticks([0:200:1400])
xticklabels({'l-dopa 1','l-dopa 4','l-dopa 10','l-dopa 16', 'l-dopa 21', 'raclopride', 'halobenzazepine'})
ylabel('burst length [s]')
legend({'respective baselines','50-130min post injection'},'Location','best') 
hold off;

%% burstPower X Length
clearvars x y
LDaverageLength4corr= [LDaverageLength(TP101),...
    LDaverageLength(TP104),...
    LDaverageLength(TP110),...
    LDaverageLength(TP116),...
    LDaverageLength(TP121),...
    LDaverageLength(TP300),...
    LDaverageLength(TP400)];

LDaverageAUC4corr=   [LDaverageAUC(TP101),...
    LDaverageAUC(TP104),...
    LDaverageAUC(TP110),...
    LDaverageAUC(TP116),...
    LDaverageAUC(TP121),...
    LDaverageAUC(TP300),...
    LDaverageAUC(TP400)];

LDaverageMaxHeight4corr=   [LDaverageMaxHeigth(TP101),...
    LDaverageMaxHeigth(TP104),...
    LDaverageMaxHeigth(TP110),...
    LDaverageMaxHeigth(TP116),...
    LDaverageMaxHeigth(TP121),...
    LDaverageMaxHeigth(TP300),...
    LDaverageMaxHeigth(TP400)];

y=LDaverageLength4corr(:,1:5);
x=LDaverageAUC4corr(:,1:5);

linearregression(x(:),y(:),'burst AUC','burst length',1)
hold on
scatter(x(:),y(:),40,'o','filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[.7 .7 .7])

hold off



clearvars x
x=LDaverageMaxHeight4corr(:,1:5);
linearregression(x(:),y(:),'burst maxheight','burst length',1)
hold on
scatter(x(:),y(:),40,'o','filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[.7 .7 .7])

hold off

clearvars x y

%% burstPower X AIM
load VAR_Global_AIM_matrix
AIMforcorrelation=GlobalAIMmatrix([1 3 4 5 7],[2 3 5:12],[1 2 3 4 5 7 8])
AIMforcorrelation=squeeze(mean(AIMforcorrelation(:,4:7,:),2));
x=LDaverageLength4corr(:,1:5);
y=AIMforcorrelation(:,1:5);
linearregression(x(:),y(:),'burst length','sum of aim',1)
hold on
scatter(x(:),y(:),40,'o','filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[.7 .7 .7])

hold off

x=LDaverageAUC4corr(:,1:5);
linearregression(x(:),y(:),'burst AUC','sum of aim',1)
hold on
scatter(x(:),y(:),40,'o','filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[.7 .7 .7])

hold off

x=LDaverageMaxHeight4corr(:,1:5);
linearregression(x(:),y(:),'maxheight burst','sum of aim',1)
hold on
scatter(x(:),y(:),40,'o','filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[.7 .7 .7])

hold off

%%
%save('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/180/burstCenterOfMass/correlation/key','TP101','TP104','TP110','TP116','TP121','TP300','TP400')
% totalLDopaProb=totalLDopaProb(:,2:end,:);
% %clearvars -except totalLDopaProb totalbaselineforplot
% 
% forclip=[squeeze(totalLDopaProb(1,:,:));squeeze(totalLDopaProb(2,:,:));squeeze(totalLDopaProb(3,:,:));squeeze(totalLDopaProb(4,:,:))]';
% forclip=[squeeze(totalbaselineforplot(1,:,:));squeeze(totalbaselineforplot(2,:,:));squeeze(totalbaselineforplot(3,:,:));squeeze(totalbaselineforplot(4,:,:))]';
% 
% clipboard('copy',forclip);
