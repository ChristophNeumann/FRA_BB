function [ model ] = preProcessModel( model)
%preProcessModel returns the equivalent model 
%which contains only \leq inequalities
model.A(model.sense=='>',:) = -model.A(model.sense=='>',:);
model.rhs(model.sense=='>',:) = -model.rhs(model.sense=='>',:);
model.sense(model.sense=='>') = '<';
model.ub(model.vtype=='B') = 1;
model.lb(model.vtype=='B') = 0;
model.vtype(model.vtype=='B') = 'I';
end

