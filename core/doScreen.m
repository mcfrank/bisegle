function ws = doScreen

try
	% screen stuff
	screens=Screen('Screens');
	screenNumber=0; %max(screens);
	[ws.ptr, ws.rect] = Screen('OpenWindow',screenNumber);
	ws.center = [ws.rect(3) ws.rect(4)]/2;
	ws.black = BlackIndex(ws.ptr);
	ws.white = WhiteIndex(ws.ptr);
	Screen('TextFont',ws.ptr, 'Geneva');
	Screen('TextSize',ws.ptr,24);
	Screen('FillRect', ws.ptr, ws.black);
	Screen('Flip',ws.ptr);
	HideCursor;
catch
	cls;
end;
	