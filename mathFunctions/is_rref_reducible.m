function rref_reducible = is_rref_reducible(A)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
qMaxC = 30000;
nMaxC = 300000;
%A = A(~all(A==0,2),:);
rref_reducible = (size(A,1)< qMaxC) && (size(A,2)<=nMaxC);
end

