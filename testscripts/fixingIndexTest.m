model.A = [1,1,2;-1,-1,-2;2,-1,-1];
model.vtype = 'III';
k=1;
delta = 1-1E-4;
activeConstraints = logical([1,1,0]);
y = [0.5-delta,0.5+delta,0.25];
yCheck = round(y);
boolFixingVector = getFixingVectorMaxConstrs(y,yCheck,model,activeConstraints,k);

assert(all(boolFixingVector==[0;0;1]));

fprintf("Test fox fixing indices (cf. Ex 4.5 paper) passed.\n"); 