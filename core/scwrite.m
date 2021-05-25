% scwrite.m
% Michael Frank
% 
% scwrite(text, window, center, wait [, delay])
% Writes to screen center and waits to go on for delay if wait = 0.
% If wait = 1, waits for a key to be pressed.

function scwrite(text,w,center,wait,varargin);

white = WhiteIndex(w);

if nargin > 4
    delay = varargin{1};
else
    delay = 0;
end;

Screen('Flip',w);
[x,y] = Screen('TextBounds',w,text);
Screen('DrawText',w,text,center(1)-(x(3)/2),center(2),white);
Screen('Flip',w);

if wait == 1
    KWait;
else
    WaitSecs(delay);
end;

end
