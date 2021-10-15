clear all;

params.mode = 'MC';
params.maxIter = 30;

%This Test is based on Example 4.5 but extends it with a continuous
%variable (second variable in the model) to cover also the mixed-integer
%case.

model.obj = [1;-1;-3];
model.A = sparse([1,1,2;-1,-1,-2;2,-1,-1]);
model.lb = transpose(repelem(0,3));
model.ub = transpose(repelem(1,3));
model.rhs = [2;-1;1];
model.vtype = 'III';
model.sense = transpose(repelem('<',3));

[xyFeasible, fI, fV, alpha] = feasibilityDiving(model, params);

%Here y3 gets fixed to 1 because Gorubi computes a different feasilbe point
%compared to the paper where we compute y3=0.

assert(fI==3); 
assert(fV==1); 

xyDiving = optimalityDiving(model, params, fI, fV);
resultsDivingOverall = FRA_diving_heuristic(model, params);

knownOutput = [0;0;1];

assert(all((xyDiving == resultsDivingOverall.xy)) && ...
           all(resultsDivingOverall.xy == knownOutput));

fprintf("Diving Test passed for testproblem from paper\n"); 
