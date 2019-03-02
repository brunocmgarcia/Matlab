%% s190130_take_fooofed_beta_back

clear all
clc
close all
cd('/Users/guettlec/Dropbox/data/00_variables/beta_pwelch_190130')
LD=load('180fooof.mat');
LDnames=fieldnames(LD);
BL=load('10fooof.mat');
BLnames=fieldnames(BL);

counter=0;
for i=1:3:length(BLnames)
    counter=counter+1;
    BLsf(counter,:)=BL.(cell2mat(BLnames(i)));
    BLf(counter,:)=BL.(cell2mat(BLnames(i+1)));
    BLps(counter,:)=BL.(cell2mat(BLnames(i+2)));
    LDsf(counter,:)=LD.(cell2mat(LDnames(i)));
    LDf(counter,:)=LD.(cell2mat(LDnames(i+1)));
    LDps(counter,:)=LD.(cell2mat(LDnames(i+2)));
    
end

% BLsf=10.^BLsf;
% LDsf=10.^LDsf;
% BLps=10.^BLps;
% LDps=10.^LDps;



clearvars -except LDf LDps LDsf BLf BLps BLsf

[~,von]=(min(abs(LDf(1,:)-25)));
[~,bis]=(min(abs(LDf(1,:)-40)));


for i=1:35
    BLauc(i)=trapz(BLsf(i,[von:bis]));
    LDauc(i)=trapz(LDsf(i,[von:bis]));
end

BLauc=reshape(BLauc,[7,5]);
LDauc=reshape(LDauc,[7,5]);
test=[4 4 4 4 4 4 4 6 6 6 6 6 6 6 7 7 7 7 7 7 7 8 8 8 8 8 8 8 10 10 10 10 10 10 10];
test=reshape(test,[7,5]);

%%
figure('Units','Normalized','Position',[0 0 1 1])
axis tight

subplot(2,3,1)
hold on 
plot(BLf',BLps','b')
plot(LDf',LDps','r')
hold off
xlabel('freq')
ylabel('log power')

subplot(2,3,2)
hold on 
plot(BLf',BLsf','b')
plot(LDf',LDsf','r')
hold off
xlabel('freq')
ylabel('spectrum fooofed')

subplot(2,3,4)
bar([1:7],(BLauc))
ylim([0 18])

subplot(2,3,5)
bar([1:7],(LDauc))
ylim([0 18])


 
% subplot(2,3,3)
% bar([1:7],mean(BLauc,2))
% ylim([-1 18])
% 
% bar([1:7],mean(LDauc,2))
% ylim([-1 18])


subplot(2,3,6)

hold on
groupedmean=[mean(BLauc,2) mean(LDauc,2)];
LDerrorbary=[(std(BLauc,[],2)/sqrt(5)) (std(LDauc,[],2)/sqrt(5))];
kombinierterbarplot=bar([1:7],groupedmean);

for i=1:2:length(kombinierterbarplot)
    set(kombinierterbarplot(1,i),'FaceColor','k')
    set(kombinierterbarplot(1,i),'EdgeColor','k', 'LineWidth', 1); 
end
for i=2:2:length(kombinierterbarplot)
    set(kombinierterbarplot(1,i),'FaceColor',[.5 .5 .5])
    set(kombinierterbarplot(1,i),'EdgeColor',[.5 .5 .5], 'LineWidth', 1) %farbenkombiniert(i,:)
end


ngroups=7;
nbars=2;
groupwidth=min(0.8, nbars/(nbars+1.5));
for i=1:nbars
    x=(1:ngroups)-groupwidth/2+(2*i-1)*groupwidth/(2*nbars);
    errorbar(x,groupedmean(:,i),[],LDerrorbary(:,i),'k','linestyle','none');
end

hold off
%%
absolutreduction=LDauc-BLauc;

figure
bar([1:7],(absolutreduction)); 
meangamma=[4.28647900000000,3.55123100000000,5.68316900000000,0.797111300000000,1.24553600000000;20.9158600000000,10.5790800000000,11.5479200000000,2.39783700000000,4.23380000000000;14.7552700000000,15.4329600000000,11.0483400000000,2.01057400000000,8.38968400000000;15.6430100000000,4.44360700000000,10.2270600000000,1.68556300000000,7.34883500000000;13.7060300000000,7.36292300000000,7.66896400000000,1.21294700000000,7.41612800000000;3.65491600000000,1.18076100000000,4.50599300000000,-0.244006100000000,0.752557100000000;2.78931100000000,-1.08568000000000,2.23067100000000,-0.348867700000000,0.596301900000000] % from finalprism.


[r2_1 r2_2 pR pP sR sP]=linearregression(((-1)*absolutreduction(:)),meangamma(:),'red','gamma',1)
hold on
scatter(((-1)*absolutreduction(:)),meangamma(:),40,'o','filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[.7 .7 .7])

hold off
ylim([-2 21])

figure
linearregression(meangamma(:),((-1)*absolutreduction(:)),'gamma','red',1)
hold on
scatter(meangamma(:),((-1)*absolutreduction(:)),40,'o','filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[.7 .7 .7])

hold off
ylim([-2 21])


% close all
%for i=1:5

x=BLauc(:,:);
y=meangamma(:,:);
linearregression(x(:),y(:),'BLauc','gamma',1)
hold on
scatter(x(:),y(:),40,'o','filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[.7 .7 .7])

hold off
ylim([-2 22])
%end
% 
% counter=0;
% 
% betareduction=reshape(betareduction,[7,5]);
% for i=1:7
%     meanbetareduction(i)=mean(betareduction(i,:),2);
%     meanBLauc(i)=mean(BLauc(i,:),2);
%     meanLDauc(i)=mean(LDauc(i,:),2);
%     
% end
% 
% figure;bar(meanBLauc);ylim([0 7])
% figure;bar(meanLDauc);ylim([0 7])
% figure;bar(meanLDauc./meanBLauc);ylim([0 1])


