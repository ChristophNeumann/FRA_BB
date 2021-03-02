function [ xRounded ] = getRounding( x, model )
%Rounds a point x at integer indices (stored in model) and leaves
%the continuous variables as they are.
%In case of ambiguity in rounding, we look at the objective function and
%round to the better value
%assert(length(model.vtype) == length(model.obj));
assert(length(model.vtype) == sum(model.vtype=='I') + sum(model.vtype=='C'));
yVars = model.vtype=='I';
yHat = x(yVars);
ind_ambiguous = abs(yHat-floor(yHat)-0.5)<1E-12;
d = model.obj(yVars);
if(any(ind_ambiguous))
%    fprintf('rounding %i indices to the better objective value\n',sum(ind_ambiguous));
    yHat(ind_ambiguous)= (-0.1*sign(d(ind_ambiguous)))+yHat(ind_ambiguous);
end
yCheck = round(yHat);
xRounded = x;
xRounded(model.vtype=='I') = yCheck;
end

