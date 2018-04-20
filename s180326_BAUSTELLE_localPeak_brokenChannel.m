% %% 1) The maxima had to be between 13-20 Hz and 55-90 Hz for beta and gamma 
% activity respectively. The focus was set on these two frequency ranges 
% because they are known to contain the primarily relevant peaks in the beta 
% (Priori et al., 2004) and gamma range (Halje et al., 2012, Dupre et al.,
% 2016) in the 6 OHDA model in the drug free baseline state and under the
% influence of levodopa and apomorphine . 2) A local peak had to be greater than the
% surrounding six 1 Hz bins. 3) The average power in the range [MF  3 Hz]
% to [MF +4 Hz] for beta and [MF -9 Hz] to [MF +10 Hz] for gamma had to be
% greater than the average power within the range of 13-48 Hz or 52-95 Hz 
% respectively. 4) The first´derivative of the waveform had to be positive
% before and negative after the peak. 5) The second derivative of the 
% waveform had to be negative at the peak, indicatinga downward concave 
% shape. Individual frequency ranges for each channel 
% were then defined on the basis of the average MF (aMF) for all 
% conditions [aMF - 3 Hz to aMF + 4 Hz, 8 bins] for beta and [aMF 
% 9 Hz to aMF + 10 Hz, 20 bins] for the gamma band. If the above
% defined criteria were not met, the MF was considered to be
% undetectable and left undefined. In case this applied for all 
% experimental conditions (e.g. most control animals in the beta
% band) individual ranges for averaged power were set to 13-20 Hz
% for beta and 60-80 Hz  for gamma as default. Average power values
% for statistical analysis for both bands were calculated
% within the individually defined frequency ranges and 
% denoted beta power and gamma power.



clear all
files=dir('*.mat');

files={files.name}';

for currentfile_i=20:40%length(files)

currentfile=char(files(currentfile_i));
    load(currentfile);
cfg=[];
cfg.demean='yes';
data=ft_preprocessing(cfg,data);
channelpower(:,:,currentfile_i)=quantile(data.trial{1,1}/800,[0.025 0.3 0.50 0.70 0.975],2);


end

figure

plot(squeeze(channelpower(:,4,:))')


x=1:length(data.trial{1,1}(2,:));
y=data.trial{1,1}(2,:);
test=diff([eps; y(:)])./diff([eps; x(:)]);
figure
subplot(2,1,1)
plot(x,data.trial{1,1}(2,:));
subplot(2,1,2)
plot(x,test);