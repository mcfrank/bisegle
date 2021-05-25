function playTone(freq,dur)
fs = 44100;
wav = tone(freq,dur,fs);
playSound(wav,fs);