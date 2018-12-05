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
masterpeakpowerlogBL=nanmedian(masterpeakpowerlogBL(:,5:6),2);

linearregression(masterpeakfreq,masterpeakpowerlogBL,'freq [Hz]','gamma power')

