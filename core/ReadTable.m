function table = ReadTable(fname)
%
% function table = read_table(fname)
% Read a table from a tab delimited text file
% First row in the file = header
%
% fname - filename
%
% Created 10/16/2001 Itamar Kahn
% Revised 05/28/2004 Itamar Kahn

fid = fopen(fname,'r');
if (fid == -1),
	fprintf(1,['The file ' fname ' does not exist, aborting.\n']);
	table = -1;
	return;
end

%% Create the structure for the table

cols_num = 0;
cols_names = cell(0);
nextindex = 1;
header = fgetl(fid);

while (nextindex <= size(header,2)),
	cols_num = cols_num + 1;
	[a count errmsg newindex] = sscanf(header(nextindex:end),'%s ',1);
	cols_names(cols_num) = {mat2str(a)};
	nextindex = nextindex + newindex - 1;
end

line = fgetl(fid);
while (line ~= -1),
	nextindex = 1;
	for i=1:cols_num,	
		[a count errmsg newindex] = sscanf(line(nextindex:end),'%s ',1);
		if isempty(str2num(a)),
			a = {a};
		else
			a = str2num(a);
		end
	
		if ~exist(['col' num2str(i)],'var'),
			if iscell(a),
				eval(['col' num2str(i) '= cell(0);']);
			else
				eval(['col' num2str(i) '= [];']);
			end	
		end
		eval(['col' num2str(i) '=[col' num2str(i) '; a];']);
		nextindex = nextindex + newindex - 1;				
	end
	line = fgetl(fid);
end	
fclose(fid);
table.cols_names = cols_names(1:cols_num);
for i=1:cols_num,
	eval(['table.col' num2str(i) '= col' num2str(i) ';']);
end

return;


