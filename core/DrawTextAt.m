function [newX, newY] = DrawTextAt(windowPtr,text,coordinates,color)
% DrawTextAt draws text at certain coordinates of a given color
%   DrawTextAt(windowPtr text, coordinates, color)    
%   in buffer WINDOWPTR Takes a given string TEXT, 
%   draws it at COORDINATES , in color COLOR
%   if no color is supplied, the text is drawn in white,  unlike
%   Screen('DrawText'....
    
%06/07/21 Edited and Commented by ADN

if nargin < 4
    color = WhiteIndex(windowPtr);
end

[bounds,j] = Screen('TextBounds',windowPtr,text);
% computes bounds of text. slow the first time you call it.

startx = (coordinates(1)-round(bounds(3)/2));
starty = (coordinates(2)-round(bounds(4)/2));

[newX, newY] = Screen('DrawText', windowPtr, text, startx, starty, color);
