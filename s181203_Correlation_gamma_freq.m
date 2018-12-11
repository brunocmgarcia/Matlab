%%s181203_Correlation_gamma_freq
clear all
close all
clc

cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/180/TFRsWithNaN/fooofed/MAT_processed')
load results
load VAR_wanted181129
wanted=wanted(1:5,:);
wanted=wanted(:);

masterpeakfreq=results.masterpeakfreq;
masterpeakfreq=masterpeakfreq(wanted,:);
masterpeakfreq=nanmedian(masterpeakfreq(:,5:6),2);

masterpeakpowerlogBL=results.masterpeakpowerlogBL;
masterpeakpowerlogBL=masterpeakpowerlogBL(wanted,:);
masterpeakpowerlogBL=abs(nanmedian(masterpeakpowerlogBL(:,5:6),2));
%% edit 181211 x und y als vielfaches von TP101 --> fazit: killt die korrelation. 
% macht auch nicht so viel sinn. 
% for i=1:5:35
%     for ii=5:-1:1
%         masterpeakpowerlogBL(i+(ii-1))=(masterpeakpowerlogBL(i+(ii-1))/masterpeakpowerlogBL(i));
%     end
% end
% for i=1:5:35
%     for ii=5:-1:1
%         masterpeakfreq(i+(ii-1))=masterpeakfreq(i+(ii-1))/masterpeakfreq(i);
%     end
% end
%%
linearregression(masterpeakfreq,masterpeakpowerlogBL,'freq [Hz]','gamma power')

