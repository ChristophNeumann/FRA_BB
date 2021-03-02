model.obj = [1;1;-1;-3];
model.A = sparse([1,1,1,2;-1,1,-1,-2;2,1,-1,-1]);
model.lb = transpose(repelem(0,4));
model.ub = transpose(repelem(1,4));
model.rhs = [2;-1;1];
model.vtype = 'ICII';
model.sense = transpose(repelem('<',3));
[xyFeasible, fI, fV, alpha] = feasibilityDiving(model, 'MC');
xyMinimal = optimalityDiving(model,'MC', fI, fV);
xyFeasible
xyMinimal
