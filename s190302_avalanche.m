%% s190302_avalanche

% load('/Users/guettlec/Desktop/burststruct.mat')
% load VAR_baselineschluessel
% baselineschluessel=baselineschluessel(10:end,:);


clearvars -except burststruct
close all
allLD=[1 2 4 5 7 8 9; 23 24 26 28 30 32 33; 35 36 38 40 42 44 45; 47 48 50 51 52 54 55; 66 67 69 70 71 73 74]';
starttimes=[];
height=[];
length=[];
AUC=[];
heightBL=[];
lengthBL=[];
AUCBL=[];
for i=1:size(allLD,1)
    for ii=1:size(allLD,2)
        starttimes{i,ii}=(burststruct(allLD(i,ii)).LD.start)./(500*60); %now minutes
        height{i,ii}=burststruct(allLD(i,ii)).LD.maxheight;
        length{i,ii}=burststruct(allLD(i,ii)).LD.length;
        AUC{i,ii}=burststruct(allLD(i,ii)).LD.AUC;
        starttimesBL{i,ii}=(burststruct(allLD(i,ii)).BL.start)./(500*60); %now minutes
        heightBL{i,ii}=burststruct(allLD(i,ii)).BL.maxheight;
        lengthBL{i,ii}=burststruct(allLD(i,ii)).BL.length;
        AUCBL{i,ii}=burststruct(allLD(i,ii)).BL.AUC;
    end
end

[~,~,timebins]=cellfun(@histcounts, starttimes,repmat({[0 10 15 20 30 50 70 90 110 130 150 170 180]},7,5), 'Uni',0);
timebins=cellfun(@(x) x.*(x~=3), timebins, 'Uni',0);
timebins=cellfun(@(x) x-((x>3)*2), timebins, 'Uni',0); % zauberei. alles um die zeit zwischen 15:20 (laufband) zu entfernen.
%%
clearvars lifetime
for i=1:7
    for ii=1:5
        for iii=1:10
            
            [lifetime{i,ii,iii},~,hist_length_binind{i,ii,iii}]=histcounts(length{i,ii}(timebins{i,ii}==iii),logspace(-1,0,11));
            lifetime{i,ii,iii}=lifetime{i,ii,iii}./sum(lifetime{i,ii,iii});      
            
        
        end
    end
end

lifetime = cell2mat(cellfun(@(x)reshape(x,1,1,1,[]),lifetime,'un',0));

times=[strsplit(num2str((logspace(-1,0,11))))];
times2={'0-10min','10-30min','30-50min','50-70min','70-90min','90-110min','110-130min','130-150min','150-170min','170-180min'};
%%
h=figure('Units','Normalized','Position',[0 0 1 .3]); 

farben=hot(10);

for i=1:10
subplot(1,5,1)

plot(log10(squeeze(nanmean(lifetime(1,:,i,:),2))),'Color','k')
xticks([1:2:29])
xticklabels(times(2:2:30))
ylim([-4 0])
xlim([1 15])
legend(times2{i},'Location','northeast')
axis square
title('l-dopa 1')
xlabel('life-time [ms]')
ylabel('log10(P(life-time))')

subplot(1,5,2)
plot(log10(squeeze(nanmean(lifetime(2,:,i,:),2))),'Color','k')
xticks([1:2:29])
xticklabels(times(2:2:30))
ylim([-4 0])
xlim([1 15])
legend(times2{i},'Location','northeast')
axis square
title('l-dopa 4')
xlabel('life-time [ms]')
ylabel('log10(P(life-time))')

subplot(1,5,3)
plot(log10(squeeze(nanmean(lifetime(3,:,i,:),2))),'Color','k')
xticks([1:2:29])
xticklabels(times(2:2:30))
ylim([-4 0])
xlim([1 15])
legend(times2{i},'Location','northeast')
axis square
title('l-dopa 10')
xlabel('life-time [ms]')
ylabel('log10(P(life-time))')

