%% s190117_KSdifferences
clear all
clc
close all

load VAR_GlobalAim
K=cell2mat(GlobalAim(:,2));
S=cell2mat(GlobalAim(:,3));
mittel=@(x) (1.241+1.1115*x);
abwK=@(x) (1.241-15+1.1115*x);
abwS=@(x) (1.241+15+1.1115*x);
figure
hold on
scatter(K,S)
fplot(mittel, [0 max(K)])
fplot(abwK, [0 max(K)])
fplot(abwS, [0 max(K)])
scatter(K(S>abwS(K)),S(S>abwS(K)),'red')
scatter(K(S<abwK(K)),S(S<abwK(K)),'red')
hold off
ylim([0 max(S)])
ylabel('Saskia')
xlabel('Kaloyan')


   