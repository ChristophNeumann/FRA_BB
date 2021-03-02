function [ minFP ] = RLOR( model )
%FEASIBLEPOINTT2 Summary of this function goes here
%   Detailed explanation goes here
%eps = 1e-04;
B = model.A(:,model.vtype=='I');
beta = sum(abs(B),2);
assert(all(beta(model.sense=='=')==0));
modelT = getEnlargedModel(model);
assert(sum(modelT.vtype=='I')+sum(modelT.vtype=='C') == length(modelT.obj));
modelT.vtype = [repelem('C',length(model.obj)),'C'];
modelT.lb = [modelT.lb;-1];
modelT.ub = [modelT.ub;inf];
% Lower and Upper bounds are already treated in getEnlargedModel
modelT.rhs = modelT.rhs-0.5*beta;
modelT.A = [modelT.A,zeros(size(modelT.A,1),1)];
% Only introduce alpha for inequality constraints.
modelT.A(model.sense=='<',end) =-ones(size(modelT.A(model.sense=='<'),1),1);
modelT.obj = [repelem(0,length(modelT.obj)),1];
if isfield(modelT,'varnames')
    modelT.varnames{end+1} = 'fvar';
end
modelT.objcon = 0;
params.outputflag = 0;
minFP = gurobi(modelT, params);

end

