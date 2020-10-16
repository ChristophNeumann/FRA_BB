function gurobiOutput = optimalityDiving(resultT,originalModel)
%OPTIMALITYDIVING Summary of this function goes here
%   Detailed explanation goes here
xycheck = getRounding(resultT.x,originalModel);
activeConstraints = (resultT.slack ==0);
boolVectFixedVars = getFixingVector(resultT.x, xycheck,originalModel,activeConstraints);
reducedModel = buildFixedModel(originalModel,boolVectFixedVars,xycheck);
gurobiOutput = MinOverT(reducedModel);   
end

