function [minT] = MinOverT(model)
%Returns the solution from minimizing over the inner parallel set. Note
%that here, we return the model output and not the optimal point, as the
%model might be infeasible (this method is used in TNotEmpty(model)) 

B = model.A(:,model.vtype=='I');
beta = sum(abs(B),2);
assert(all(beta(model.sense=='=')==0));
assert(sum(model.vtype=='I')+sum(model.vtype=='C') == length(model.obj));
modelT = getEnlargedModel(model);
assert(sum(modelT.vtype=='I')+sum(modelT.vtype=='C') == length(modelT.obj));
modelT.vtype = repelem('C',length(model.obj));
modelT.rhs = modelT.rhs-0.5*beta;
params.outputflag = 0;
minT = gurobi(modelT, params);
end
