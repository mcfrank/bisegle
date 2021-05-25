function DrawImgAt(ws, filename, xy)
% DRAWIMGAT takes a filename and xy center location, draws in windowPtr.
% 	will need to flip to see.
%
% created by ADN
% 06/07/27 - Added comments.
% 9/18/05 - goddamn, can't you guys do anything right?

img = imread(filename,'JPEG');
s = size(img);
tex = Screen('MakeTexture',ws.ptr,img);

if isnumeric(xy)
	Screen('DrawTexture', ws.ptr, tex, ...
		[0 0 s(2) s(1)], [xy(1) xy(2) xy(1)+s(2) xy(2)+s(1)]);
else 
	Screen('DrawTexture', ws.ptr, tex, [0 0 s(2) s(1)]); 
end;  

	
	
