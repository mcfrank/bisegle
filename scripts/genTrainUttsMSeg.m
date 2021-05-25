function utts = genTrainUttsMSeg(lex,tokens)
% frequency balanced version

% calculate utterance lengths
sent_lens = poissrnd(2,tokens,1)+2;
sent_lens = sent_lens(cumsum(sent_lens)<=tokens);
num_sents = length(sent_lens);
num_remaining_sents = num_sents;
word_freqs = lex.freqs;

% for each utterance
for i = 1:sum(num_sents)
  num_remaining_sents = num_remaining_sents - 1;
  utts(i).num_words = sent_lens(i);
  utts(i).syls = 0;
  utts(i).c = [];
  utts(i).v = [];
  utts(i).word_lens = [];
  
  previous = 0;
  
  % for each word in the utterance
  for j = 1:sent_lens(i)
    % choose a word according to frequency
    word_probs = word_freqs / sum(word_freqs);    
    wd = find(multirnd(word_probs)>0);
    
    % check that there are no repetitions
    c = 1;
    while previous == wd 
      wd = find(multirnd(word_probs)>0);       
      c = c + 1; 
      if c > 100, break; end;
    end;

    previous = wd;
    
    utts(i).syls = utts(i).syls + lex.words{wd}.syls;
    utts(i).c = [utts(i).c lex.words{wd}.c];
    utts(i).v = [utts(i).v lex.words{wd}.v];
    utts(i).word_lens = [utts(i).word_lens lex.lens(wd)];
    
    word_freqs(wd) = word_freqs(wd) - 1;    
  end
end