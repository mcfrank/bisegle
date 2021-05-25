function synthesizeUttMSeg(train_utts,settings)

time = 0;
file_num = 1;

file = ['./stim/train-' num2str(file_num) '.pho'];
fid = fopen(file,'w');
fprintf(fid,'_ 50\n');

for i = 1:length(train_utts)  
  % translate into a .pho file from just a written string
  for j = 1:train_utts(i).syls
    fprintf(fid,'%s %s 100 100\n',train_utts(i).c{j},num2str(settings.cons_len));
    fprintf(fid,'%s %s 100 100 \n',train_utts(i).v{j},num2str(settings.vowel_len));
    time = time + settings.vowel_len + settings.cons_len;
  end

  fprintf(fid,'_ %d\n',settings.train_isi); % to avoid pops/clicks
  time = time + settings.train_isi;
  
  % if the file is long enough, synthesize it
  if time > settings.chunk_len * 1000;
    fclose(fid);  
    % synthesize the resulting wav file.
    eval(['!./mbrola-darwin-ppc us3 ./stim/train-' num2str(file_num) '.pho ' ...
      './stim/train-' num2str(file_num) '.wav']);
    file_num = file_num + 1;    
    file = ['./stim/train-' num2str(file_num) '.pho'];
    fid = fopen(file,'w');
    fprintf(fid,'_ 50\n');
    time = 0;
  end
end
