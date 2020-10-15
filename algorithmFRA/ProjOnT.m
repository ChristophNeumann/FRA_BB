function resultP = ProjOnT(x,model)
B = model.A(:,model.vtype=='I');
A = model.A(:,model.vtype=='C');
beta = zeros(size(A,1),1);
for s=1:size(A,1)
    beta(s) = norm(B(s,:),1);
end
modelP = model;
modelP.vtype = 'C';
modelP.rhs = model.rhs-0.5*beta;

modelP.Q = speye(size(modelP.A,2));
modelP.obj = -2.*x;
disp('Solve Proj onto T');
params.OutputFlag = 0;
resultP = gurobi(modelP,params);
fprintf('finished solving after %i seconds.', resultP.runtime);