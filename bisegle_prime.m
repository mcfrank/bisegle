% function bisegle(subname)
% bisegle (bistable segmentation study)
% Michael C. Frank (w/ inbal arnon & hal tiley)
% began programming SSN base 9/22/06
% adapted to bisegle 2/16/08
% added conditions 11/11/08

function bisegle_prime(subnum,cond)

settings.n_train = 25;
settings.n_test = 10;
settings.inter_utt_interval = .5;
settings.test_isi = .4;
settings.test_wait = .2;
settings.fname = 'data/ms-data.txt';
settings.vowel_len = 175;
settings.cons_len = 25;

cond_lens = [4 6];

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

% first prime
synthesizeUtt(sents{1}(1:cond_lens(cond)),settings);
playWav('stim/utt.wav');
WaitSecs(settings.inter_utt_interval);
    
% present full training
for i = 1:settings.n_train
  synthesizeUtt(sents{i},settings);
  playWav('stim/utt.wav');
  WaitSecs(settings.inter_utt_interval);
end

%% now show test instructions and do test
PrintInstructions(ws,'stim/bisegle-test.txt',800);

% first prime
synthesizeUtt(sents{1}(1:cond_lens(cond)),settings);
playWav('stim/utt.wav');
WaitSecs(settings.inter_utt_interval);

for i = settings.n_train+1:(settings.n_train + settings.n_test)
  for j = 1:length(sents{i})/2
    test.syls = length(sents{i})/2;
    test.c{j} = sents{i}(((j-1)*2)+1);
    test.v{j} = sents{i}(j*2);
  end
  
  test.utt = sents{i};  
  resp{i} = bisegleTest(ws,test,settings);
  WaitSecs(1);
end

save(['data/' subnum '-' num2str(cond) '-prime-data.mat'],'resp','settings','sents');
cls