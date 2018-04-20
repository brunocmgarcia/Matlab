%% s171119 poles von 6th order butterworth LP 500 bei Fs von 2000 anzeigen lassen
% fieldtrip: 
%   standart bp: ft_preproc_bandpassfilter.m:
%    N=4
%    Fn=Fs/2
%    [B, A] = butter(N, [unteregrenze/Fn oberegrenze/Fn])
%   standart ist twopass, also:
%    filt = filtfilt(B, A, dat')';


clear all
close all


[b, a] = butter(4, 500/1000);





end


figure
fvtool(b,a,'polezero')
[z,p,k] = tf2zpk(b,a)
text(real(z)-0.1,imag(z)-0.1,'\bfZeros','color',[0 0.4 0])
text(real(p)-0.1,imag(p)-0.1,'\bfPoles','color',[0.6 0 0])
