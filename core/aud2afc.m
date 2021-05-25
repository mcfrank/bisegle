function corr = aud2afc(ws,exptinfo,subinfo,trial,text,varargin)
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
WaitSecs(exptinfo.testWait);
Screen(ws.ptr,'Flip');

% present test items
order = Randi(2); % which one is the correct one?

if order == 1
  synthesizeUtt(trial.corr,exptinfo);  
  WaitSecs(exptinfo.testISI);
  synthesizeUtt(trial.incorr,exptinfo);  
else
  synthesizeUtt(trial.incorr,exptinfo);  
  PlayWav('stim/utt.wav');
  WaitSecs(exptinfo.testISI);
  synthesizeUtt(trial.corr,exptinfo);  
  PlayWav('stim/utt.wav');
end;

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
if exist('filename');
    fid = fopen(filename,'a');
    
    fprintf(fid,'\n');
    
    % include all subject info
    subinfofields = fieldnames(subinfo);
    for i = 1:length(subinfofields)
      if isnumeric(subinfo.(subinfofields{i}));
        fprintf(fid,'%d\t',subinfo.(subinfofields{i}));
      else
        fprintf(fid,'%s\t',subinfo.(subinfofields{i}));
      end;
    end;
    
    fprintf(fid,'%s\t',datestr(now)); % time/date
    fprintf(fid,'%d\t',trial.length); % sentence length
    fprintf(fid,'%1.3f\t%g\t%g\t',rt,resp,corr); % response stuff

    fclose(fid);    
end; % if
    
end % function