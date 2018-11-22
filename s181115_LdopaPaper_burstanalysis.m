%% s181115_LdopaPaper_burstanalysis


% B = smoothdata(A,dim,method,window)
% 
% 
% Continuous recordings were divided into epochs of 5 s 
% (−2 to +3 s around movement onset of each trial). Fifth 
% order butterworth, high-pass (>1 Hz) and notch filters 
% (48–52 Hz) were applied to limit effects of line noise. 
% Epochs were rejected from further analysis if they contained 
% artifacts and saturation in the local field potentials trace 
% or abnormalities in the movement trace, leaving a mean (±SEM) 
% of 27.6 ± 10.8 remaining trials in the ON-medication state and
% 27.0 ± 9.0 (mean ±SEM) in the OFF-medication state per hand 
% and per condition for final analysi
% % 
%  a time-frequency decomposition based on Morlet wavelets with 
%  seven cycles was applied to the local field potential recordings 
%  of all contact pairs from each trial. Local field potentials were 
%  analyzed over frequencies between 1 and 100 Hz with a frequency 
%  resolution of 1 Hz. Event-related local field potential power 
%  change was subsequently normalized in percentage relative to an 
%  averaged pre-trial baseline period (−2 to 0.5 s preceding the 
%  visual cue), smoothed over 6 Hz and 200 ms and averaged using 
%  robust averaging across trials and contact of pairs of the same patient.
% 
%  the gamma band was restricted to the frequency range that showed
%  modulation between conditions (gamma-band 40–90 Hz),
%  
% The raw local field potential recording was band pass 
% filtered (Fifth order butteworth filter) around the gamma 
% band (40–90 Hz), rectified and smoothed with moving average 
% gaussian smoothing kernel of 100 ms length. A gamma burst 
% was determined when the resulting instantaneous power exceeded 
% the 75th percentile of the signal amplitude distribution of all
% data in each electrode. Threshold crossings lasting shorter than 
% one gamma cycle were excluded from the analysis (see Figure 7A). 
% For ON-OFF comparisons (n = 7), the threshold of the ON medication 
% state was applied to the OFF recordings of the matching hemisphere. 
% The amplitude of a gamma burst was defined as the area under the 
% curve between signal and threshold line. The density of gamma bursts,
% in the following ‘burst rate’, was defined as the number of bursts
% occurring in 0.5 s. The change of burst rate therefore serves as
% an estimate of the probability of bursting during movement (0.5 s
% following movement onset) compared to that in 0.5 s of baseline 
% activity (2–1.5 s before movement onset). We also compared averaged 
% burst duration and amplitude during movement with that during 
% baseline activity. 

%%example recitfy vs  hilbert

clear all
close all
load VAR_Beispiel_LFP_trace
fs=500;


% clear all
% close all
% load('/Users/guettlec/Desktop/Desktop/LFP_data_1000Hz_LP500_demean_reref.mat')
% dat=data.trial{1,1}(30,:);
% dat=dat-mean(dat);
% fs=300;



[B, A] = butter(6, [80/(fs/2) 120/(fs/2)], 'bandpass'); 
% [z,p,k] = butter(6,[80/(fs/2) 85/(fs/2)],'bandpass');
% sos = zp2sos(z,p,k);
% hfvt = fvtool(B,A,sos,'FrequencyScale','log');
% legend(hfvt,'TF Design','ZPK Design')


