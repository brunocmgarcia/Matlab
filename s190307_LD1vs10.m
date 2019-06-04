%% s190307_LD1vs10 compare power vs aim at day 1 vs 10
clear all 
clc
close all
load VAR_AIMvspower_d1vs_d10
AIM2=zscore(AIM,0,2);
power2=zscore(power,0,2);

AIM3=AIM./(AIM(:,4,2)); AIM3(isinf(AIM3))=0; AIM3(isnan(AIM3))=0;
power3=power./(power(:,4,2));

figure
subplot(1,2,1)
bar((squeeze(nanmean(AIM,1))))
subplot(1,2,2)
bar((squeeze(nanmean(power,1))))

figure
subplot(1,2,1)
bar((squeeze(nanmean(AIM2,1))))
subplot(1,2,2)
bar((squeeze(nanmean(power2,1))))

figure
subplot(1,2,1)
bar((squeeze(nanmean(AIM3,1))))
subplot(1,2,2)
bar((squeeze(nanmean(power3,1))))

figure
subplot(2,2,1)
plotSingleBarSEM(squeeze(power3(:,:,1)))
subplot(2,2,2)
plotSingleBarSEM(squeeze(power3(:,:,2)))
subplot(2,2,3)
plotSingleBarSEM(squeeze(AIM3(:,:,1)))
subplot(2,2,4)
plotSingleBarSEM(squeeze(AIM3(:,:,2)))

final_pow=squeeze(power3(:,4,1));
final_aim=squeeze(AIM3(:,4,1));
final=[final_pow final_aim];
figure
plotSingleBarSEM(final)
