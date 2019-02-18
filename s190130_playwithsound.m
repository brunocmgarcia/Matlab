cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper_praeDez/01_AppendChannel_fs1000_LP450')
clear all
clc
close all

load('CG04_TP104_praeLD_LB20.mat')

tryout=[mean(data.trial{1,1}(1:10,200000:400000-1),1) zeros(1,20000) mean(data.trial{1,1}(1:10,end/2:(end/2)+400000-1),1)];
tryout=[(data.trial{1,1}(30,200000:400000-1)) zeros(1,20000) (data.trial{1,1}(30,end/2:(end/2)+400000-1))];




soundsc(tryout,80000);

% clear sound
figure
subplot(1,4,1)
test=data.trial{1,1}(1,:);
plot(test)
test=hilbert(test);
subplot(1,4,2)
plot((test))
%test=log(test);
subplot(1,4,3)
plot(real(test))
test=(ifft(test));
test=test(end/10:(end/10)*9);
subplot(1,4,4)
plot(test)
soundsc(test,1000)