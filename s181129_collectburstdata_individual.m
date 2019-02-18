%%s181129_collectburstdata_individual_length

clear all
close all 
clc

histogram_einstellungMax=.2; %2
histogram_einstellung=.05:histogram_einstellungMax/4:histogram_einstellungMax;
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
    P75rs=basestruct.P75rs; %set P75 to baseline P75

    
    figure()
    subplot(1,2,1)
    myhist180=histogram(rs_NumBlockLength, histogram_einstellung,  'Normalization', histogram_einstellung_norm);
    subplot(1,2,2)
    myhist10=histogram(basestruct.rs_NumBlockLength, histogram_einstellung,  'Normalization', histogram_einstellung_norm);
    totalbinprob180(file_i,:)=myhist180.Values;
    totalbinprob10(file_i,:)=myhist10.Values;
    totalp75_180(file_i,:)=P75rs;
    totalp75_10(file_i,:)=basestruct.P75rs;
    LDaveragelength(file_i,:)=mean(rs_NumBlockLength);
    BLaveragelength(file_i,:)=mean(basestruct.rs_NumBlockLength);
    BLlengthsave=basestruct.rs_NumBlockLength;
 %   save(['/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/180/burstCenterOfMass/correlation/' num2str(file_i)],'rs_NumBlockLength','BLlengthsave', '-append');

close all
clearvars -except BLaveragelength LDaveragelength totalp75_10 totalp75_180 totalbinprob180 histogram_einstellung_norm histogram_einstellung totalbinprob10 files file_i baselineschluessel
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


