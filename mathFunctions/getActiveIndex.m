function [ J ] = getActiveIndex( y )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
global tol;
J = find(abs(y-floor(y)-0.5)==0);
end

