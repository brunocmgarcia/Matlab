%% s180809_add_matnamefinal_4ldopa
clear all
load VAR_datakey
counter=0;

for i=1036:length(datakey.key)
    matname=datakey.key(i).MAT_name;
    if ~isempty(matname)
        matnamefinal=datakey.key(i).MAT_name_final;
        if isempty(matnamefinal)
            finalgewuenscht=inputdlg([matname '///' datakey.key(i).kommentar],'input',1,{matname(1:end-5)},'on');
            if string(finalgewuenscht{:}) ~= string('')
                datakey.key(i).MAT_name_final=finalgewuenscht;
            end
            
            finalgewuenscht=finalgewuenscht{:};
            if string(finalgewuenscht)==string('stop')
                i
                error('stop')
                
            end
        end
    end
end
