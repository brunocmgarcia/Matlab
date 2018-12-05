%%s181123_collectburstdata

clear all
%close all 
clc

histogram_einstellung=0.01:0.05:.6;
histogram_einstellung_norm='count';

load VAR_baselineschluessel
baselineschluessel=baselineschluessel(10:end,:);

cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/180/burst')
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
    basestruct=load(['/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/Ruhe10/burst/' datei10]);
    %P75rs=basestruct.P75rs;
    figure
    subplot(1,2,1)
    myhist180=histogram(rs_NumBlockLength, histogram_einstellung,  'Normalization', histogram_einstellung_norm);
    subplot(1,2,2)
    myhist10=histogram(basestruct.rs_NumBlockLength, histogram_einstellung,  'Normalization', histogram_einstellung_norm);
    totalbinprob180(file_i,:)=myhist180.Values;
    totalbinprob10(file_i,:)=myhist10.Values;
    totalp75_180(file_i,:)=P75rs;
    totalp75_10(file_i,:)=basestruct.P75rs;
    
close all
clearvars -except totalp75_10 totalp75_180 totalbinprob180 histogram_einstellung_norm histogram_einstellung totalbinprob10 files file_i baselineschluessel
end

excludeanimals1=find(contains(baselineschluessel(:,1),'CG05'));
excludeanimals2=find(contains(baselineschluessel(:,1),'CG09'));
excludeanimals=[excludeanimals1; excludeanimals2];

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


length(TP101);

mean10TP101=mean(totalbinprob10(TP101,:),1);
mean180TP101=mean(totalbinprob180(TP101,:),1);
std10TP101=std(totalbinprob10(TP101,:),1);
std180TP101=std(totalbinprob180(TP101,:),1);

mean10TP104=mean(totalbinprob10(TP104,:),1);
mean180TP104=mean(totalbinprob180(TP104,:),1);
std10TP104=std(totalbinprob10(TP104,:),1);
std180TP104=std(totalbinprob180(TP104,:),1);

mean10TP110=mean(totalbinprob10(TP110,:),1);
mean180TP110=mean(totalbinprob180(TP110,:),1);
std10TP110=std(totalbinprob10(TP110,:),1);
std180TP110=std(totalbinprob180(TP110,:),1);

mean10TP116=mean(totalbinprob10(TP116,:),1);
mean180TP116=mean(totalbinprob180(TP116,:),1);
std10TP116=std(totalbinprob10(TP116,:),1);
std180TP116=std(totalbinprob180(TP116,:),1);

mean10TP121=mean(totalbinprob10(TP121,:),1);
mean180TP121=mean(totalbinprob180(TP121,:),1);
std10TP121=std(totalbinprob10(TP121,:),1);
std180TP121=std(totalbinprob180(TP121,:),1);

mean10TP300=mean(totalbinprob10(TP300,:),1);
mean180TP300=mean(totalbinprob180(TP300,:),1);
std10TP300=std(totalbinprob10(TP300,:),1);
std180TP300=std(totalbinprob180(TP300,:),1);

mean10TP400=mean(totalbinprob10(TP400,:),1);
mean180TP400=mean(totalbinprob180(TP400,:),1);
std10TP400=std(totalbinprob10(TP400,:),1);
std180TP400=std(totalbinprob180(TP400,:),1);

p75_10TP101=mean(totalp75_10(TP101,:),1);
p75_10TP104=mean(totalp75_10(TP104,:),1);
p75_10TP110=mean(totalp75_10(TP110,:),1);
p75_10TP116=mean(totalp75_10(TP116,:),1);
p75_10TP121=mean(totalp75_10(TP121,:),1);
p75_10TP300=mean(totalp75_10(TP300,:),1);
p75_10TP400=mean(totalp75_10(TP400,:),1);
figure('Name', '75th Percentile of Baseline recording')
plot([1,2,3,4,5,6,7], [p75_10TP101, p75_10TP104, p75_10TP110, p75_10TP116,...
    p75_10TP121, p75_10TP300, p75_10TP400])
ylim([0 10000])
xticklabels({'TP101','TP104','TP110','TP116', 'TP121', 'D1ant', 'D2ant'})



meandevelopment=[mean10TP101;mean180TP101; mean180TP104; mean10TP110; mean10TP116; ...
    mean10TP121; mean10TP300; mean10TP400]';
stddevelopment=[std10TP101;std180TP101; std180TP104; std10TP110; std10TP116; ...
    std10TP121; std10TP300; std10TP400]';

baselinedev=[mean10TP101; mean10TP104; mean10TP110; mean10TP116; ...
    mean10TP121; mean10TP300; mean10TP400]';
basestddevelopment=[std10TP101; std10TP104; std10TP110; std10TP116; ...
    std10TP121; std10TP300; std10TP400]';

figure('Name' ,'Baseline burst development')
fig_baseBL=bar(baselinedev);
hold on
xticklabels(split(cellstr(num2str(histogram_einstellung(2:end)*1000)))')
xlabel('burstlength [ms]')
ylabel(histogram_einstellung_norm)
ngroups=size(baselinedev,1);
nbars=size(baselinedev,2);
groupwidth=min(0.8, nbars/(nbars+1.5));
for i=1:nbars
    x=(1:ngroups)-groupwidth/2+(2*i-1)*groupwidth/(2*nbars);
    errorbar(x,baselinedev(:,i),[],basestddevelopment(:,i),'k','linestyle','none');
end

legend({'TP101','TP104','TP110','TP116', 'TP121', 'D1ant', 'D2ant'})
hold off

figure('Name' ,'L-Dopa burst development')
fig_meanBL=bar(meandevelopment);
hold on
xticklabels(split(cellstr(num2str(histogram_einstellung(2:end)*1000)))')
xlabel('burstlength [ms]')
ylabel(histogram_einstellung_norm)
ngroups=size(meandevelopment,1);
nbars=size(meandevelopment,2);
groupwidth=min(0.8, nbars/(nbars+1.5));
for i=1:nbars
    x=(1:ngroups)-groupwidth/2+(2*i-1)*groupwidth/(2*nbars);
    errorbar(x,meandevelopment(:,i),[],stddevelopment(:,i),'k','linestyle','none');
end

legend({'TP101BL','TP101','TP104','TP110','TP116', 'TP121', 'D1ant', 'D2ant'})

hold off