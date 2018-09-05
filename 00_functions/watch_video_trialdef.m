%% s171206 watch video+trialdef


function []=watch_video_trialdef(datakeyindex)
    clear all    
    datakeyindex=51;
    global datakey
    global data
    load VAR_datakey
    TBSI_path='/Volumes/A_guettlec/Primaerdaten/TBSI/';%'F:\Primaerdaten\TBSI\';
    trialdef_path='/Users/guettlec/Dropbox/data/videoartefaktdef/';
    datafolder='/Volumes/A_guettlec/Auswertung/171121_nur_appenddata_und_rename_channels/';
        
    load([trialdef_path datakey.key(datakeyindex).MAT_name '_viddef.mat']);
    load([datafolder datakey.key(datakeyindex).MAT_name '.mat']);
    ursprungsdir=cd;
    cd([TBSI_path datakey.key(datakeyindex).video])
    videoinfo=load('Position Data.mat');
    vidobj=VideoReader('Raw Video_1.avi');
    currentframe=1;
    geschwind=1;
    farbmodus(1:videoinfo.video_frames(1,1),1)='g';
    
    videoinfo.time=videoinfo.time-videoinfo.time(1,1);
    videoinfo.time(:,2)=[];
    
    
    
    
    
        for i=1:numel(videoartdef) % samplenum2time
            videoartdef(i)=data.time{1,1}(videoartdef(i));
        end
        clearvars i c index
        
        videoartdef=videoartdef*1000;
         for i=1:numel(videoartdef) % suche die sample nummer
            [c index] = min(abs(videoinfo.time-videoartdef(i)));
            videoartdef(i)=index;
        end
       clearvars i c index
       fortimeline=videoartdef;
       helperdef(1:2:numel(videoartdef)-1,1)=videoartdef(:,1);
    helperdef(2:2:numel(videoartdef),1)=videoartdef(:,2);
    videoartdef=helperdef; clearvars helperdef;
    
    for i=2:2:length(videoartdef)
        farbmodus(videoartdef(i-1):videoartdef(i))='r';
    end
    
    
    run=1;
    slomo=0;
    
    
    
    
    
    


    mainfig=figure('units', 'pixel', 'Position', [0 480 640 480]);
    set(gcf, 'WindowScrollWheelFcn', @wheel)
    %set(gcf, 'WindowKeyPressFcn',@keyPressCallback) % hotkey?
    movegui('center');
    S.f=imagesc(read(vidobj,currentframe));
    axis off;
    %text(1,465,folder,'FontSize',10,'Color','white');

    timelinefig=figure('units', 'pixel', 'Position', [0 0 640 40]);
    movegui('center');
    set(timelinefig,'units', 'pixel', 'OuterPosition', [mainfig.OuterPosition(1) mainfig.OuterPosition(2)-200 ...
        mainfig.OuterPosition(3) 200]);
    timeline({''}, {fortimeline(:,1)}, {fortimeline(:,2)}, 'facecolor', 'r');

    figure(mainfig);
    


    S.t=uicontrol('Style','toggle',...
                 'Units','pix',...
                 'Position',[85 455 50 20],... 
                 'CallBack',@callb,...
                 'String','Play');
    
     


    S.speed=uicontrol('Style','popupmenu',...
                 'Units','pix',...
                 'Position',[265 455 70 20],... 
                 'CallBack',@speed,...
                 'String',{'1x'; 'slowmo'; '2x';'5x';'10x';'20x'});


    S.jumpback=uicontrol('Style','toggle',...
                 'Units','pix',...
                 'Position',[345 455 25 20],... 
                 'CallBack',@jump,...
                 'String','3s');
    S.jumpto1=uicontrol('Style','toggle',...
                 'Units','pix',...
                 'Position',[375 455 35 20],... 
                 'CallBack',@jumpstart,...
                 'String','tobeg');
   
     S.byebye=uicontrol('Style','pushbutton',...
                 'Units','pix',...
                 'Position',[520 455 30 20],... 
                 'CallBack',@fertig,...
                 'String','ok');
     

    uiwait(gcf)

    function [] = callb(varargin)
        set(S.t,'string','pause')
        drawnow
        
        tic
        while run==1
            pause((0.1-toc)+slomo)
            tic
            if currentframe > (videoinfo.video_frames(1,1)-geschwind)
                currentframe=1+(geschwind-1);
                text(300,200,'RESTART','FontSize',12,'Color','red');
                
                pause(2);
            end
            currentframe=currentframe+geschwind;
           
            S.f=imagesc(read(vidobj,currentframe));
            axis off;
            farboverlay=patch([0 640 640 0],[0 0 480 480],farbmodus(currentframe,1));
            set(farboverlay,'FaceAlpha',0.05);
            text(10,10,sprintf('Frame: %i of %i',currentframe, videoinfo.video_frames(1,1)),'FontSize',10,'Color','white');    
            text(300,10,'watchmode','FontSize',10,'Color','white');
            text(520,10,sprintf('Videospeed: %iX', geschwind),'FontSize',10,'Color','white');
            drawnow
            if run==0
                break
            end
            if ~get(S.t,'value')
                set(S.t,'string','Play')
                
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



    function wheel(varargin)
        if varargin{1, 2}.VerticalScrollCount  > 0
                if currentframe>1
                currentframe = currentframe-1;
                S.f=imagesc(read(vidobj,currentframe));
                axis off;
                text(520,10,'wheelmode','FontSize',10,'Color','white');
                text(300,10,'watchmode','FontSize',10,'Color','white');  
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
                text(300,10,'watchmode','FontSize',10,'Color','white');              
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
    

    
    

    function fertig(varargin)
    
        close(mainfig);
        close(timelinefig);
        run=0;
        cd(ursprungsdir);
        return
        
        
    end
end