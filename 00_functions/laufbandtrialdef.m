function final=laufbandtrialdef(alterordner,aktuellesfile)

%% auswählen im standbild mit track

videoordner=uigetdir(alterordner(1:(end-4)), strcat('video fuer:',aktuellesfile));
cd(videoordner);
close all


load('Position Data.mat', 'x_pixel', 'y_pixel', 'led_colors', ...
    'velocity', 'time');
    led_colors=led_colors/255;

figure('units', 'normalized', 'Position', [0 0 1 1]) %% vollbild
mycolors=[1 0 0; 0 1 1;0 1 0];
colormap(mycolors);

HalteDieSchleifeAmLaufen=1;
while HalteDieSchleifeAmLaufen==1
    
    vidobj=VideoReader('Raw Video_1.avi');
    thisframe=read(vidobj,1);
    subplot(4,2,[1 4])
    standbild=imagesc(thisframe);
    
    hold on
        plot(x_pixel(:,1), y_pixel(:,1), 'Color', led_colors(:,1))
        %plot(x_pixel(:,2), y_pixel(:,2), 'Color', led_colors(:,2))
        auswahlpolygon=ginput(4);
        scatter(auswahlpolygon(:,1),auswahlpolygon(:,2));
        auswahlpolygon(5,:)=auswahlpolygon(1,:);
        plot(auswahlpolygon(:,1),auswahlpolygon(:,2));
    hold off

    choice=questdlg('Einverstanden mit der Polygon Auswahl?', 'Weiter?','Ja', 'Nein', 'Video anzeigen','Ja');
    switch choice
        case 'Ja'
            break
        case 'Nein'
            continue
        case 'Video anzeigen'
            winopen('Raw Video_1.avi');
            continue
    end 
end

ausgeaehlterraum=inpolygon(x_pixel(:,1), y_pixel(:,1), ...
auswahlpolygon(:,1),auswahlpolygon(:,2)); % inpolygon sagt ob die pixel drin sind


%% velocity thresholding

subplot(4,2,5)
FIGoriginalgeschwindigkeit=plot(time(:,1)/1000,velocity(:,1));

smoothvelocity=conv(velocity(:,1),ones(20,1)/20,'same');
ersteableitungdergeschw=(diff(smoothvelocity));
ersteableitungdergeschw=conv(ersteableitungdergeschw(:,1),ones(50,1)/50,'same');

subplot(4,2,6)
hold on
    FIGconvgeschwindigkeit=plot(time(:,1)/1000,smoothvelocity);
    plot(time(1:(end-1),1)/1000,ersteableitungdergeschw*20);
hold off
ylim([-0.1 0.3])

subplot(4,2,7)
ersteAbleitungPlot=plot(time(1:(end-1),1)/1000,ersteableitungdergeschw);
%ylim([-0.02 0.02])

while HalteDieSchleifeAmLaufen==1

    [verwerfen,gewollterthreshold]=ginput(1);
    threshlinie=ones(length(time))*gewollterthreshold;
    
    x=(time(:,1)/1000)';
    y=smoothvelocity';
    z=(zeros(size(time(:,1)/1000)))';
    
    includedtimes=smoothvelocity;
    includedtimes(includedtimes>gewollterthreshold)=0;
    includedtimes(includedtimes<gewollterthreshold ...
        & includedtimes~=0)=1;
    includedtimes(isnan(includedtimes))=0;
    col4=includedtimes';
    col4=col4+1;
    
    FIGconvgeschwindigkeit;
    subplot(4,2,6)
        hold on
            surface([x;x], [y;y], [z;z], [col4;col4], 'facecol', 'no', 'edgecol','flat', 'linew', 1);
            plot(time(:,1)/1000, threshlinie);
            plot(time(1:(end-1),1)/1000,ersteableitungdergeschw*20);
        hold off
        ylim([-0.1 0.3])
   
        
      

    ersteAbleitungPlot;
    subplot(4,2,7)

        x4=(time(1:(end-1),1)/1000)';
        z4=(zeros(size(x4)));
        y4=ersteableitungdergeschw';
        col5=col4(1:(end-1));
        
        surface([x4;x4], [y4;y4], [z4;z4], [col5;col5], 'facecol', 'no', 'edgecol','flat', 'linew', 1);
       
    subplot(4,2,8)
    hold on
        col(ausgeaehlterraum==0)=1;
        col(ausgeaehlterraum==1)=2;
        y=((ones(length(x),1))')*2;
        surface([x;x], [y;y], [z;z], [col;col], 'facecol', 'no', 'edgecol','flat', 'linew', 20);

        y=(ones(1,length(x)))*1.5;
        col2=includedtimes';
        col2=col2+1;
        surface([x;x], [y;y], [z;z], [col2;col2], 'facecol', 'no', 'edgecol','flat', 'linew', 20);
 
        comb_auswahl=ones(length(includedtimes),1);
        comb_auswahl(includedtimes==0 | ausgeaehlterraum==0)=0;
        col3=comb_auswahl';
        col3=col3+1;
        y=ones(1,length(x));
        surface([x;x], [y;y], [z;z], [col3;col3], 'facecol', 'no', 'edgecol','flat', 'linew', 20);

    
    hold off
    ylim([0.8 2.2])
    
   
    
    
    aufforderungstext=strcat('Threshold auf  +', num2str(gewollterthreshold,4), ...
        '. Einverstanden?');
    choice=questdlg(aufforderungstext, 'Weiter?','Ja', 'Nein', 'Video anzeigen','Ja');
    switch choice
        case 'Ja'
            break
        case 'Nein'
            continue
        case 'Video anzeigen'
            winopen('Raw Video_1.avi');
            continue
    end 
end

close all;
%clearvars -except comb_auswahl time;

%N=diff([0 find(diff(comb_auswahl')) numel(comb_auswahl')]);
%comb_auswahl=comb_auswahl.*time(:,1);

N=diff(comb_auswahl);
N=find(N);
N(2:end+1)=N;
N(1)=0;
N(1:2:end,1)=N(1:2:end,1)+1;
if bitget(size(N,1),1) %% wenn ungerade dann läuft ein Ausschluss bis zum ende
    N(end+1)=size(comb_auswahl,1); % also letzten punkt hinzufügen
end
    
    
for i=1:length(N)
    N(i)=time(N(i));
end

final(:,1)=N(1:2:end,1);
final(:,2)=N(2:2:end,1);

end

