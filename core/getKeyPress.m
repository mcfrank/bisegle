function [keyCode,latency] = getKeyPress(varargin);
% [KEYCODE, LATENCY] = GETKEYPRESS 
%   Waits for a keypress. Returns the key pressed, and the time between when
%   the function was called and the key was pressed. Useful for measuring
%   reaction times.
% 
% [KEYCODE, LATENCY] = GETKEYPRESS(WAIT, KEYLIST)
%   Takes as arguments (1) the amount of time it should pause before beginning
%   to check for a keypress (so that one keypress isn't captured by multiple successive
%   calls to getkeypress), and (2) the list of keys it should respond to. 
%
%              DGY wrote it
%   2006/07/29 ADN added WaitSecs to loops to prevent locking-up.
%   9/17/06 MCF cleaned up

% inital pause and key list
if nargin > 0, wait = varargin{1}; WaitSecs(wait); end;
if nargin > 1, keyList = varargin{2}; end;

% don't factor the initial pause into the RT
onset = GetSecs;

% Check for keypress.
kc = 1;

while kc 
    [keyDown,press_time,keyArr] = KbCheck;
    if keyDown & length(find(keyArr))==1, kc = 0; end;
    WaitSecs(.001)
end;

latency = press_time - onset;
keyCode = keyArr;