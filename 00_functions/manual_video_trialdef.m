%% manual_video_trialdef CAVE:now returns "artefact" times as Nx2 (ab CG01_TP00_Rec08)

function finalreturn=manual_video_trialdef(folder)
    
    ursprungsdir=cd;
    cd(folder);
    vidobj=VideoReader('Raw Video_1.avi');
    try
        videoinfo=load('Position Data.mat');
    catch
        videoinfo.video_frames(1,1)=vidobj.Duration*vidobj.FrameRate;
        videoinfo.x_pixel=1;
        videoinfo.time(1:videoinfo.video_frames(1,1),1)=...
            ([1:videoinfo.video_frames(1,1)]*(videoinfo.video_frames(1,1)/vidobj.Duration)*10)+97;
        uiwait(msgbox('Position Data not found; using avi inf instead','info','modal'));
    end
    
    currentframe=1;
    includeframe='g';
    geschwind=1;
    farbmodus(1:videoinfo.video_frames(1,1),1)='r';
    editmodus=1;
    run=1;
    slomo=0;
    global final;
   
    MonPos = get(0, 'MonitorPositions');

    if size(MonPos, 1) == 1
        mainfig=figure('units', 'pixel', 'Position', [0 480 640 480]);
    else
        mainfig=figure('units', 'normalized', 'Position', [1 1 1 1]);
    end
        
    set(gcf, 'WindowScrollWheelFcn', @wheel, 'Interruptible','off')
    %set(gcf, 'WindowKeyPressFcn',@keyPressCallback) % hotkey?
    movegui('center');
    S.f=imagesc(read(vidobj,currentframe));
    axis off;
    %text(1,465,folder,'FontSize',10,'Color','white');
    
    
    if size(MonPos, 1) == 1  % mehr als ein Monitor    
        commentfig=figure('units','normalized','outerposition',[.75 0 .25 1],'name','Notizen');
    else
        commentfig=figure('units','pix','outerposition',[MonPos(2,1)+MonPos(2,3)*.75 MonPos(2,2) MonPos(2,3)*.25 MonPos(2,4)],'name','Notizen');
    end
    uicontrol('style','edit','Min', 1, 'Max', 100,'units','normalized','position',[0 0 1 1],'callback',@emptycallback);
    
    if size(MonPos, 1) == 1
        timelinefig=figure('units', 'pixel', 'Position', [0 0 640 40]);
        movegui('center');
        set(timelinefig,'units', 'pixel', 'OuterPosition', [mainfig.OuterPosition(1) mainfig.OuterPosition(2)-200 ...
            mainfig.OuterPosition(3) 200]);
    
    else
        timelinefig=figure('units', 'pix', 'outerposition', [MonPos(2,1) MonPos(2,2) MonPos(2,3)*.75 MonPos(2,4)*.2],'name','Timeline');
    end
    
    timeline({''}, {[1]}, {[videoinfo.video_frames(1,1)]}, 'facecolor', 'r');
    

    figure(mainfig);
    


