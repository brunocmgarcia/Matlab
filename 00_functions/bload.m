function out = bload(fname, arg1, startpos, datasize, skip)
% loads a binary file
%
% usage:  bload(fname, [NumChannels SamplesToLoad], startpos, datasize, skip)
% starts reading from startpos BYTES into the file (not samples)
% datasize defaults to 'short'
%
% final argument "skip" allows you to repeatedly skip the specified number of bytes
% to read only certain channels - see fread.

if (nargin < 4)
	datasize = 'short'; % short ist datasize 16bit=2byte
end

% if ~FileExists(fname)
%     error(sprintf('File %s does not exist!', fname));
% end

fp = fopen(fname, 'r'); % r heisst �ffnen mit readf access

if (nargin >=3)
	status = fseek(fp, startpos, 'bof'); % bof: beginning of file
	if (status ~= 0)
		error('Error doing fseek');
	end
end

if (nargin >= 5)
	out = fread(fp, arg1, datasize, skip);
else
	out = fread(fp, arg1, datasize);
end;

fclose(fp);