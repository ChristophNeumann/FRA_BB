function [xyFeasible, fixedIndices, fixedValues] = feasibilityDiving(originalModel)
%OPTIMALITYDIVING Summary of this function goes here
%   Detailed explanation goes here
maxIter = 20;
reducedModel = preProcessModel(originalModel);
resultRLOR = RLOR(reducedModel);
alpha = resultRLOR.objval;
%objMeasure = objectiveMeasure(originalModel,resultT.x);
fixedValues = [];
fixedIndices = [];
m = sum((reducedModel.vtype)=='I');
mn = length(reducedModel.vtype);
k = round(m/maxIter);
i = 0;
indexMap = 1:mn;
while alpha>0 && i<maxIter
    xycheck = getRounding(resultRLOR.x(1:end-1),reducedModel);
    feasModelVType = [reducedModel.vtype;'C'];
    y = resultRLOR.x(feasModelVType=='I');
    yCheck = xycheck(feasModelVType=='I');
    assert(length(yCheck)==length(y));
    activeConstraints = (resultRLOR.slack ==0);
    boolVectFixedVars = getFixingVector(y, yCheck,reducedModel,activeConstraints,k);
    fixedIndices = [fixedIndices;reshape(indexMap(boolVectFixedVars),[k,1])];
    fixedValues = [fixedValues;xycheck(boolVectFixedVars)];
    indexMap = setdiff(1:mn,fixedIndices);
    reducedModel = buildFixedModel(reducedModel,boolVectFixedVars,xycheck);
    resultRLOR = RLOR(reducedModel);  
    alpha = resultRLOR.objval;
    fprintf('current alpha value is: %i\n',alpha);
    i = i + 1;
end
if alpha == 0
    xycheckLast = getRounding(resultRLOR.x(1:end-1),reducedModel);
    xyFeasible = inflateReducedPoint(xycheckLast,fixedIndices,fixedValues);
    assert(isfeasible(xyFeasible,originalModel));
    fprintf('Diving successful\n');
else 
    fprintf('Diving not successful\n');
    xyFeasible = inf;
end

