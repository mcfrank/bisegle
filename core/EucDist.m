function [dist] = EucDist(a,b);
%EUCDIST computes euclidean distance between vectors.

if (length(a)==length(b))
    dist = sqrt(sum((a-b).^2));
else
    error('   Vectors are not of equal size.');
end