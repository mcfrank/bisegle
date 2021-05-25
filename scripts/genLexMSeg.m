function lex = genLexMSeg

%[word syls freq] = textread('/Users/mfrank/Desktop/syll-freq.txt','%s%n%n','delimiter','\\');

% make syllables
lex.consonants = {'p','t','k','b','d','g','f','s','S','tS','T','v','z','Z',...
  'dZ','D','m','n','N','l','r','h','j','w'};
lex.vowels = {'i','A','u','I','E','{','V','U','EI','AI','OI','@U','aU','O'}; 
% took out '@' because it sounds funny

% frequencies of various lengths (from a fragment of english celex)
% looked like they were poisson distributed.  I just moved the poisson so
% it was posson of 2 + 1, meaning there are no zero freq words.
lex.num_types = 1000;
lex.lens = poissrnd(2,lex.num_types,1)+1;
lex.num_tokens = 60000;
k = .99;

% frequencies are distributed as a power law
lex.freqs = 1./((1:lex.num_types).^k);
lex.freqs = lex.freqs ./ sum(lex.freqs);
lex.freqs = ceil(lex.freqs .* lex.num_tokens);

% now create the words and distractors (distractors are matched for length)

for i = 1:lex.num_types
  lex.words{i}.syls = lex.lens(i);
  lex.dists{i}.syls = lex.lens(i);
  for j = 1:lex.words{i}.syls
    lex.words{i}.c{j} = lex.consonants{Randi(length(lex.consonants))};
    lex.words{i}.v{j} = lex.vowels{Randi(length(lex.vowels))};
    lex.dists{i}.c{j} = lex.consonants{Randi(length(lex.consonants))};
    lex.dists{i}.v{j} = lex.vowels{Randi(length(lex.vowels))};
  end
an