%% s181210_optical_flow 
% use manual trialdefs and videos to prepare maschinelearning inputs. 
% downsample videos to 160x120 dann horn schunck optical flow map. 
% zusätzlich die trialdef times wieder in frame bewertungen umwandeln.-
% ouput: 'total_u=frames*X*Y X velocity','total_v frames*X*Y Y velocity','time=framebewertung'
%%

clear all
clc
close all

%% 
load('VAR_datakey.mat')
cd('/Volumes/A_guettlec/Auswertung/tensorflow/videoartefaktdef')
ordner=dir('*.mat');
files={ordner.name}';
for file_i=140%:142;
   
    
    datei=files(file_i);
    datei=datei{:};   
    MAT_nameliste={datakey.key(:).MAT_name}';
    MAT_nameliste(cellfun('isempty', MAT_nameliste)) = {''}; % notwendig wenn liste l�cken hat.
    [index verwerfen] = find(~cellfun('isempty', strfind(MAT_nameliste, datei(1:end-11))));  
    ruhe20test=datakey.key(index).MAT_name_final;
    ruhe20test=ruhe20test(end-3:end);
    if ruhe20test~="Ruhe"
        newvid = VideoWriter([datakey.key(index).MAT_name '.avi'],'Motion JPEG AVI');
        newvid.FrameRate=10;
        open(newvid)
        load(datei)
        load(['/Volumes/A_guettlec/Auswertung/FINAL180416/00_Rec2Mat_corrChannels/' datakey.key(index).MAT_name '.mat'])
        cd(['/Volumes/A_guettlec/Primaerdaten/TBSI/' datakey.key(index).video])
        rawvideo = VideoReader('Raw Video_1.avi');
        load('Position Data.mat','time')
        cd('/Volumes/A_guettlec/Auswertung/tensorflow/videoartefaktdef')
        time=(time(:,1)/1000)';


        timeaxis=data.time{1,1};
        videoartdef=timeaxis(videoartdef);
        %videoartdef=videoartdef(:)';

        for i=1:numel(videoartdef)
            [verwerfen closestframe]=min(abs(videoartdef(i)-time));
            videoartdef(i)=closestframe;
        end

        time(2,:)=1;

        for i=1:size(videoartdef,1)
            time(2,videoartdef(i,1):videoartdef(i,2))=0;
        end

        clearvars videoartdef verwerfen data closestframe


        u=(zeros(120,160));
        v=u;
        %hold on
        frame1=readFrame(rawvideo);
        frame1 = rgb2gray(frame1);
        imshow(frame1)
        figure
        frame1 = imresize(frame1,0.25,'nearest');
        imshow(frame1)
        numFrames=1;
        figure('Name',datakey.key(index).MAT_name_final)
  
       % axis tight
        while hasFrame(rawvideo)

            numFrames = numFrames + 1;


            frame2=readFrame(rawvideo);
            frame2 = rgb2gray(frame2);
            frame2 = imresize(frame2,0.25,'nearest');
            % 
            %figure
            % subplot(1,3,1)
            % imshow(frame1)
            % subplot(1,3,2)
            % 
            % imshow(frame2)
            % subplot(1,3,3)

            [u,v]=HS(frame1,frame2,50,50);
%             v=v(1:4:end,1:4:end);
%             u=u(1:4:end,1:4:end);
            

            hold on
%             if time(2,numFrames-1)==1
%                 scatter(sum(sum((u))),sum(sum(v)),'b','filled');
%             else
%                 scatter(sum(sum((u))),sum(sum(v)), 'r','filled');
%             end
% 
%             hold off
            
            imshow(frame1)
             rSize=5;
             scale=10;
            for ii=1:size(u,1)
              for j=1:size(u,2)
                 if floor(ii/rSize)~=ii/rSize || floor(j/rSize)~=j/rSize
                    u(ii,j)=0;
                    v(ii,j)=0;
                 end
              end
            end
            hold on
            quiver(u, v, scale, 'color', 'b', 'linewidth', 2);
            set(gca,'YDir','reverse');
            line([80 60+(mean(u(:)*2.5e4))],[80 60+(mean(v(:)*2.5e4))],'Color','r')
            if time(2,numFrames-1)==1
                 rectangle('Position', [5 5 10 10], 'FaceColor', [0 1 0 0.8])
            else
                 rectangle('Position', [5 5 10 10], 'FaceColor', [1 0 0 0.8])
            end
            hold off
            xlim([0 160])
            ylim([0 120])
            writeVideo(newvid,getframe(gca));
            close all
            frame1=frame2;
            
           
            
            total_u(numFrames-1,:,:)=single(u);
            total_v(numFrames-1,:,:)=single(v);
        end
        close(newvid)
        save([datakey.key(index).MAT_name '_Flow'],'total_u','total_v','time');
    end
end
%hold off
% 
% 
% [x,y] = meshgrid(0:0.2:2,0:0.2:2);
% u = ones(11,11)*10000;
% v = ones(11,11)*10000;
% 
% figure
% quiver(x,y,u,v)