function playSound(y,Fs)

player=audioplayer(y,Fs); 
play(player); 
WaitSecs(length(y)/Fs);
