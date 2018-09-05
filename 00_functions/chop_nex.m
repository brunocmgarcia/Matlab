%% s171114 read and write nex files zum choppen. input max filesize die ein einzelner channel haben darf in bytes, output 0 oder 1=war notwendig;
% geht nur mit continous data (raw and lfp)

function anzahl_bruchstuecke=chop_nex(maximumfilesizeallowed)

allnexfiles = dir('*.nex');
fileName=allnexfiles(1).name;
fileName=dir(fileName);
anzahl_bruchstuecke=ceil(fileName.bytes/maximumfilesizeallowed);
if anzahl_bruchstuecke > 1
    
    for chopordner_i=1:anzahl_bruchstuecke
        mkdir(['chopped_part_' sprintf('%02d',chopordner_i)])
    end

    for singlenexfile=1:length(allnexfiles)

        fileName=allnexfiles(singlenexfile).name;
        fileName=dir(fileName);
         % = 10Mbyte

        


        %% read





        in_id = fopen(fileName.name, 'r', 'l','US-ASCII');

            magic = fread(in_id, 1, 'int32');
            nexFile.version = fread(in_id, 1, 'int32'); 
            comment = fread(in_id, 256, '*char'); 
            nexFile.freq = fread(in_id, 1, 'double'); 
            nexFile.tbeg = fread(in_id, 1, 'int32');
            nexFile.tend = fread(in_id, 1, 'int32');
            nvar = fread(in_id, 1, 'int32');
            uebersprungen = fread(in_id, 260, '*char');
            type = fread(in_id, 1, 'int32');
            varVersion = fread(in_id, 1, 'int32');
            name = fread(in_id, 64, '*char');
            offset = fread(in_id, 1, 'int32');
            n = fread(in_id, 1, 'int32');
            wireNumber = fread(in_id, 1, 'int32');
            unitNumber = fread(in_id, 1, 'int32');
            gain = fread(in_id, 1, 'int32');
            filter = fread(in_id, 1, 'int32');
            xPos = fread(in_id, 1, 'double');
            yPos = fread(in_id, 1, 'double');
            WFrequency = fread(in_id, 1, 'double');
            ADtoMV  = fread(in_id, 1, 'double');
            NPointsWave = fread(in_id, 1, 'int32');
            NMarkers = fread(in_id, 1, 'int32');
            MarkerLength = fread(in_id, 1, 'int32');
            MVOfffset = fread(in_id, 1, 'double');  
            lueckezumoffset=fread(in_id, offset-692, '*char');
            timestamps = fread(in_id, [n 1], 'int32');
            fragmentStarts = fread(in_id, [n 1], 'int32');

            datalocation=ftell(in_id);
            FragmentLength=NPointsWave/length(timestamps);
            new_n=floor(n/anzahl_bruchstuecke);
            newNPointsWave=new_n*FragmentLength;
            for bruchstueck=1:anzahl_bruchstuecke

                %newtimestamps=timestamps((((bruchstueck-1)*n)+1):(bruchstueck*n));
                newtimestamps=timestamps(1:new_n);
                %newfragmentStarts=fragmentStarts((((bruchstueck-1)*n)+1):(bruchstueck*n));
                newfragmentStarts=fragmentStarts(1:new_n);

                fseek(in_id, (((bruchstueck-1)*new_n*FragmentLength*2)+datalocation),'bof');
                data = fread(in_id, [newNPointsWave 1], 'int16');
                %newnexFile.tbeg=newtimestamps(1)./nexFile.freq;
                newnexFile.tbeg=nexFile.tbeg;
                %newnexFile.tend=newtimestamps(end)./nexFile.freq;
                newnexFile.tend=nexFile.tend;
                % write

                out_id = fopen(['chopped_part_' sprintf('%02d',bruchstueck) '/' ...
                    fileName.name(1:end-4) 'chop' sprintf('%02d',bruchstueck) ...
                    'of' sprintf('%02d',anzahl_bruchstuecke) '.nex'], 'w', 'l','US-ASCII');

                    fwrite(out_id, magic, 'int32');
                    fwrite(out_id, nexFile.version, 'int32');
                    fwrite(out_id, comment, '*char');
                    fwrite(out_id, nexFile.freq, 'double'); 
                    fwrite(out_id, newnexFile.tbeg, 'int32');
                    fwrite(out_id, newnexFile.tend, 'int32');
                    fwrite(out_id, nvar, 'int32');
                    fwrite(out_id, uebersprungen, '*char');
                    fwrite(out_id, type, 'int32');
                    fwrite(out_id, varVersion, 'int32');
                    fwrite(out_id, name, '*char');
                    fwrite(out_id, offset, 'int32');
                    fwrite(out_id, new_n, 'int32');
                    fwrite(out_id, wireNumber, 'int32');
                    fwrite(out_id, unitNumber, 'int32');
                    fwrite(out_id, gain, 'int32');
                    fwrite(out_id, filter, 'int32');
                    fwrite(out_id, xPos, 'double');
                    fwrite(out_id, yPos, 'double');
                    fwrite(out_id, WFrequency, 'double');
                    fwrite(out_id, ADtoMV, 'double');
                    fwrite(out_id, newNPointsWave, 'int32'); %!
                    fwrite(out_id, NMarkers, 'int32');
                    fwrite(out_id, MarkerLength, 'int32');
                    fwrite(out_id, MVOfffset, 'double');
                    fwrite(out_id, lueckezumoffset, '*char');    
                    fwrite(out_id, newtimestamps, 'int32');
                    fwrite(out_id, newfragmentStarts, 'int32');
                    fwrite(out_id, data, 'int16');

                fclose(out_id);

            clearvars data newtimestamps newfragmentStarts

            end


        fclose(in_id);
        clearvars -except allnexfiles maximumfilesizeallowed anzahl_bruchstuecke 
    end
end



