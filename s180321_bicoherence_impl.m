%% s180321_bicoherence_impl / hosa toolbox. 
% https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4829647/pdf/zns4218.pdf
% 




clear all
load('CG04_TP00_LB20.mat')




cfg=[];
cfg.lpfilter='no';
cfg.lpfreq=500;
% cfg.reref='yes';
% cfg.refchannel=31;
data=ft_preprocessing(cfg,data);
average=zeros(900,900);




cfg=[];
cfg.length=0.9;
data=ft_redefinetrial(cfg,data);




%% hier ersetze ich channel 2 mit simulierten 1/f [1:0.5:250] daten
% bei denen in jedem trial die amplitude jeder frequenz um 20% variiert.

% for i=1:length(data.trial)
% freqs=[1:0.5:250];
% amps=(140./(([1:0.5:250]).^1));
% amps=0.9*amps+(0.2*rand(1)*amps);
% phases=((2*rand(length(freqs),1)-1)*pi)';
% phases(1,[130 190 75])=pi;
% simulated_data(ceil(length(data.time{1,i})/data.fsample),data.fsample,freqs,amps, phases,0.5);
% 
% data.trial{1,i}(2,:)=(ans(1,1:length(data.trial{1,i}(1,:)))').*400;
% end

%% weiter im text

for i=1:length(data.trial)

dat=data.trial{1,i}(30,:)';
[a,b]=bicoher(dat, 900, hanning(900), 900, 50);
% a=fftshift(a);
% b = (-450:449)*(data.fsample/length(dat));
%[bic,waxis] = bicoher (dat,  nfft, wind, nsamp, overlap)

% b=b(b>0);
% a=a(b>0,b>0);
% a=(a(1:50,1:50));
% a=(triu(a,0));
gfsd=figure
imagesc(a([451:510],[451:510])) % entspricht etwa bis 100hz
set(gca,'YDir','normal')
uiwait(gfsd);
 a=a/length(data.trial);
average=average+a;
clearvars -except data average i b
end
figure


h=imagesc(average([1:46],[1:46])) % entspricht etwa bis 100hz
set(gca,'YDir','normal')

figure
z=imagesc(average([451:510],[451:510])) % entspricht etwa bis 100hz
set(gca,'YDir','normal')
%set(h, 'XData', b);

% surf(b(1:50),b(1:50),average)
% set(gca, 'XTick', 0:5:b(50))
% set(gca, 'YTick', 0:5:b(50))
% view(0,90);
% xlim([0 b(50)])
% ylim([0 b(50)])
% zlim([0 1])
% 
% 
% caxis([0 1])