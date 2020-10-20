function gurobiOutput = optimalityDiving(resultT,originalModel)
%OPTIMALITYDIVING Summary of this function goes here
%   Detailed explanation goes here
xycheck = getRounding(resultT.x,originalModel);
activeConstraints = (resultT.slack ==0);
objMeasure = objectiveMeasure(originalModel,resultT.x);
fprintf('Optimal objective value over the IPS is %f\n',resultT.objval);
%boolVectFixedVars = getFixingVector(resultT.x, xycheck,originalModel,activeConstraints);
for i=1:3
    boolVectFixedVars = indicesToBooleanVector(i,originalModel);
    fprintf('fixing variable %i to %i \n',i,xycheck(i));
    reducedModel = buildFixedModel(originalModel,boolVectFixedVars,xycheck);
    gurobiOutput = MinOverT(reducedModel);   
end
end