baselinefig=figure('Units','Normalized','Position',[0 0 1 1],'Name', 'Baseline');
ldopafig=figure('Units','Normalized','Position',[0 0 1 1],'Name', 'LDopa');


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
xticklabels(split(cellstr([num2str(histogram_einstellung(2:end-1)*1000) ' >' num2str(histogram_einstellung(end-1)*1000)]))')
xticks(1:length(histogram_einstellung)-1)
xlabel('burst length [ms]')
ylabel(histogram_einstellung_norm)
legend({'TP101','TP104','TP110','TP116', 'TP121', 'D1ant', 'D2ant'}, 'Location','best') 
ylim([0 0.6])
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

xticklabels(split(cellstr([num2str(histogram_einstellung(2:end-1)*1000) ' >' num2str(histogram_einstellung(end-1)*1000)]))')
xticks(1:length(histogram_einstellung)-1)
xlabel('burst length [ms]')
ylabel(histogram_einstellung_norm)


legend({'TP101BL','TP101','TP104','TP110','TP116', 'TP121', 'D1ant', 'D2ant'},'Location','northwest') 
ylim([0 0.6])
hold off
end

%% averages als SEM!
figure('Units','Normalized','Position',[0 0 1 1]) 
title('Average Baseline burst development SEM')
hold on
bar(squeeze(mean(totalbaselineforplot,3)),'BarWidth',0.5,'EdgeColor','none');
xticklabels(split(cellstr([num2str(histogram_einstellung(2:end-1)*1000) ' >' num2str(histogram_einstellung(end-1)*1000)])))
xticks(1:length(histogram_einstellung)-1)
xlabel('burst length [ms]')
ylabel(histogram_einstellung_norm)
ngroups=size(squeeze(mean(totalbaselineforplot,3)),1);
nbars=size(squeeze(mean(totalbaselineforplot,3)),2);
groupwidth=min(0.8, nbars/(nbars+1.5));
BLerrorbarx=squeeze(mean(permute(totalbaselineforplot,[3 1 2]),1));
BLerrorbary=(squeeze(std(permute(totalbaselineforplot,[3 1 2]))))/sqrt(5); % SEM!
for i=1:nbars
    x=(1:ngroups)-groupwidth/2+(2*i-1)*groupwidth/(2*nbars);
    
    errorbar(x,BLerrorbarx(:,i),[],BLerrorbary(:,i),'k','linestyle','none');
end
legend({'TP101','TP104','TP110','TP116', 'TP121', 'D1ant', 'D2ant'}, 'Location','best') 
ylim([0 0.6])
hold off


figure('Units','Normalized','Position',[0 0 1 1]) 
title('Average L-Dopa burst development SEM')
hold on
bar(squeeze(mean(totalLDopaProb,3)),'BarWidth',0.5,'EdgeColor','none');
xticklabels(split(cellstr([num2str(histogram_einstellung(2:end-1)*1000) ' >' num2str(histogram_einstellung(end-1)*1000)])))
xticks(1:length(histogram_einstellung)-1)
xlabel('burst length [ms]')
ylabel(histogram_einstellung_norm)
ngroups=size(squeeze(mean(totalLDopaProb,3)),1);
nbars=size(squeeze(mean(totalLDopaProb,3)),2);
groupwidth=min(0.8, nbars/(nbars+1.5));
LDerrorbarx=squeeze(mean(permute(totalLDopaProb,[3 1 2]),1));
LDerrorbary=(squeeze(std(permute(totalLDopaProb,[3 1 2]))))/sqrt(5);
for i=1:nbars
    x=(1:ngroups)-groupwidth/2+(2*i-1)*groupwidth/(2*nbars);
    
    errorbar(x,LDerrorbarx(:,i),[],LDerrorbary(:,i),'k','linestyle','none');
end
legend({'TP101BL','TP101','TP104','TP110','TP116', 'TP121', 'D1ant', 'D2ant'},'Location','northwest') 
ylim([0 0.6])
hold off

figure('Units','Normalized','Position',[0 0 1 1]) 
subplot(1,2,1)
title('Average Baseline burst length SEM')
hold on
meanBLaveragelength=mean(...
    [BLaveragelength(TP101),...
    BLaveragelength(TP104),...
    BLaveragelength(TP110),...
    BLaveragelength(TP116),...
    BLaveragelength(TP121),...
    BLaveragelength(TP300),...
    BLaveragelength(TP400)],1);
stdBLaveragelength=std(...
    [BLaveragelength(TP101),...
    BLaveragelength(TP104),...
    BLaveragelength(TP110),...
    BLaveragelength(TP116),...
    BLaveragelength(TP121),...
    BLaveragelength(TP300),...
    BLaveragelength(TP400)]);

stdBLaveragelength=stdBLaveragelength/sqrt(5); % SEM

bar(meanBLaveragelength,'BarWidth',0.5,'EdgeColor','none','FaceColor','black');
xticklabels({'TP101','TP104','TP110','TP116', 'TP121', 'D1ant', 'D2ant'})
xticks(1:7)
ylabel('burst length [s]') 
ylim([0 .65])
errorbar(1:7,meanBLaveragelength,[],stdBLaveragelength,'k','linestyle','none');
hold off

subplot(1,2,2)
title('Average L-Dopa burst length')
hold on
meanLDaveragelength=mean(...
    [LDaveragelength(TP101),...
    LDaveragelength(TP104),...
    LDaveragelength(TP110),...
    LDaveragelength(TP116),...
    LDaveragelength(TP121),...
    LDaveragelength(TP300),...
    LDaveragelength(TP400)],1);
stdLDaveragelength=std(...
    [LDaveragelength(TP101),...
    LDaveragelength(TP104),...
    LDaveragelength(TP110),...
    LDaveragelength(TP116),...
    LDaveragelength(TP121),...
    LDaveragelength(TP300),...
    LDaveragelength(TP400)]);

stdLDaveragelength=stdLDaveragelength/sqrt(5); % SEM

bar(meanLDaveragelength,'BarWidth',0.5,'EdgeColor','none','FaceColor','black');
xticklabels({'TP101','TP104','TP110','TP116', 'TP121', 'D1ant', 'D2ant'})
xticks(1:7)
ylabel('burst length [s]') 
ylim([0 .65])
errorbar(1:7,meanLDaveragelength,[],stdLDaveragelength,'k','linestyle','none');
hold off

%%
figure('Name','Burstlength Probability Baseline vs. L-Dopa SEM', 'Units','Normalized','Position',[0 0 1 1])
hold on

kombiniert=[squeeze(mean(totalLDopaProb(:,2:end,:),3)) squeeze(mean(totalbaselineforplot,3))];
kombiniert(:,2:2:end)=squeeze(mean(totalLDopaProb(:,2:end,:),3));
kombiniert(:,1:2:end)=squeeze(mean(totalbaselineforplot,3));
kombinierterbarplot=bar(kombiniert,'BarWidth',0.5,'EdgeColor','none');
xticklabels(split(cellstr([num2str(histogram_einstellung(2:end-1)*1000) ' >' num2str(histogram_einstellung(end-1)*1000)])))
xticks(1:length(histogram_einstellung))
xlabel('burst length [ms]')
ylabel(histogram_einstellung_norm)
farbenkombiniert=parula(7);
farbenkombiniert=[farbenkombiniert;farbenkombiniert];
farbenkombiniert(1:2:end,:)=parula(7);%ones(7,3)*.8;
farbenkombiniert(2:2:end,:)=parula(7);
   for i=1:length(kombinierterbarplot)
        set(kombinierterbarplot(1,i),'FaceColor',farbenkombiniert(i,:))
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
LDerrorbary(:,2:2:end)=(squeeze(std(permute(totalLDopaProb(:,2:end,:),[3 1 2]))))/sqrt(5);
LDerrorbary(:,1:2:end)=(squeeze(std(permute(totalbaselineforplot,[3 1 2]))))/sqrt(5);
for i=1:nbars
    x=(1:ngroups)-groupwidth/2+(2*i-1)*groupwidth/(2*nbars);
    
    errorbar(x,LDerrorbarx(:,i),[],LDerrorbary(:,i),'k','linestyle','none');
end
legend(kombinierterbarplot(1,[1 2:2:end]),{'Individual Baselines','TP101','TP104','TP110','TP116', 'TP121', 'D1ant', 'D2ant'},'Location','northwest') 
hold off
%ylim([0 1])