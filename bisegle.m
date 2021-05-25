% function bisegle(subname)
% bisegle (bistable segmentation study)
% Michael C. Frank (w/ inbal arnon & hal tiley)
% began programming SSN base 9/22/06
% adapted to bisegle 2/16/08
% added conditions 11/11/08

function bisegle(subnum,cond)

settings.n_train = 25;
settings.n_test = 10;
settings.inter_utt_interval = .5;
settings.test_isi = .4;
settings.test_wait = .2;
settings.fname = 'data/ms-data.txt';
settings.vowel_len = 175;
settings.cons_len = 25;

cond_lens = [1 2 4];

%% initialize
bisegleInit;
ws = doScreen;

%% load sentences & show instructions
try
  [sents] = textread(['stim/stim' num2str(subnum) '.out'],'%s');
catch
  error('Unreadable subject number!')
  cls
end

PrintInstructions(ws,'stim/bisegle-instructions.txt',800);

%% present training
synthesizeUtt(sents{i}(1:4),settings);

for c = 1:cond_lens(cond) % repeat me cond_lens times
  for i = 1:settings.n_train
    synthesizeUtt(sents{i},settings);
    playWav('stim/utt.wav');
    WaitSecs(settings.inter_utt_interval);
  end
end

%% now show test instructions and do test
PrintInstructions(ws,'stim/bisegle-test.txt',800);

for i = settings.n_train+1:(settings.n_train + settings.n_test)
  i
  for j = 1:length(sents{i})/2
    test.syls = length(sents{i})/2;
    test.c{j} = sents{i}(((j-1)*2)+1);
    test.v{j} = sents{i}(j*2);
  end
  
  test.utt = sents{i};  
  resp{i} = bisegleTest(ws,test,settings);
  WaitSecs(1);
end

save(['data/' subnum 'data.mat'],'resp','settings','sents');
cls