function [ind] = SubArr2Ind(sized,arr);

%subarr2ind Takes in an array size and a array of subscripts. returns 
%linear index.

    str = '';
    for i = 1:length(arr)
        str = [str ',' num2str(arr(i))];
    end
    
    str = ['ind = sub2ind(sized ' str ');'];
    eval(str);
    