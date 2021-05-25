function synthesizeUtt(stim,info)

file = 'stim/utt.pho';
fid = fopen(file,'w');

% translate into a .pho file from just a written string
for i = 1:length(stim)     
  if isVowel(stim(i)), len = info.vowel_len; else len = info.cons_len; ...
        end;
  fprintf(fid,'%s %s\n',stim(i),num2str(len));
end;    

fprintf(fid,'_ 50\n'); % to avoid pops/clicks

fclose(fid);

% synthesize the resulting wav file.
!./stim/mbrola-darwin-ppc ./stim/us3 ./stim/utt.pho ./stim/utt.wav
