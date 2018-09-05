function [data samplefreq]=ownreadnex(fileName) 


   fid = fopen(fileName, 'r', 'l','US-ASCII'); % readaccess, char hat 1 byte und nicht 4.little endian, format. >= 3 ist normal, -1 fehler
   magic = fread(fid, 1, 'int32'); % int-32 sind 4 bytes
       if magic ~= 827868494
            error 'The file is not a valid .nex file'
       end
   %ftell(fid) gibt auch byte 4 als antwort.
   nexFile.version = fread(fid, 1, 'int32'); %% bytes 5,6,7,8
   %ftell(fid) gibt auch byte 8 als antwort.
   %comment = fread(fid, 256, '*char')'; %256 bytes
   comment = fread(fid, 256, '*char')'; %256 bytes
   %ftell gibt 264 als antwort
   comment(end+1) = 0; 
   nexFile.comment = comment(1:min(find(comment==0))-1);% hier wird comment gestutzt
   
   nexFile.freq = fread(fid, 1, 'double'); % frequency, 8byte
   %ftell(fid) gibt 272 als antwort
   
   nexFile.tbeg = fread(fid, 1, 'int32')./nexFile.freq;
   %ftell(fid) gibt 276 als antwort
   %gespeichert ist die startzeit und nicht die startsamplenummer, fehler
   %im script?
   
   nexFile.tend = fread(fid, 1, 'int32')./nexFile.freq;
   %ftell(fid) gibt 280 als antwort, 
   %gespeichert ist die endzeit und nicht die endsamplenummer, fehler im
   %script?
   
   nvar = fread(fid, 1, 'int32');
   %ftell(fid) gibt 284 als antwort
   %wieviele variablen gibt es e.g. waveforms, events, data?
   
   fseek(fid, 260, 'cof'); %cof = current position
   %ftell(fid) gibt 544 als antwort
   
   type = fread(fid, 1, 'int32');
   %ftell(fid) gibt 548 als antwort
   
   varVersion = fread(fid, 1, 'int32');
   %ftell(fid) gibt 552 als antwort
   
   name = fread(fid, 64, '*char')';
   name(end+1) = 0;
   name = name(1:min(find(name==0))-1);
   %ftell(fid) gibt 616 als antwort
   % name ist bei mir der channelname
   
   offset = fread(fid, 1, 'int32');
   %ftell(fid) gibt 620 als antwort
   % offset ist bei mir 824, keine ahnung ob das für alle files gilt
   
   n = fread(fid, 1, 'int32');
   %ftell(fid) gibt 624 als antwort
   % n ist bei mir 3601
   
   wireNumber = fread(fid, 1, 'int32');
   %ftell(fid) gibt 628 als antwort
   %bei mir 0
   
   unitNumber = fread(fid, 1, 'int32');
   %ftell(fid) gibt 632 als antwort
   %bei mir 0
   
   gain = fread(fid, 1, 'int32');
   %ftell(fid) gibt 636 als antwort
   %bei mir 0
   
   filter = fread(fid, 1, 'int32');
   %ftell(fid) gibt 640 als antwort
   %bei mir 0
   
   xPos = fread(fid, 1, 'double');
   %ftell(fid) gibt 648 als antwort
   %bei mir 0
   
   yPos = fread(fid, 1, 'double');
   %ftell(fid) gibt 656 als antwort
   %bei mir 0
   
   WFrequency = fread(fid, 1, 'double');
   %ftell(fid) gibt 664 als antwort
   %bei mir 2000
   
   ADtoMV  = fread(fid, 1, 'double');
   %ftell(fid) gibt 672 als antwort
   %bei mir 1
   
   NPointsWave = fread(fid, 1, 'int32');
   %ftell(fid) gibt 676 als antwort
   %bei mir 1199133. eigentlich müsste es ja 1200000 sein (600s x 2000Hz)
   % 867 datapoints fehlen?
   
   NMarkers = fread(fid, 1, 'int32');
   %ftell(fid) gibt 680 als antwort
   %bei mir 0.
   
   MarkerLength = fread(fid, 1, 'int32');
   %ftell(fid) gibt 684 als antwort
   %bei mir 0.
   
   MVOfffset = fread(fid, 1, 'double');
   %ftell(fid) gibt 692 als antwort
   %bei mir 6.0135e-154, wird aber weil nicht grösser als version 104 auf 0
   %gesetzt
   MVOfffset = 0;
   
   fseek(fid, offset, 'bof');
   %offset war in diesem fall 824
   %ftell(fid) = 824
   
   timestamps = fread(fid, [n 1], 'int32')./nexFile.freq;
   %n ist in diesem fall 3601; n*4 bytes sind 14404
   %timestamps sind in sekunden
   %ftell(fid) = 15228
   
   fragmentStarts = fread(fid, [n 1], 'int32') + 1;
   %n ist in diesem fall 3601; n*4 bytes sind 14404
   %zu den timestamps korrespondierende punkte in den samples
   %ftell(fid) = 29632
   
   data = fread(fid, [NPointsWave 1], 'int16');
   %eigentlich noch .*ADtoMV + nexFile.contvars{contCount,1}.MVOfffset;
   %aber da ADtoMV = 1 und der MVOffFset=0 kann man es sich sparen. 
   %data hat 3601*333 samples à 2 byte int16
   %ftell(fid)=2427898
   
   samplefreq=nexFile.freq;
   fclose('all');
end
   