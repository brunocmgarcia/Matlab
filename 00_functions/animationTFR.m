function animationTFR(varargin)
    % defaults
        figure_zeitachse=xlim;
        startzeit=figure_zeitachse(1);
        stopzeit=figure_zeitachse(2);
        zeitfenster=10;
        fps=10; % 10fps ist auch das optimapvideo
        recording=1;
        
    if recording==1    
        fig=gcf;
        fig.OuterPosition=[2400 400 200 480];
    end

    switch nargin;
        case 0
             fprintf('defaultparameters: start %isec, stop %isec, zeitfenster %isec, fps %i.',startzeit, stopzeit, zeitfenster, fps);
        case 1
            startzeit=varargin{1};
        case 2
            startzeit=varargin{1};
            stopzeit=varargin{2};
        case 3
            startzeit=varargin{1};
            stopzeit=varargin{2};
            zeitfenster=varargin{3};
        case 4
            startzeit=varargin{1};
            stopzeit=varargin{2};
            zeitfenster=varargin{3};
            fps=varargin{4};
        otherwise
            fprintf('0-5 input arguments needed');
    end;
            
            
    
    iteration=0;
    ax=gca;
    axis manual
    hold on
    ax.XDir = 'reverse';
    rate=1/fps;

    tic
    
    for b=startzeit:rate:stopzeit
        iteration=iteration+1;
        xlim([b b+zeitfenster])
        filmchen(:,iteration)=getframe(gcf);
        xyz=(toc/iteration)-rate; %% verbruach dieser schleife minus erwünschter verbrauch: das Zuviele!
        %pause(rate-xyz) %% ideale pause minus das Zuviele
    end
    
myVideo = VideoWriter('TFRchan14.avi');
myVideo.FrameRate = fps;
open(myVideo);
writeVideo(myVideo, filmchen);
close(myVideo);

end

