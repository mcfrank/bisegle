function [ws] = InitScreen()
% Initializes screen, returns a struct containing:
% ws.ptr, the window pointer
% ws.rect, a rect the size of the window
% ws.center, the center of the screen.
% ws.black, the black index
% ws.white, the white index
% ws.ifi, the inter-frame-interval.

%clearing out all junk left over from previous runs and to reinit Screen
clear Screen

%Make sure this is an OpenGL Psychtoolbox - OSX or windows beta
AssertOpenGL;

% Get the list of screens and choose the one with the highest screen number.
% Screen 0 is, by definition, the display with the menu bar. Often when
% two monitors are connected the one without the menu bar is used as
% the stimulus display.  Chosing the display with the highest dislay number is
% a best guess about where you want the stimulus displayed.

screens=Screen('Screens'); % find the number of screens
screenNumber=max(screens); % put this on the highest number screen
% (0 is the 1st screen)

% Open a double buffered fullscreen window and draw a black background 
% to front and back buffers, and prepare for 6x smoothed stimuli.
% You can decrease  the amount of multisampling from 6 to 0 to increse 
% performance or increase it to 16 or 32 for increased AntiAliasing 
% (smoother stimuli). screen will automatically set it to the max 
% if you request too high a number.
[ws.ptr ws.rect]=Screen('OpenWindow',screenNumber,BlackIndex(screenNumber));

%Preps screen for openGL alpha blending and smoothing
Screen('BlendFunction', ws.ptr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

%Gets the center of the screen.
[x y] = RectCenter(ws.rect);
ws.center = [x y];

ws.black = BlackIndex(ws.ptr); % also good to know what the index of black is
ws.white = WhiteIndex(ws.ptr);

Screen('FillRect',ws.ptr, ws.black);

% set some font stuff up
Screen('TextFont',ws.ptr, 'Times');
Screen('TextSize',ws.ptr,24);
Screen('Flip', ws.ptr);

% To preserve compatability with other platforms we recommend using
% MaxPriority in your script on OS X, insted of the constant 9.
% Priority() can overload older
% machines that can't handle a redraw every 40 ms. If your machine
% is not fast enough, comment out this line.
Priority(MaxPriority(ws.ptr));

% Query duration of monitor refresh interval, inter-frame-interval
ws.ifi=Screen('GetFlipInterval', ws.ptr);

%return to low priority
Priority(0);

HideCursor;

