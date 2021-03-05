function [newPoint,objVal,runtime] = fixAndOptimize(model,pointT)
%FIX_AND_OPTIMIZE Summary of this function goes here
%   Detailed explanation goes here
indInt = [find(model.vtype=='I'), find(model.vtype=='B')];
indCon = find(model.vtype =='C');
fixedModel.A = model.A(:,indCon);
fixedModel.rhs = model.rhs - model.A(:,indInt)*pointT(indInt);
fixedModel.vtype = repelem('C',length(indCon));
fixedModel.obj = model.obj(indCon);
fixedModel.sense = model.sense;
fixedModel.lb = model.lb(indCon);
fixedModel.ub = model.ub(indCon);
params.outputflag = 0;
resFixAndOptimize = gurobi(fixedModel,params);
runtime = resFixAndOptimize.runtime;

newPoint = zeros(length(pointT),1);
newPoint(indInt) = pointT(indInt);
newPoint(indCon) = resFixAndOptimize.x;
objVal = model.obj'*newPoint;
assert(isfeasible(newPoint,model)==1);
end

