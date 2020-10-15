function resPl1 = ProjOnTl1( x, model)
%ProjOnTl1 projects x onto the inner parallel set T using the l1-norm
enlargedModel = getEnlargedModel(model);

B = enlargedModel.A(:,enlargedModel.vtype=='I');
beta = sum(abs(B),2);
rhs = enlargedModel.rhs-0.5*beta;

clear modelL1Norm;
p = size(enlargedModel.A,1);
n= length(enlargedModel.obj);
%Build new model with dimension 3n (cf. Thesis, page 11)
A = sparse([enlargedModel.A,sparse(p,2*n)]);
%Aepi needs to fulfill x-xCurrent = -y+z 
Aepi = sparse(n,3*n);
Aepi(:,1:n) = speye(n);
Aepi(:,n+1:2*n) = speye(n);
Aepi(:,2*n+1:3*n) = -speye(n);
modelL1Norm.A = [A;Aepi];
modelL1Norm.obj = [zeros(n,1);ones(2*n,1)];
modelL1Norm.rhs = [rhs;x];
modelL1Norm.sense(1:p) = enlargedModel.sense;
%Enlarge Box constraints to, e.g. [-0.4999,1.4999]
modelL1Norm.sense((p+1):(p+n))= '=';
[lbEnlarged,ubEnlarged] = enlargeBoxRestrictions(...
                          enlargedModel.lb(enlargedModel.vtype=='I'), enlargedModel.ub(enlargedModel.vtype=='I'));
modelL1Norm.lb = [enlargedModel.lb;zeros(2*n,1)];
modelL1Norm.ub = [enlargedModel.ub;inf(2*n,1)];
modelL1Norm.lb(enlargedModel.vtype=='I') = lbEnlarged;
modelL1Norm.ub(enlargedModel.vtype=='I') = ubEnlarged;

modelL1Norm.vtype='C';
params.outputflag = 0;
resPl1 = gurobi(modelL1Norm,params);
end