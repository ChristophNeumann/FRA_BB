function coeff = ratToIntCoeff(A)
%RATTOINTCOEFF Summary of this function goes here
%   Detailed explanation goes here
[~,den] = rat(A);
den = den.*sign(den);
den = den(:);
relIntDen = den(den>1);
coeff = double(lcm(sym(relIntDen)));
end

