function synthTwoThree(utt,ss)

file = './stim/utt.pho';
fid = fopen(file,'w');


fprintf(fid,'_ 50\n');

i = 1;
while i < length(utt.syls);
  fprintf(fid,'%s %s 100 100\n',utt.syls(i),num2str(ss.cons_len));
  i = i + 1;
  fprintf(fid,'%s %s 100 100 \n',utt.syls(i),num2str(ss.vowel_len));
  i = i + 1;
end

fprintf(fid,'_ 50\n'); % to avoid pops/clicks
!./mbrola-darwin-ppc us3 ./stim/utt.pho ./stim/utt.wav
playWav('stim/utt.wav');

