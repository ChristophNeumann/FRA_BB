B = [1,1,2;-2,-2,1;1,3,4];
activeConstraints = logical([1,1,0]);
y = [1.82,-0.4,0.24];
yCheck = round(y);
i = getFixingIndex(y,yCheck,B,activeConstraints);