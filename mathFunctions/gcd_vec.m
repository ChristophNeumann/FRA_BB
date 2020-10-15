function [ k ] = gcd_vec( a )
%GCD_VEC Summary of this function goes here
%   Detailed explanation goes here
if any(abs(a)==1) || all(a==0)
    k = 1;    
elseif length(a) ==1
    k = abs(a);
elseif length(a)==2
    k = gcd(a(1),a(2));
else
    k = gcd(a(1),gcd_vec(a(2:end)));
end

end

