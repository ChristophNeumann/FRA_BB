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
k = floor(m/maxIter) + 1; %+1?
i = 0;
indexMap = 1:mn;
xyFeasible = nan;
while alpha>0 && i<maxIter
    xycheck = getRounding(resultRLOR.x(1:end-1),reducedModel);
    xyCandidate = inflateReducedPoint(xycheck,fixedIndices,fixedValues);
    if isfeasible(xyCandidate,originalModel)
        xyFeasible = xyCandidate;
        fprintf('Found a feasible point \n');
    end
    feasModelVType = [reducedModel.vtype;'C'];
    y = resultRLOR.x(feasModelVType=='I');
    yCheck = xycheck(feasModelVType=='I');
    assert(length(yCheck)==length(y));
    activeConstraints = (resultRLOR.slack ==0);
    boolVectFixedVars = getFixingVectorMaxConstrs(y, yCheck,reducedModel,activeConstraints,k);
    numberOfFixings = length(indexMap(boolVectFixedVars));
    fixedIndices = [fixedIndices;reshape(indexMap(boolVectFixedVars),[numberOfFixings,1])];
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
elseif ~isnan(xyFeasible)
    assert(isfeasible(xyFeasible,originalModel));
    fprintf('Found a feasible point but fixed problem is not granular \n');
else 
    fprintf('Diving not successful\n');
end

