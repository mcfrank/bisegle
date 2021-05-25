function corr = aud2afcMSeg(ws,exptinfo,lex,subinfo,trial,text,varargin)
% AUD2AFC compares two auditory stimuli
%   RESP = AUD2AFC(WS,INFO,TRIAL,TEXT) compares TRIAL.CORR and
%   TRIAL.INCORR in a randomized order by asking the question specified in
%   TEXT. WS is the window struct that contains WS.PTR and .CENTER for use
%   of writing to the screen.  Response keys are 'Z' for the first option
%   and 'M' for the second option.
%
%   AUD2AFC(WS,CORRECT,INCORRECT,TEXT,DATAFILE) writes to dafile

if nargin>5,filename = varargin{1}; end;

% clear screen
Screen(ws.ptr,'Flip');

% response keys
one_key = KbName('z');
two_key = KbName('m');

% ask the question
scwrite('Ready?',ws.ptr,ws.center,0);
WaitSecs(exptinfo.test_wait);
Screen(ws.ptr,'Flip');

% present test items
order = Randi(2); 
t1 = trial; t2 = trial;
if order == 1
  t1.wds = t1.corr; t2.wds = t2.incorr;
else
  t1.wds = t1.incorr; t2.wds = t2.corr;
end;

synthesizeUttMSegTest(t1,lex,exptinfo);  
WaitSecs(exptinfo.test_isi);
synthesizeUttMSegTest(t2,lex,exptinfo);  

% get response
scwrite(text,ws.ptr,ws.center,0,0);
[key_code, rt] = getKeyPress;

if key_code(one_key), resp = 1;    
elseif key_code(two_key), resp = 2; 
else 
  resp = -1;
  player=audioplayer(tan(0:3000),44000); 
  play(player); 
  scwrite('Wrong Key!  Use the keys marked 1 and 2!',ws.ptr,ws.center,0,0.5);
end %if

if resp == order, corr = 1; else corr = 0; end;

% if there is a datafile, print response to datafile
fid = fopen(filename,'a');

% include all subject info
fprintf(fid,'%s\t',subinfo.subname);
fprintf(fid,'%s\t',datestr(now)); % time/date
fprintf(fid,'%s\t%s\t%d\t%d\t',trial.corr,trial.incorr,trial.corr_freq,trial.corr_len); % sentence length
fprintf(fid,'%1.3f\t%g\t%g',rt,resp,corr); % response stuff
fprintf(fid,'\n');

fclose(fid);    