function lex = genLex

syls = {'bA','bi','dA','du','ti','tu','kA','ki','lA','lu','gi', ...
        'gu','pA','pi','vA','vu','zi','zu'};

lex.syls = syls;
lex.numsyls = length(lex.syls);
lex.numPrior = 1;
lex.uttPrior = 1;
lex.numSyls = length(lex.syls);
lex.numWds = 6;

% this specific function creates 6 words. 
% there are 2 2-syllable words, 2 3-syllable words, and 2
% 4-syllable words.  One of each length has a meaning.

ordermask = randperm(lex.numsyls);
wordlist = [1 2 0 0; ...
    3 4 0 0; ...
    5 6 7 0; ...
    8 9 10 0; ...
    11 12 13 14; ...
    15 16 17 18]; 

for i = 1:length(wordlist)
    lex.wds{i} = [];
    for j = 1:4
        if wordlist(i,j) ~= 0
            lex.wds{i} = [lex.wds{i} syls{ordermask(wordlist(i,j))}];
        end;
    end;
end;

lex.dists = genDistractors(lex);

end