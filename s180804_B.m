%% datakey neu ordnen
load VAR_datakey
% in cellarray umwandeln
Afields = fieldnames(datakey.key);
Acell = struct2cell(datakey.key);
sz = size(Acell) 

% Convert to a matrix
Acell = reshape(Acell, sz(1), []);      % Px(MxN)

% Make each field a column
Acell = Acell';                         % (MxN)xP

% Sort by first field "name"
Acell = sortrows(Acell, 1);

% Put back into original cell array format
Acell = reshape(Acell', sz);

% Convert to Struct
datakey.key = cell2struct(Acell, Afields, 1);




>> a = {'the', 'he', 'hate'};
>> b = {'he', 'hate'};
>> c = setdiff(a,b)
c = 
      'the'
      
      
      
      for i=1:length(Acell)
          if isempty(Acell{i,2})
             Acell{i,2}='no video';
          end
      end
      