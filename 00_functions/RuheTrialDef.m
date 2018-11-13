function final=RuheTrialDef(name, ordner, time);

cd(uigetdir(ordner, strcat('Ordner mit RuheTrialInfo.txt für', name, '?')));


textinput_good_times=dlmread('RuheTrialInfo.txt');
sekunden=(fix(textinput_good_times)*60)+((textinput_good_times-fix(textinput_good_times))*100);

for sekundeni=1:length(sekunden)*2
[verwerfen datatime(sekundeni)] = min(abs(time{1,1}-sekunden(sekundeni)));
end
datatime=sort(datatime);

datatime(1:2:end)=datatime(1:2:end)-1;
datatime(2:2:end)=datatime(2:2:end)+1;
datatime(2:end+1)=datatime;
datatime(1)=1;
datatime(end+1)=length(time{1,1});
%datatime=time{1,1}(1,datatime);


datatime2(:,1)=datatime(1:2:end);
datatime2(:,2)=datatime(2:2:end);
final=datatime2;
end 
