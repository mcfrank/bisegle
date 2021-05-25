function seg = bisegleTest(ws,utt,settings)

% set up the text parameters and screen stuff
Screen('TextSize', ws.ptr, 18);
Screen(ws.ptr,'TextFont', 'Courier');
ShowCursor;
seg = zeros(1,utt.syls-1);
char_len = Screen('TextBounds',ws.ptr,' na ');
char_len = char_len(3) / 4;

% write the words to the screen
[word lens] = writeWord(utt,seg);
[bounds] = Screen('TextBounds',ws.ptr,word);
left_side = ws.center(1) - (bounds(3)/2);

% boring position stuff.
positions = left_side + (lens.*char_len);
xs = 100;
ys = 100;
pos = [ws.center(1) - xs  ws.center(2) + (ys) ...
  ws.center(1) + xs ws.center(2) + (2*ys)];

% loop until a key gets hit
while ~KbCheck
  
  % put the whole thing on the screen
  word = writeWord(utt,seg);  
  Screen('DrawText',ws.ptr,word,left_side,ws.center(2),ws.white);
  
  for i = 1:length(positions)
    Screen('glPoint', ws.ptr, ws.white, positions(i), ws.center(2)-20,3);
  end
  
  Screen('FrameRect', ws.ptr, ws.white, pos, 4);
  Screen('DrawText',ws.ptr,'play',pos(1) + 75,pos(2) + 35);
  Screen('Flip',ws.ptr);
  
  % now get the mouse input, including clicks
  [x,y,buttons] = GetMouse;
  
  if buttons(1)
    while buttons(1)
      [x,y,buttons] = GetMouse;
    end

    if x > pos(1) && y > pos(2) && x < pos(3) && y < pos(4)
      synthesizeUtt(utt.utt,settings)
      playWav('stim/utt.wav');
    else  
      p = find(abs(positions-x)==min(abs(positions - x)));
      seg(p) = 1 - seg(p);
    end
  end
end

end

% this function rewrites the whole string on the screen with segmentation
% slashes according to the subject's choice
function [word lens] = writeWord(utt,seg)

word = [];
lens = 0;
for i = 1:utt.syls-1
  this_syl = [utt.c{i} utt.v{i}];
  
  if i == 1
    lens(i+1) = lens(i) + length(this_syl) + 1.5;
  else
    lens(i+1) = lens(i) + length(this_syl) + 3;
  end    
  
  word = [word this_syl];

  if seg(i) == 1
    word = [word ' | '];
  else
    word = [word '   '];
  end
end

this_syl = [utt.c{end} utt.v{end}];

word = [word this_syl];
lens(1) = [];

end

