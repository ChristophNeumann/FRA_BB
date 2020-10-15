function is_reducible = is_HNF_reducible(A)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
time_max_hnf = 1000;
is_reducible = (-517+5.9*size(A,1)+0.79*size(A,2))<time_max_hnf;
end

