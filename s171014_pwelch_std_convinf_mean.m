%% ohne reref
clear all
close all
Fs=1000;
load('CG04_p3120_data.mat');
data=data.trial{1,1}';
pxx=pwelch(data(:,1:29), hanning(1000), 0, 1000);
striatum=pxx(:,1:14);
snr=pxx(:,15:27);
M1=pxx(:,28);
cere=pxx(:,29);
figure
hold;
plot(striatum,'g')
plot(snr,'r')
plot(M1,'b')
plot(cere,'y')
xlim([4 60])
ylim([0 5e9])
hold;
normfaktor=mean(striatum(8:95,:))
striatum=striatum./normfaktor;
normfaktor=mean(snr(8:95,:))
snr=snr./normfaktor;
normfaktor=mean(M1(8:95,:))
M1=M1./normfaktor;
normfaktor=mean(cere(8:95,:))
cere=cere./normfaktor;
figure
hold;
plot(striatum,'g')
plot(snr,'r')
plot(M1,'b')
plot(cere,'y')
xlim([4 60])
ylim([0 12])
hold;
mittel_striatum = mean(striatum,2);
standartdev_striatum=std(striatum, [], 2);
SEM_striatum = standartdev_striatum/sqrt(size(striatum,2));               % Standard Error
TScore_striatum = tinv([0.025  0.975],size(striatum,2)-1);      % T-Score
CinfInter_striatum = mittel_striatum + TScore_striatum.*SEM_striatum;                      % Confidence Intervals
mittel_snr = mean(snr,2);
standartdev_snr=std(snr, [], 2);
SEM_snr = standartdev_striatum/sqrt(size(snr,2));               % Standard Error
TScore_snr = tinv([0.025  0.975],size(snr,2)-1);      % T-Score
CinfInter_snr = mittel_snr + TScore_snr.*SEM_snr;                      % Confidence Intervals
figure
hold
%plot(mittel_striatum,'g')
plot(CinfInter_striatum,'g')
%plot(mittel_snr,'r')
plot(CinfInter_snr,'r')
plot(M1,'b')
plot(cere,'y')
xlim([4 60])
ylim([0 12])
hold
%% mit reref
clear all
Fs=1000;
load('CG04_p31_data.mat');
cfg.reref='yes'
cfg.refchannel='Con LFP Ch14 0';
data=ft_preprocessing(cfg, data);
data=data.trial{1,1}';
pxx=pwelch(data(:,1:31), hanning(1000), 0, 1000);
striatum=pxx(:,[2 4 6 8 10 12 16 18 20 22 24 26 28 30]);
snr=pxx(:,[1 3 5 9 11 13 15 17 21 23 25 29]);
M1=pxx(:,19);
cere=pxx(:,14);
figure
hold;
plot(striatum,'g')
plot(snr,'r')
plot(M1,'b')
plot(cere,'y')
xlim([4 60])
ylim([0 5e10])
hold;
normfaktor=mean(striatum(8:95,:))
striatum=striatum./normfaktor;
normfaktor=mean(snr(8:95,:))
snr=snr./normfaktor;
normfaktor=mean(M1(8:95,:))
M1=M1./normfaktor;
normfaktor=mean(cere(8:95,:));
cere=cere./normfaktor;
figure
hold;
plot(striatum,'g')
plot(snr,'r')
plot(M1,'b')
plot(cere,'y')
xlim([4 60])
ylim([0 12])
hold;
mittel_striatum = mean(striatum,2);
standartdev_striatum=std(striatum, [], 2);
SEM_striatum = standartdev_striatum/sqrt(size(striatum,2));               % Standard Error
TScore_striatum = tinv([0.025  0.975],size(striatum,2)-1);      % T-Score
CinfInter_striatum = mittel_striatum + TScore_striatum.*SEM_striatum;                      % Confidence Intervals
mittel_snr = mean(snr,2);
standartdev_snr=std(snr, [], 2);
SEM_snr = standartdev_striatum/sqrt(size(snr,2));               % Standard Error
TScore_snr = tinv([0.025  0.975],size(snr,2)-1);      % T-Score
CinfInter_snr = mittel_snr + TScore_snr.*SEM_snr;                      % Confidence Intervals
figure
hold
plot(mittel_striatum,'g')
plot(CinfInter_striatum,'g')
plot(mittel_snr,'r')
plot(CinfInter_snr,'r')
plot(M1,'b')
plot(cere,'y')
xlim([4 60])
ylim([0 12])