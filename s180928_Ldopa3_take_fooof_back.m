%% Ldopa3: nimmt die gefoooften datein zurück.

clear all
s=load('fooof.mat');
fields=fieldnames(s);
figure('units','normalized','outerposition',[0 0 1 1]);
axis tight manual
farbe=hot(70);
for i=1:7:70
    gaussparam=s.(cell2mat(fields(i)));
    peakfit=s.(cell2mat(fields(i+1)));
    bgfit=s.(cell2mat(fields(i+2)));
    freq=s.(cell2mat(fields(i+3)));
    power=s.(cell2mat(fields(i+4)));
    R2=s.(cell2mat(fields(i+5)));
    fooofed=s.(cell2mat(fields(i+6)));
    
    subplot(1,3,1)
    hold on
    plot(freq,power, 'Color', farbe(i,:))
    hold off
    subplot(1,3,2)
    hold on
    plot(freq,fooofed, 'Color', farbe(i,:))
    hold off
    subplot(1,3,3)
    hold on
    plot(freq,peakfit, 'Color', farbe(i,:))
    hold off
end
