function items = genTestItemsMSeg(lex,ss)

% choose pairs of test items

for i = 1:ss.num_test_trials
  n = Randi(lex.num_types);
  m = Randi(lex.num_types);
  items(i).corr = lex.words{n};
  items(i).incorr = lex.dists{m};
  items(i).corr_freq = lex.freqs(n);
  items(i).corr_len = lex.lens(n); 
end