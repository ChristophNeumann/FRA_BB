clear all;

params.mode = 'MC'; %Can be 'MC'(max constraints - greedy) or 'RA'(random)
params.maxIter = 30;

%Model from Example 4.1. 
model.obj = [-1;0;-3];
model.A = sparse([1,1,2;-2,-2,1]);
model.lb = transpose(repelem(0,3));
model.ub = transpose(repelem(2,3));
model.rhs = [3;-1];
model.vtype = repelem('I',3);
model.sense = transpose(repelem('<',2));

%FRA_diving_heuristic first executes feasibility diving and, after arriving
%at a granular node, optimality diving.

resultsDiving = FRA_diving_heuristic(model, params);
fprintf('depth of the first granular node is %i \n',resultsDiving.depth0) 
fprintf('point found by diving is: ')
resultsDiving.xy
fprintf('objective value of the feasible point is %i \n',resultsDiving.objVal)