dat = filtfilt(B,A, dat')';


dathilb=abs(hilbert(dat));
dathilbsmooth = smoothdata(dathilb,2,'gaussian',(0.1*fs));
datrect=abs(dat);
datrectsmooth=smoothdata(datrect,2,'gaussian',(0.1*fs));
    
    
P75h=prctile(dathilb,75);
P75h_curve=((ones(length(dat),1)*P75h)');
P75h_curve(P75h_curve>=dathilb)=NaN;
h_ueberthreshold           = diff( ~isnan([ NaN P75h_curve NaN ]) );
h_NumBlockStart   = find( h_ueberthreshold>0 )-0;
h_NumBlockEnd     = find( h_ueberthreshold<0 )-1;
h_NumBlockLength  = (h_NumBlockEnd - h_NumBlockStart + 1)/fs;



P75hs=prctile(dathilbsmooth,75);
P75hs_curve=((ones(length(dat),1)*P75hs)');
P75hs_curve(P75hs_curve>=dathilbsmooth)=NaN;
hs_ueberthreshold           = diff( ~isnan([ NaN P75hs_curve NaN ]) );
hs_NumBlockStart   = find( hs_ueberthreshold>0 )-0;
hs_NumBlockEnd     = find( hs_ueberthreshold<0 )-1;
hs_NumBlockLength  = (hs_NumBlockEnd - hs_NumBlockStart + 1)/fs;

P75r=prctile(datrect,75);
P75r_curve=((ones(length(dat),1)*P75r)');
P75r_curve(P75r_curve>=datrect)=NaN;
r_ueberthreshold           = diff( ~isnan([ NaN P75r_curve NaN ]) );
r_NumBlockStart   = find( r_ueberthreshold>0 )-0;
r_NumBlockEnd     = find( r_ueberthreshold<0 )-1;
r_NumBlockLength  = (r_NumBlockEnd - r_NumBlockStart + 1)/fs;

P75rs=prctile(datrectsmooth,75);
P75rs_curve=((ones(length(dat),1)*P75rs)');
P75rs_curve(P75rs_curve>=datrectsmooth)=NaN;
rs_ueberthreshold           = diff( ~isnan([ NaN P75rs_curve NaN ]) );
rs_NumBlockStart   = find( rs_ueberthreshold>0 )-0;
rs_NumBlockEnd     = find( rs_ueberthreshold<0 )-1;
rs_NumBlockLength  = (rs_NumBlockEnd - rs_NumBlockStart + 1)/fs;


datrectsub=datrect-P75r;
datrectsub(datrectsub<=0)=0;

datrectsmoothsub=datrectsmooth-P75rs;
datrectsmoothsub(datrectsmoothsub<=0)=0;


dathilbsub=dathilb-P75h;
dathilbsub(dathilbsub<=0)=0;

dathilbsmoothsub=dathilbsmooth-P75hs;
dathilbsmoothsub(dathilbsmoothsub<=0)=0;




figure


subplot(5,1,1)
title('rote linie == 75ste percentile des blauen signals')
axis tight
hold on
plot(dat,'Color', 'black')
plot(1:1500,zeros(1500,1)', 'black')
title('Rohdaten (gefiltert)')
hold off


subplot(5,1,2)
axis tight
hold on
plot(dat,'Color', 'black')
plot(datrect, 'Color', 'b')
plot(1:1500,zeros(1500,1)', 'black')
plot(1:1500,P75r_curve(1:1500), 'Color', 'r')
title('rectified')

hold off

subplot(5,1,3)
axis tight
hold on
plot(dat,'Color', 'black')
plot(datrectsmooth, 'Color', 'b')
plot(1:1500,zeros(1500,1)', 'black')
plot(1:1500,P75rs_curve(1:1500), 'Color', 'r')
title('rectified+smoothed')
hold off

subplot(5,1,4)
axis tight
hold on
plot(dat,'Color', 'black')
plot(dathilb, 'Color', 'b')
plot(1:1500,zeros(1500,1)', 'black')
plot(1:1500,P75h_curve(1:1500), 'Color', 'r')
title('abs(hilbert)==env')
hold off

subplot(5,1,5)
axis tight
hold on
plot(dat,'Color', 'black')
plot(dathilbsmooth, 'Color', 'b')
plot(1:1500,zeros(1500,1)', 'black')
plot(1:1500,P75hs_curve(1:1500), 'Color', 'r')
title('abs(hilbert)==env, smoothed')
hold off

figure

subplot(4,1,1)
hold on
jbfill(1:length(dat),datrectsub,zeros(length(dat),1)')
title('rectified')
hold off

subplot(4,1,2)
hold on
jbfill(1:length(dat),datrectsmoothsub,zeros(length(dat),1)')
title('rectified+smoothed')
hold off

subplot(4,1,3)
hold on
jbfill(1:length(dat),dathilbsub,zeros(length(dat),1)')
title('abs(hilbert)==env')
hold off

subplot(4,1,4)
hold on
jbfill(1:length(dat),dathilbsmoothsub,zeros(length(dat),1)')
title('abs(hilbert)==env, smoothed')
hold off


    figure
    subplot(2,2,1)
    hold on
  %  ksdensity(r_NumBlockLength)
    histogram(r_NumBlockLength, 0:0.01:0.4, 'Normalization', 'probability')
    title('rectified')
    xlim([0 0.4])
    hold off
    
    subplot(2,2,2)
    hold on
    histogram(rs_NumBlockLength, 0:0.01:0.4, 'Normalization', 'probability')
 %   ksdensity(rs_NumBlockLength)
    title('rectified & smooth')
    xlim([0 0.4])
    hold off
    
    subplot(2,2,3)
    hold on
    histogram(h_NumBlockLength, 0:0.01:0.4, 'Normalization', 'probability')
 %   ksdensity(h_NumBlockLength)
    title('hilbert')
    xlim([0 0.4])
    hold off
    
    subplot(2,2,4)
    hold on
    histogram(hs_NumBlockLength, 0:0.01:0.4, 'Normalization', 'probability')
    %ksdensity(r_NumBlockLength)
    title('hilbert & smooth')
    xlim([0 0.4])
    hold off
    
    