%%s190107_correlate_burst_ampAndLength

clear all
clc
close all

load  VAR_centerofmasspeakfreqs 
%masterpeakfreq=results.masterpeakfreq; % edit centerofmass
masterpeakfreq=f; % edit centerofmass
masterpeakfreq=masterpeakfreq(10:end,:);
%masterpeakfreq=nanmedian(masterpeakfreq(:,5:6),2);
masterpeakfreq=nanmean(masterpeakfreq(:,4:7),2); % edit centerofmass
cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/180/burstCenterOfMass/correlation')
load key
ordner=dir('*.mat');
files={ordner.name}';
farben=parula(7);

TPmatrix=[TP101,TP104,TP110,TP116,TP121,TP300,TP400]';
allAUC=[];
alllength=[];
allAUCBL=[];
alllengthBL=[];
allmaxBL=[];
allmaxLD=[];
allcenterfreq=[];
%myscatter=figure();
for TP=1:7
    for i=1:5
        file=files(TPmatrix(TP,i));
        file=file{:};
        load(file)
        allAUC=[allAUC AUC];
        alllength=[alllength lengthBL];
        allAUCBL=[allAUCBL AUCBL];
        alllengthBL=[alllengthBL lengthLD];
        allmaxBL=[allmaxBL maxheightBL];
        allmaxLD=[allmaxLD maxheight];
    end
    x=alllength;
    y=allAUC;
    
    [n,c] = hist3([x', y'], 'Edges',{prctile(x,[2.5:95]);prctile(y,[2.5:95])});
    
   
    
    
  %  figure(myscatter)
  figure
    hold on
    contour(c{1},c{2},n)
    scatter(x(1:20:end)',y(1:20:end)',1,'black','filled')
    %scatter(allmaxLD,allAUC,5,farben(TP,:),'filled')
    %scatter(allAUCBL,alllengthBL,5,'blue','filled')
    hold off
   % linearregression(alllength',allmaxLD','AUC','length',1)
    allAUC=[];
    alllength=[];
    allAUCBL=[];
    alllengthBL=[];
    allmaxBL=[];
    allmaxLD=[];
    NanValues=[];
    clearvars c n 
end

for i=1:7
    figure(i)
    xlim([0 1])
    ylim([0 10])
end