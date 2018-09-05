function sine_wave=simulated_data(duration, srate, frex, amplit, phases, noiseamp)
   
if (exist('duration') ~= 1)  duration = 180; end 
if (exist('srate') ~= 1)     srate = 2000; end    
if (exist('frex') ~= 1)      frex = [3 10 5 15 35]; end    
if (exist('amplit') ~= 1)    amplit = [5 15 10 5 7]; end
if (exist('phases') ~= 1)    phases = [pi/7 pi/8 pi pi/2 -pi/4]; end
if (exist('noiseamp') ~= 1)  noiseamp = 5; end

time=1/srate:1/srate:duration;

sine_waves = zeros(length(frex),length(time)); % remember: always initialize!
for fi=1:length(frex)
    sine_waves(fi,:) = (amplit(fi)) * sin(2*pi*frex(fi).*time + phases(fi));
end
if length(frex)>1
    sine_wave=(sum(sine_waves+noiseamp*randn(size(sine_waves))));
else
    sine_wave=sine_waves+noiseamp*randn(size(sine_waves));
end
% figure
% plot(time, sine_wave)
% axis tight
% title('sum of sine waves, time in s')
end
