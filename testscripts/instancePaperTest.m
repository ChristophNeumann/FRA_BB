clear all;

params.mode = 'MC';
params.maxIter = 30;

model.obj = [-1;0;-3];
model.A = sparse([1,1,2;-2,-2,1]);
model.lb = transpose(repelem(0,3));
model.ub = transpose(repelem(2,3));
model.rhs = [3;-1];
model.vtype = repelem('I',3);
model.sense = transpose(repelem('<',2));

resultT = MinOverT(model);
resultT.x;

pointPaper = [1.82;-0.4;0.24];
toleranceEnlargementParameters = 0.1;
assert(all((abs(resultT.x-pointPaper))<toleranceEnlargementParameters));

pointOptimalityDiving = [2;0;0];

xyOptimalityDiving = optimalityDiving(model, params);
resultsDiving = FRA_diving_heuristic(model, params);

assert(all(pointOptimalityDiving == resultsDiving.xy) & ...
       all(pointOptimalityDiving == xyOptimalityDiving));
   
fprintf("Diving Test passed for testproblem (Ex. 4.1) from paper\n"); 