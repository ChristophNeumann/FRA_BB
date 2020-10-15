function [ initialRounding ] = getInitialRounding( y,eta )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
J = getActiveIndex(y);
initialRounding = round(y);
initialRounding(J) = round(y(J) - 0.5 * sign(eta(J)));
end

