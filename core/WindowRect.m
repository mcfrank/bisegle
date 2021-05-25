function [rect] = WindowRect(w)
%WINDOWRECT takes a window ptr, and returns the rect of that window.
rect=Screen('Rect', w);