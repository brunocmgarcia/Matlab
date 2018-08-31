clear all
load VAR_datakey
[P F]=subdir('/Volumes/B_guettlec/Primaerdaten/TBSI');
clearvars F
P=P';
counter=1;
for i=1:length(P)
    aktuell=P(i);
    aktuell=aktuell{:};
    if length(aktuell)==57
        loeschindex(counter)=i;
        counter=counter+1;
    end
%     optimap=(strfind(P(i),'optimap')) ;
%      if isempty(optimap{:});
%         loeschindex(counter)=i;
%         counter=counter+1;
%     end
end

P(loeschindex)=[];

clearvars i

for i=1:length(P)
    aktuell=P(i);
    aktuell=aktuell{:};
    aktuell=aktuell(39:end);
    P(i)={aktuell};
end

Afields = fieldnames(datakey.key);
Acell = struct2cell(datakey.key);
sz = size(Acell) 
Acell = reshape(Acell, sz(1), []);      % Px(MxN)
Acell = Acell';        

c=setdiff(P(:,1),Acell(:,2));

clearvars i
%oldlength=length(datakey.key);
for i=828:827+length(c)
    datakey.key(i).video=c(i-827);
end