%     S.t=uicontrol('Style','toggle',...
%                  'Units','pix',...
%                  'Position',[85 455 50 20],... 
%                  'CallBack',@callb,...
%                  'String','Play');
             
        S.t=uicontrol('Style','toggle',...
                 'Units','normalized',...
                 'Position',[0.13 0.93 .05 .05],... 
                 'CallBack',@callb,...
                 'String','Play');         
             
             
    S.yes=uicontrol('Style','toggle',...
                 'Units','normalized',...
                 'Position',[0.19 0.93 .1 .05],... 
                 'CallBack',@include,...
                 'String','exclude');
             
     S.byebye=uicontrol('Style','pushbutton',...
                 'Units','normalized',...
                 'Position',[.3 .93 .1 .05],... 
                 'CallBack',@laufbandmode,...
                 'String','LBcalc');


    S.speed=uicontrol('Style','popupmenu',...
                 'Units','normalized',...
                 'Position',[.41 .93 .07 .05],... 
                 'CallBack',@speed,...
                 'String',{'1x'; 'slowmo'; '2x';'5x';'10x';'20x'});


    S.jumpback=uicontrol('Style','toggle',...
                 'Units','normalized',...
                 'Position',[.49 .93 .04 .05],... 
                 'CallBack',@jump,...
                 'String','3s');
    S.jumpto1=uicontrol('Style','toggle',...
                 'Units','normalized',...
                 'Position',[.54 .93 .05 .05],... 
                 'CallBack',@jumpstart,...
                 'String','tobeg');
    S.edit=uicontrol('Style','toggle',...
                 'Units','normalized',...
                 'Position',[.60 .93 .1 .05],... 
                 'CallBack',@editmode,...
                 'String','watchmode');
     S.byebye=uicontrol('Style','pushbutton',...
                 'Units','normalized',...
                 'Position',[.77 .93 .135 .05],... 
                 'CallBack',@fertig,...
                 'String','ok');
     S.invertTL=uicontrol('Style','pushbutton',...
                 'Units','normalized',...
                 'Position',[.71 .93 .05 .05],... 
                 'CallBack',@invertTL,...
                 'String','inv');

    uiwait(gcf)

    function [] = callb(varargin)
        set(S.t,'string','pause')
        drawnow
        updatetimebar;
        tic
        while run==1
            pause((0.1-toc)+slomo)
            tic
            if currentframe > (videoinfo.video_frames(1,1)-geschwind)
                currentframe=1+(geschwind-1);
                text(300,200,'RESTART','FontSize',12,'Color','red');
                updatetimebar;
                pause(2);
            end
            currentframe=currentframe+geschwind;
            if editmodus==1
                farbmodus((currentframe-geschwind)+1:currentframe,1)=includeframe;
            end
            S.f=imagesc(read(vidobj,currentframe));
            axis off;
            farboverlay=patch([0 640 640 0],[0 0 480 480],farbmodus(currentframe,1));
            set(farboverlay,'FaceAlpha',0.05);
            text(10,10,sprintf('Frame: %i of %i',currentframe, videoinfo.video_frames(1,1)),'FontSize',10,'Color','white');    
            if editmodus==1
                if includeframe=='g'
                    text(300,10,'including','FontSize',10,'Color','white');
                    farbmodus(currentframe,1)='g';
                else
                    text(300,10,'excluding','FontSize',10,'Color','white');
                    farbmodus(currentframe,1)='r';
                end
            else
                text(300,10,'watchmode','FontSize',10,'Color','white');
            end
            text(520,10,sprintf('Videospeed: %iX', geschwind),'FontSize',10,'Color','white');
            drawnow
            if run==0
                break
            end
            if ~get(S.t,'value')
                set(S.t,'string','Play')
                updatetimebar;
                break
            end
        end
    end

    function [] = speed(varargin)
        geschw=get(S.speed,'value');
        switch geschw
            case 1
                geschwind=1;
                slomo=0;
            case 2
                geschwind=1;
                slomo=0.1
            case 3
                geschwind=2;
                slomo=0;
            case 4
                geschwind=5;
                slomo=0;
            case 5
                geschwind=10;
                slomo=0;
            case 6
                geschwind=20;
                slomo=0;
        end
    end




    function [] = include(varargin)
        if editmodus==1   
            if ~get(S.yes,'value')       

                includeframe='g';
                farbmodus(currentframe,1)=includeframe;
                
                             
                          
                updatetimebar;
            else
                includeframe='r';
                farbmodus(currentframe,1)=includeframe;
                updatetimebar;
            end
        end
    end

    function wheel(varargin)
        if varargin{1, 2}.VerticalScrollCount  > 0
                if currentframe>1
                currentframe = currentframe-1;
                S.f=imagesc(read(vidobj,currentframe));
                axis off;
                text(520,10,'wheelmode','FontSize',10,'Color','white');
                
                if editmodus==1 

                    farbmodus(currentframe,1)=includeframe;
                     if includeframe=='g'
                        text(300,10,'including','FontSize',10,'Color','white');

                    else
                        text(300,10,'excluding','FontSize',10,'Color','white');

                    end
                else
                   text(300,10,'watchmode','FontSize',10,'Color','white');
                end
                farboverlay=patch([0 640 640 0],[0 0 480 480],farbmodus(currentframe,1));
                set(farboverlay,'FaceAlpha',0.05);
                text(10,10,sprintf('Frame: %i of %i',currentframe, videoinfo.video_frames(1,1)),'FontSize',10,'Color','white');    


                drawnow
            end
        else
            if currentframe<videoinfo.video_frames(1,1)
                currentframe = currentframe+1;
                S.f=imagesc(read(vidobj,currentframe));
                axis off;
                text(520,10,'wheelmode','FontSize',10,'Color','white');
                if editmodus==1 

                    farbmodus(currentframe,1)=includeframe;
                     if includeframe=='g'
                        text(300,10,'including','FontSize',10,'Color','white');

                    else
                        text(300,10,'excluding','FontSize',10,'Color','white');

                    end
                else
                   text(300,10,'watchmode','FontSize',10,'Color','white');
                end
                farboverlay=patch([0 640 640 0],[0 0 480 480],farbmodus(currentframe,1));
                set(farboverlay,'FaceAlpha',0.05);
                text(10,10,sprintf('Frame: %i of %i',currentframe, videoinfo.video_frames(1,1)),'FontSize',10,'Color','white');    


                drawnow
            end
        end
    end


    function [] = jump(varargin)
        currentframe=currentframe-(3*10*geschwind);
        if currentframe<1
              currentframe=1;
        end
    end

    function [] = jumpstart(varargin)
        currentframe=1;
    end
    

    function updatetimebar
        final=[];
     
       
        
        final_logical=logical(diff(farbmodus));
        [index , ~]=find(final_logical);
        index(2:end+1)=index;
        index(1)=0;
        index(end+1)=length(farbmodus);
        if farbmodus(1)=='g' && farbmodus(end)=='g'
            final(1:length(index(1:2:end)),1)=index(1:2:end)+1;
            final(1:end,2)=index(2:2:end);    
              
        elseif farbmodus(1)=='r' && farbmodus(end)=='r'
            final(1:length(index(2:2:end-1)),1)=index(2:2:end-1)+1;
            final(1:end,2)=index(3:2:end);  
            
            
        elseif farbmodus(1)=='r' && farbmodus(end)=='g'
            final(1:length(index(2:2:end)),1)=index(2:2:end)+1;
            final(1:end,2)=index(3:2:end); 
            
        elseif farbmodus(1)=='g' && farbmodus(end)=='r'
            final(1:length(index(1:2:end-1)),1)=index(1:2:end-1)+1;
            final(1:end,2)=index(2:2:end); 
            
        end
        
        figure(timelinefig);
        cla
        timeline({''}, {final(:,1)}, {final(:,2)}, 'facecolor', 'g');
        figure(mainfig);
        text(10,465,['Total number of included frames: ' num2str(sum(final(:,2)-final(:,1))+numel(final)-1)],'FontSize',12,'Color','white');
    end

    function [] = editmode(varargin)
        if ~get(S.edit,'value')
             editmodus=1;
             updatetimebar;
        else
            editmodus=0;
            updatetimebar;
        end

    end

    function laufbandmode(varargin)
        vorwaerts=diff(videoinfo.x_pixel(:,1));
        vorwaerts(vorwaerts==0)=-2;
        vorwaerts(vorwaerts > 0)=0;
        [indexvor ~]=find(vorwaerts);
        rueckw=diff(videoinfo.x_pixel(:,1));
        rueckw(rueckw<0)=0;
        [indexrueck ~]=find(rueckw);
        
        farbmodus(indexvor,1)='g';
        farbmodus(indexrueck,1)='r';
       
        for i = 2:(length(farbmodus)-1)
            if farbmodus(i)=='r' && farbmodus(i-1)=='g' && farbmodus(i+1)=='g'        
                    farbmodus(i)='g';         
            end
        end
        
         for i = 2:(length(farbmodus)-2)
            if farbmodus(i)=='r' && farbmodus(i-1)=='g' && farbmodus(i+2)=='g'        
                    farbmodus(i)='g'; 
                    farbmodus(i+1)='g'; 
            end
         end
        for i = 2:(length(farbmodus)-1)
            if farbmodus(i)=='g' && farbmodus(i-1)=='r' && farbmodus(i+1)=='r'        
                    farbmodus(i)='r';         
            end
        end
        for i = 2:(length(farbmodus)-1)
            if farbmodus(i)=='g' && farbmodus(i-1)=='r' && farbmodus(i+1)=='r'        
                    farbmodus(i)='r';         
            end
        end
            
        
        updatetimebar;
    end
    function invertTL(varargin)
        farbmodus(farbmodus=='g')='t';
        farbmodus(farbmodus=='r')='g';
        farbmodus(farbmodus=='t')='r';
        updatetimebar;
        pause(1)
    end

    function emptycallback(varargin)
    end

    function fertig(varargin)
        updatetimebar;
        pause(2)
        if final
            if final(1,1)==1 && final(end,2)==videoinfo.video_frames(1,1)
                excludedtimes(:,1)=final(1:end-1,2)+1;
                excludedtimes(:,2)=final(2:end,1)-1;
            elseif final(1,1)~= 1 && final(end,2)==videoinfo.video_frames(1,1)
                excludedtimes(1,1)=1;
                excludedtimes(2:length(final),1)=final(1:end-1,2)+1;
                excludedtimes(1:length(final),2)=final(1:end,1)-1;             
            elseif final(1,1)== 1 && final(end,2)~=videoinfo.video_frames(1,1)

                excludedtimes(:,1)=final(:,2)+1;
                excludedtimes(1:length(final)-1,2)=final(2:end,1)-1;
                excludedtimes(end,2)=videoinfo.video_frames(1,1);



            elseif final(1,1)~= 1 && final(end,2)~=videoinfo.video_frames(1,1)
                excludedtimes(1,1)=1;
                excludedtimes(2:length(final)+1,1)=final(1:end,2)+1;
                excludedtimes(1:length(final),2)=final(1:end,1)-1;
                excludedtimes(end,2)=videoinfo.video_frames(1,1);
            end
         
            finalreturn(:,1)=videoinfo.time(excludedtimes(:,1),1);
            finalreturn(:,2)=videoinfo.time(excludedtimes(:,2),1);

            finalreturn=finalreturn-videoinfo.time(1,1);
            cd(ursprungsdir);
            finalreturn=finalreturn/1000; % in sekunden
        else
            finalreturn(1,1)=videoinfo.time(1,1);
            finalreturn(1,2)=videoinfo.time(end,1);
            finalreturn=finalreturn-videoinfo.time(1,1);
            finalreturn=finalreturn/1000;
        end
        close(mainfig);
        close(timelinefig);
        run=0;
        return
        
        
    end
end