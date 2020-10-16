function gurobiOutput = feasibilityDiving(resultT,originalModel)
%OPTIMALITYDIVING Summary of this function goes here
%   Detailed explanation goes here
resultRLOR = RLOR(originalModel);
xycheck = getRounding(resultT.x(1:end-1),originalModel);
activeConstraints = (resultT.slack ==0);
%objMeasure = objectiveMeasure(originalModel,resultT.x);
%boolVectFixedVars = getFixingVector(resultT.x, xycheck,originalModel,activeConstraints);
for i=1:3
    boolVectFixedVars = indicesToBooleanVector(i,originalModel);
    fprintf('fixing variable %i to %i \n',i,xycheck(i));
    reducedModel = buildFixedModel(originalModel,boolVectFixedVars,xycheck);
    gurobiOutput = MinOverT(reducedModel);   
end
end

