function yn = isVowel(lett)

vowels = {'i','A','u','I','E','{','V','U','O'};

if ismember(lett,vowels)
    yn = 1;
else
    yn = 0;
end;