function [ lbEnlarged, ubEnlarged] = enlargeBoxRestrictions( lb,ub )
%enlargeBoxRestrictions enlarges all box restrictions on integral
%variables. The aim is to obtain a nonempty inner parallel set. For
%instance, a restriction y <= 1.2 may be enlarged to y <= 1.499, without
%potential rounding errors. On the other hand, restrictions like y<=1.8
%need to be "retracted", as rounding errors might occur.
%eps Parameter aims to catch numerical instability
eps = 10^-4;
lbEnlarged = ceil(lb - eps)-0.5+eps;
ubEnlarged = floor(ub+eps)+0.5-eps;


end

