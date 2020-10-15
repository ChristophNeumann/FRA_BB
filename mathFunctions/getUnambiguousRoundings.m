function [ S_amb ] = getUnambiguousRoundings( yRel,eta,S )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
S_amb = [];
for t = S
    k = getActiveIndex(yRel+eta*t);
    if length(k)>1
        S_amb = [S_amb,t]
    end
end

end

