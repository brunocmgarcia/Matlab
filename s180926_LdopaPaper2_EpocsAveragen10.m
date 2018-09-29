%% dieses script soll alle LDOPA phasen TFRs laden und dann
% die zeiteinteilung bei 180 min aufnahmen vornehmen:
% zeiteinteilung: - 0-10min 10-30(ohne 15-20) 30-50 50-70
%70-90 90-110 110-130 130-150 150-170 170-180
% bei den 10min Ruhe aufnahem wird das übersprungen.

% output: 


clear all
cd('/Users/guettlec/Desktop/LDOPApaperTryout')
dateiname='CG04_TP101_postLD180_ds_NOreref_m1TFRhann.mat';
load(dateiname)

%% zeiteinteilung: - 0-10min 10-30(ohne 15-20) 30-50 50-70
%70-90 90-110 110-130 130-150 150-170 170-180

time=TFRhann.time';
[verwerfen min10]=min(abs(time-600));
[verwerfen min15]=min(abs(time-(15*60)));
[verwerfen min20]=min(abs(time-(20*60)));
[verwerfen min30]=min(abs(time-(30*60)));
[verwerfen min50]=min(abs(time-(50*60)));
[verwerfen min70]=min(abs(time-(70*60)));
[verwerfen min90]=min(abs(time-(90*60)));
[verwerfen min110]=min(abs(time-(110*60)));
[verwerfen min130]=min(abs(time-(130*60)));
[verwerfen min150]=min(abs(time-(150*60)));
[verwerfen min170]=min(abs(time-(170*60)));
[verwerfen min180]=min(abs(time-(180*60)));

farbe=jet(10);
Yscaling=7e+8;

spektral0_10=nanmean(TFRhann.powspctrm(:,:,1:min10),3);
h=figure('units','normalized','outerposition',[0 0 1 1]);
subplot(1,3,1)
plot(my_foi,spektral0_10, 'Color', farbe(1,:))
xlim([0 max(my_foi)])
ylim([0 Yscaling])

spektral10_30(1,:)=nanmean(TFRhann.powspctrm(:,:,min10+1:min15),3);
spektral10_30(2,:)=nanmean(TFRhann.powspctrm(:,:,min20+1:min30),3);
spektral10_30=nanmean(spektral10_30,1);

hold on
plot(my_foi,spektral10_30, 'Color', farbe(2,:))
xlim([0 max(my_foi)])
ylim([0 Yscaling])
hold off

spektral30_50=nanmean(TFRhann.powspctrm(:,:,min30+1:min50),3);
hold on
plot(my_foi,spektral30_50, 'Color', farbe(3,:))
xlim([0 max(my_foi)])
ylim([0 Yscaling])
hold off

spektral50_70=nanmean(TFRhann.powspctrm(:,:,min50+1:min70),3);
hold on
plot(my_foi,spektral50_70, 'Color', farbe(4,:))
xlim([0 max(my_foi)])
ylim([0 Yscaling])
hold off

spektral70_90=nanmean(TFRhann.powspctrm(:,:,min70+1:min90),3);
hold on
plot(my_foi,spektral70_90, 'Color', farbe(5,:))
xlim([0 max(my_foi)])
ylim([0 Yscaling])
hold off

spektral90_110=nanmean(TFRhann.powspctrm(:,:,min90+1:min110),3);
hold on
plot(my_foi,spektral90_110, 'Color', farbe(6,:))
xlim([0 max(my_foi)])
ylim([0 Yscaling])
hold off

spektral110_130=nanmean(TFRhann.powspctrm(:,:,min110+1:min130),3);
hold on
plot(my_foi,spektral110_130, 'Color', farbe(7,:))
xlim([0 max(my_foi)])
ylim([0 Yscaling])
hold off

spektral130_150=nanmean(TFRhann.powspctrm(:,:,min130+1:min150),3);
hold on
plot(my_foi,spektral130_150, 'Color', farbe(8,:))
xlim([0 max(my_foi)])
ylim([0 Yscaling])
hold off

spektral150_170=nanmean(TFRhann.powspctrm(:,:,min150+1:min170),3);
hold on
plot(my_foi,spektral150_170, 'Color', farbe(9,:))
xlim([0 max(my_foi)])
ylim([0 Yscaling])
hold off

spektral170_180=nanmean(TFRhann.powspctrm(:,:,min170+1:min180),3);
hold on
plot(my_foi,spektral170_180, 'Color', farbe(10,:))
xlim([0 max(my_foi)])
ylim([0 Yscaling])
hold off
xlabel('Frequency [Hz]')
ylabel('Power [a.u.]')

colorbar('TickLabels',{'0min','10min','30min','50min','70min','90min','110min','130min','150min','170min','180min'})
% plot(my_foi, spektral)
% 
% c=squeeze(TFRhann.powspctrm(1,:,:));
% x=TFRhann.time';
% y=TFRhann.freq';
% 
% imagesc(squeeze(TFRhann.powspctrm))
% set(gca,'YDir','normal')
% caxis([0 5e+7])
% for i=1:300000
%     xlim([i+0 i+100])
%     xtickvalues=floor(linspace(i, i+100,10));
% 
%     set(gca,'XTick',xtickvalues);
%     set(gca,'XTickLabel', x(xtickvalues)./60);
%     drawnow
% 
% end

subplot(1,3,2:3)


hoehe=Yscaling*0.95;
filename=[dateiname(1:end-4) '.gif']
for i=1:1500:(length(time)-23915)
spektral_i=nanmean(TFRhann.powspctrm(:,:,i:i+23915),3);
cla
plot(my_foi,spektral_i)
xlim([0 140])
ylim([0 Yscaling])
text(120,hoehe,['Minuten: ' num2str(floor((time(i+23915))/60))])
xlabel('Frequency [Hz]')
ylabel('Power [a.u.]')
drawnow
frame=getframe(h);
im=frame2im(frame);
[imind,cm]=rgb2ind(im,256);
if i==1
    imwrite(imind,cm,filename,'gif','Loopcount',inf, 'DelayTime', 0.01);
else
    imwrite(imind,cm,filename,'gif','Writemode','append', 'DelayTime', 0.01);
end   
clearvars spektral_i frame im imind cm
end

cd('prefooofed')
save([dateiname(1:end-4) '_4fooof.mat'], ...
    'spektral0_10','spektral10_30', 'spektral110_130', 'spektral130_150', 'spektral150_170', 'spektral170_180', 'spektral30_50', 'spektral50_70', 'spektral70_90', 'spektral90_110', 'my_foi');
cd ..
