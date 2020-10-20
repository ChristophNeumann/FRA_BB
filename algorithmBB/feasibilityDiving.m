function [xyFeasible, fixedIndices, fixedValues] = feasibilityDiving(originalModel)
%OPTIMALITYDIVING Summary of this function goes here
%   Detailed explanation goes here
resultRLOR = RLOR(originalModel);
alpha = resultRLOR.objval;
%objMeasure = objectiveMeasure(originalModel,resultT.x);
reducedModel = originalModel;
fixedValues = [];
fixedIndices = [];
while alpha>0
    xycheck = getRounding(resultRLOR.x(1:end-1),reducedModel);
    feasModelVType = [reducedModel.vtype,'C'];
    y = resultRLOR.x(feasModelVType=='I');
    yCheck = xycheck(feasModelVType=='I');
    assert(length(yCheck)==length(y));
    activeConstraints = (resultRLOR.slack ==0);
    boolVectFixedVars = getFixingVector(y, yCheck,reducedModel,activeConstraints);
    fixedIndices = [fixedIndices,find(boolVectFixedVars)];
    fixedValues = [fixedValues,xycheck(boolVectFixedVars)];
    reducedModel = buildFixedModel(reducedModel,boolVectFixedVars,xycheck);
    resultRLOR = RLOR(reducedModel);  
    alpha = resultRLOR.objval;
    fprintf('current alpha value is: %i\n',alpha);
end
if alpha == 0
    xycheckLast = getRounding(resultRLOR.x(1:end-1),reducedModel);
    xyFeasible = inflateReducedPoint(xycheckLast,fixedIndices,fixedValues);
    assert(isfeasible(xyFeasible,originalModel));
    fprintf('Diving successful\n');
else 
    fprintf('Diving not successful\n');
end