subplot(1,5,4)
plot(log10(squeeze(nanmean(lifetime(4,:,i,:),2))),'Color','k')
xticks([1:2:29])
xticklabels(times(2:2:30))
ylim([-4 0])
xlim([1 15])
legend(times2{i},'Location','northeast')
axis square
title('l-dopa 16')
xlabel('life-time [ms]')
ylabel('log10(P(life-time))')

subplot(1,5,5)
plot(log10(squeeze(nanmean(lifetime(5,:,i,:),2))),'Color','k')
xticks([1:2:29])
xticklabels(times(2:2:30))
ylim([-4 0])
xlim([1 15])
legend(times2{i},'Location','northeast')
axis square
title('l-dopa 21')
xlabel('life-time [ms]')
ylabel('log10(P(life-time))')

drawnow
% frame=getframe(h);
% im=frame2im(frame);
% [imind,cm]=rgb2ind(im,256);
% if i==1
%     imwrite(imind,cm,'avalanche.gif','gif','Loopcount',inf);
% else
%     imwrite(imind,cm,'avalanche.gif','gif','Writemode','append');
% end

end

%%
% white=@(x) x./x;
% pink=@(x) 1./x;
% powerlaw1=@(x) 1./x.^0.1;
% powerlaw2=@(x) 1./x.^0.3;
% powerlaw3=@(x) 1./x.^0.5;
% powerlaw4=@(x) 1./x.^0.7;
% powerlaw5=@(x) 1./x.^0.9;
% powerlaw6=@(x) 1./x.^2;
% x=[1:100];
% figure; hold on;
% plot(white(x))
% plot(pink(x))
% plot(powerlaw1(x))
% plot(powerlaw2(x))
% plot(powerlaw3(x))
% plot(powerlaw4(x))
% plot(powerlaw5(x))
% plot(powerlaw6(x))
% hold off
% set(gca,'XScale','lin','YScale','lin')
% 
% figure; hold on;
% plot(white(x))
% plot(pink(x))
% plot(powerlaw1(x))
% plot(powerlaw2(x))
% plot(powerlaw3(x))
% plot(powerlaw4(x))
% plot(powerlaw5(x))
% plot(powerlaw6(x))
% hold off
% set(gca,'XScale','lin','YScale','log')
% 
% figure; hold on;
% plot(white(x))
% plot(pink(x))
% plot(powerlaw1(x))
% plot(powerlaw2(x))
% plot(powerlaw3(x))
% plot(powerlaw4(x))
% plot(powerlaw5(x))
% plot(powerlaw6(x))
% hold off
% set(gca,'XScale','log','YScale','log')
%%

a=(squeeze(nanmean(lifetime(1,:,1,:),2)));
b=(logspace(-1,0,11)'*1000);
b=10.^((log10(b(1:end-1))+log10(b(2:end)))./2);  %logar. bin mitte
%b=((b(1:end-1))+(b(2:end)))./2; %lineare bin mitte
figure; loglog(b,a); hold on; scatter(b,a); hold off
xticks([167 333 528 837])
xlim([100 1000])
hold on

x=b; y=a;

b=log10(b);
a=log10(a);


b(isinf(a))=[];
a(isinf(a))=[];
beta=(b\a);
offset=([ones(numel(b'),1) b]\a);
plot(10.^(b),10.^((offset(2)*b+offset(1))))
legend(sprintf('Formula: y=10^(%fx)+%f)',offset(2),offset(1)))
hold off
%% fitting exponential decay with tau as time constant y=a*e^(-x/tau)
decay_f=@(x,b) b(1).*exp((x*(-1))./b(2));
% plot(x,decay_f([1 200],x))
B=fminsearch(@(b) norm(y-decay_f(x,b)), [1, 200]);
figure; plot(x,y,'b'); hold on
plot(x,decay_f(x,B), 'r'); hold off
legend({sprintf('intial Value: %f /// tau: %fms',B(1),B(2)),sprintf('Formula: y=%f*e^(-x/%f)',B(1),B(2))})

%%
figure; hold on
plot(10.^(logspace(-1,0.5,15)'*1000),(squeeze(nanmean(lifetime(1,:,1,:),2))))
fplot(slope)
% linearregression(b,a,'log(lifetime)','log(P)',0)
