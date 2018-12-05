%%s181129_collectburstdata_individual

clear all
close all 
clc

histogram_einstellung=0.05:0.05:.6;
%histogram_einstellung=0:1:10;

histogram_einstellung_norm='probability';

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
    P75rs=basestruct.P75rs;
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
excludeanimals1=[]; %rausnehmen bei bedarf
excludeanimals2=[]; %
excludeanimals=[excludeanimals1; excludeanimals2];

animals=['CG04';'CG05';'CG06';'CG07';'CG08';'CG09';'CG10'];
%animals=['CG04';'CG06';'CG07';'CG08';'CG10'];


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

baselinefig=figure('Name', 'Baseline')
ldopafig=figure('Name', 'LDopa')


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


meandevelopment=[mean10TP101;mean180TP101; mean180TP104; mean10TP110; mean10TP116; ...
    mean10TP121; mean10TP300; mean10TP400]';
% SEM
%stddevelopment=stddevelopment./sqrt(size(TP101,1));
%

baselinedev=[mean10TP101; mean10TP104; mean10TP110; mean10TP116; ...
    mean10TP121; mean10TP300; mean10TP400]';

% SEM
%basestddevelopment=basestddevelopment./sqrt(size(TP101,1));
%

figure(baselinefig);
subplot(2,4,i)
title(['Baseline burst development animal #' animals(i,:)])
hold on
bar(baselinedev,'EdgeColor','none');
xticks(1:length(histogram_einstellung))
xticklabels(split(cellstr(num2str(histogram_einstellung(1:end)*1)))')
xlabel('burstlength [s]')
ylabel(histogram_einstellung_norm)
legend({'TP101','TP104','TP110','TP116', 'TP121', 'D1ant', 'D2ant'})
hold off

figure(ldopafig);
subplot(2,4,i)
title(['burst development animal #' animals(i,:)])
hold on
bar(meandevelopment,'EdgeColor','none');

xticklabels(split(cellstr(num2str(histogram_einstellung(2:end)*1)))')
xticks(1:length(histogram_einstellung))
xlabel('burstlength [s]')
ylabel(histogram_einstellung_norm)


legend({'TP101BL','TP101','TP104','TP110','TP116', 'TP121', 'D1ant', 'D2ant'})

hold off
end