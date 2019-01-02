%% s181211_LDopaPaper_prettyTF_V2


clear all
close all
set(0, 'DefaultTextInterpreter', 'none')
load VAR_baselineschluessel
baselineschluessel=baselineschluessel(10:end,:);
count=0;

% imagesc(log(squeeze(TFRhann.powspctrm)))
% set(gca,'yDir','normal')
% caxis([8 22])
figure('Name','divided','Units','Normalized','Position',[0 0 1 .3]);
for file_i=2%1:size(baselineschluessel,1)
count=count+1;
cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/Ruhe10/TFRsWithNaN/fooofed_prettyTF')

    
BLdatei=baselineschluessel(file_i,2);
BLdatei=[BLdatei{:}(1:end-18) '_TFRhannArtCorr_4fooof.mat']
load(BLdatei, 'bgfit', 'freqs')


cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/180/TFRsWithNaN')
   
    

datei=baselineschluessel(file_i,1);
datei=[datei{:}(1:end-18) 'TFRhann.mat']
load(datei)

powerspectrum=log(squeeze(TFRhann.powspctrm)); %log
bgfit=bgfit';
clearvars TFRhann

subplot(1,1,count)
imagesc(10.^(powerspectrum./bgfit)) %10.^
set(gca, 'ydir', 'normal')

forprctil=powerspectrum./bgfit;
forprctil=forprctil(:);
forprctil=10.^forprctil; %10^

%caxis([prctile(forprctil,15) prctile(forprctil,90)])
caxis([140 800])


% caxis([140 400])
% %xlim([2100 2100+800]) % beta
% xlim([5.8e4 5.8e4+800]) % gamma

end

%print('large','-deps','-r300')
