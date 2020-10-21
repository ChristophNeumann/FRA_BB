function [ model ] = preProcessModel( model)
%preProcessModel returns the equivalent model 
%which contains only \leq inequalities
model.A(model.sense=='>',:) = -model.A(model.sense=='>',:);
model.rhs(model.sense=='>',:) = -model.rhs(model.sense=='>',:);
model.sense(model.sense=='>') = '<';
model.ub(model.vtype=='B') = 1;
model.lb(model.vtype=='B') = 0;
model.vtype(model.vtype=='B') = 'I';
model.vtype = reshape(model.vtype, [length(model.vtype),1]);
model.sense = reshape(model.sense, [length(model.sense),1]);
end

