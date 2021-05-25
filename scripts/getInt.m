function intfreq = getInt(freq,int)

intfreq = (2^(1/12))^(int-1) * freq;

% the way to get a well-tempered pitch is to take the twelfth root of 2 and
% take it to the power of the interval you want. 

%intervals = {'P1' 'm2' 'M2' 'm3' 'M3' 'P4' 'f5' 'P5' 'm6' 'M6' 'm7' 'M7' 'P8'};
%ind(cellfun(@(x) strcmp(x,int),intervals))