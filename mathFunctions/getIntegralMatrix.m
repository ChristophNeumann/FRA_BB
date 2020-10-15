function [ mult, Bint ] = getIntegralMatrix( B )
%RATIONALIZEMATRIX Summary of this function goes here
%   Detailed explanation goes here
Bint = zeros(size(B));
mult = ones(size(B,1));
for i=1:size(B,1)
    multi = 1;
    Bint(i,:) = B(i,:);
    while(any(Bint(i,:)-floor(Bint(i,:))))
        Bint(i,:) = Bint(i,:).*2;
        multi = multi*2;
    end
    mult(i) = multi/2;
end

