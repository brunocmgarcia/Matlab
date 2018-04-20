%% s180216_play_with_animated_TFR




h = figure;
axis tight manual % this ensures that getframe() returns a consistent size
filename = 'testAnimated.gif';
for n = 1:length(data.label)
   spectrogram(data.trial{1,1}(n,:),hann(512),256,[2:1:60],1000,'yaxis', 'power');
    view(105, 54)
    shading interp
    colorbar off
    text(0,8,data.label(n),12)
    
    drawnow 
    
      % Capture the plot as an image 
      frame = getframe(h); 
      im = frame2im(frame); 
      [imind,cm] = rgb2ind(im,256); 
      % Write to the GIF File 
      if n == 1 
          imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
      else 
          imwrite(imind,cm,filename,'gif','WriteMode','append'); 
      end 
    
end
  

%% moving frame variante
while 1
for i=(-50/600):1/600:6
    xlim([0+i 0+i+50/600])
    pause(.06)
end
end