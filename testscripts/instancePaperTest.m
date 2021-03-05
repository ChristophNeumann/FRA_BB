model.obj = [-1;0;-3];
model.A = sparse([1,1,2;-2,-2,+1]);
model.lb = transpose(repelem(0,3));
model.ub = transpose(repelem(2,3));
model.rhs = [3;-1];
model.vtype = repelem('I',3);
model.sense = transpose(repelem('<',2));
resultT = MinOverT(model);
resultT.x;
optimalityDiving(model, 'MC');