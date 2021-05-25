function dists = genDistractors(wds)

allwords = [];
n = length(wds);

% randomly concatenate all the words
for i = 1:n
  allwords = [allwords wds{i}];
end;

% two-character syllable case
c = 3;

% now resegment them into words of the same lengths
dists{1} = [];
for i = 1:n - 1
  dists{i + 1} = allwords(c:c+length(wds{i+1})-1);
  c = c + length(wds{i+1});
end;

dists{1} = [allwords(c:end) allwords(1:2)];