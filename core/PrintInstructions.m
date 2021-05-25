%takes in a winStruct, a txtfilename, and a maxWidth, and prints to screen.
%the fileshould be a plain text file. need to flip to see.

%2006.08.04 ADN wrote it.
% 9/6/06 mcf edited.

function [outp]= PrintInstructions(ws, txtfilename, maxWidth, centered)

%automatically center the text.
if nargin<4
    centered = 1;
end

inps = textread(txtfilename,'%s','delimiter','\n');
outp = WrapInstructions(inps, maxWidth);
clear inps;
lines = length(outp);

[nb, ob] = Screen('TextBounds',ws.ptr,outp{1});
spacing = nb(4)*1.5; % double space
y = 0;

if (centered == 1)
    x = ws.rect(3)/2;
    for i = 1:lines
        y = y + spacing;
        if ~(strcmp(outp{i},''))
            DrawTextAt(ws.ptr, outp{i}, [x y]);
        end
    end
else
    
    x = 100;
    for i = 1:lines
        y = y + spacing;
        if ~(strcmp(outp{i},''))
            Screen('DrawText',ws.ptr, outp{i}, x, y, ws.white);
        end
    end
end 

Screen('Flip',ws.ptr);
DepressSpace();
Screen('Flip',ws.ptr);
end % function


% HELPER FUNCTIONS
function [out] = WrapInstructions(inp,maxWidth)

if (nargin < 2)
    maxWidth = 40;
end
m = 1;

for n = 1:length(inp)

    while (length(inp{n}) > maxWidth)
        spaces = find(inp{n}(1:maxWidth) == ' ');
        lastSpace=spaces(end);
        out{m} = inp{n}(1:lastSpace-1);
        inp{n} = inp{n}(lastSpace+1:end);
        m = m+1;
    end
    out{m} = inp{n};
    m = m +1;
end

out = out';

end % WrapInstructions

