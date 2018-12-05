%% s181127_LDopaPaper_prettyTF


clear all
close all
set(0, 'DefaultTextInterpreter', 'none')
load VAR_baselineschluessel
baselineschluessel=baselineschluessel(17:end,:);



for file_i=1:length(baselineschluessel)

cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/')
cd('Ruhe10')    
    
BLdatei=baselineschluessel(file_i,2);
BLdatei=BLdatei{:}(1:end-18)
load(BLdatei)

 cfg              = [];
cfg.output       = 'pow';
cfg.channel      = 'all';
cfg.pad='nextpow2';
cfg.method       = 'tfr';

cfg.toi=[data.time{1,1}(1):data.time{1,1}(end)];
my_foi=1:1:130;
cfg.foi          = my_foi;
cfg.width    = my_foi;  % fest auf 10s 

TFRhann = ft_freqanalysis(cfg, data); 
BLTFR=squeeze(TFRhann.powspctrm);
figure
imagesc(BLTFR)
set(gca, 'ydir', 'normal')
caxis([0 1e13])

BL=(mean(squeeze(TFRhann.powspctrm),2));

figure
plot(BL)

clearvars TFRhann data

cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/')
cd('180')    
    

datei=baselineschluessel(file_i,1);
datei=datei{:}(1:end-18)
load(datei)

cfg              = [];
cfg.output       = 'pow';
cfg.channel      = 'all';
cfg.pad='nextpow2';
cfg.method       = 'tfr';

cfg.toi=[data.time{1,1}(1):data.time{1,1}(end)];
my_foi=1:1:130;
cfg.foi          = my_foi;
cfg.width    = my_foi;  % fest auf 10s 

TFRhann = ft_freqanalysis(cfg, data); 
fig1=figure('Units','Normalized','Position',[0 0 1 1]);
imagesc(squeeze(TFRhann.powspctrm)./BL)
set(gca, 'ydir', 'normal')
caxis([0 100])
figure
imagesc(squeeze(TFRhann.powspctrm))
set(gca, 'ydir', 'normal')
caxis([0 1e13])
save(['prettyTF/' datei(1:end-18)],'BL','BLTFR', 'TFRhann');
savefig(fig1,['prettyTF/' datei(1:end-18)]);
saveas(fig1,['prettyTF/' datei(1:end-18)],'tif');

close all
clearvars -except file_i baselineschluessel
end
%  cfg              = [];
%  cfg.baseline=[0 300];
%  cfg.baselinetype='relative';
%  ft_singleplotTFR(cfg,TFRhann)
% 
%  cd('180')
% 
% ordner=dir('*.mat');
% files={ordner.name}';
% %files=files([7 10 13])
% files=files([10 13 16]);