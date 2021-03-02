function [xyFeasible, fixedIndices, fixingValues, alpha, sumSuffCond, time] = feasibilityDiving(originalModel,mode)
%OPTIMALITYDIVING Summary of this function goes here
%   Detailed explanation goes here
maxIter = 30;
sumSuffCond = 0;
reducedModel = preProcessModel(originalModel);
resultRLOR = RLOR(reducedModel);
alpha = resultRLOR.objval;
%objMeasure = objectiveMeasure(originalModel,resultT.x);
fixingValues = [];
fixedIndices = [];
m = sum((reducedModel.vtype)=='I');
mn = length(reducedModel.vtype);
k = floor(m/maxIter-(10^-4)) + 1; %+1?
i = 0;
indexMap = 1:mn;
xyFeasible = nan;
yCheck = zeros(m,1);
time = resultRLOR.runtime;
randStream = RandStream('mt19937ar');    
while alpha>0 && length(yCheck)>k %&& i<maxIter 
    xycheck = getRounding(resultRLOR.x(1:end-1),reducedModel);
    xyCandidate = inflateReducedPoint(xycheck,fixedIndices,fixingValues);
    if isfeasible(xyCandidate,originalModel)
        xyFeasible = xyCandidate;
    end
    feasModelVType = [reducedModel.vtype;'C'];
    y = resultRLOR.x(feasModelVType=='I');
    yCheck = xycheck(feasModelVType=='I');
    assert(length(yCheck)==length(y));
    activeConstraints = (resultRLOR.slack ==0);
    if strcmp(mode,'MC')
        [boolVectFixedVars, suffCondi] = getFixingVectorMaxConstrs(y, yCheck,reducedModel,activeConstraints,k);
        sumSuffCond = sumSuffCond + suffCondi;
    elseif strcmp(mode,'RANDOM')
    boolVectFixedVars = getRandomFixingVector(yCheck, reducedModel,k, randStream);
    else
        boolVectFixedVars = getFixingVector(y, yCheck,reducedModel,activeConstraints,k);
    end
    
    numberOfFixings = length(indexMap(boolVectFixedVars));
    fixedIndices = [fixedIndices;reshape(indexMap(boolVectFixedVars),[numberOfFixings,1])];
    fixingValues = [fixingValues;xycheck(boolVectFixedVars)];
    indexMap = setdiff(1:mn,fixedIndices);
    reducedModel = buildFixedModel(reducedModel,boolVectFixedVars,xycheck(boolVectFixedVars));
    resultRLOR = RLOR(reducedModel);  
    alpha = resultRLOR.objval;
    time = time + resultRLOR.runtime;
    fprintf('current alpha value is: %i\n',alpha);
    i = i + 1;
end
boolVectFixedIndices = indicesToBooleanVector(fixedIndices,originalModel,false);
[~,order] = sort(fixedIndices);
sortedFixingValues = fixingValues(order);
if ~isempty(order)
    testReducedModel = buildFixedModel(originalModel,boolVectFixedIndices,sortedFixingValues);
    assert(max((abs(testReducedModel.rhs-reducedModel.rhs)))<1E-7);
end
if alpha <= 0
    xycheckLast = getRounding(resultRLOR.x(1:end-1),reducedModel);
    xyFeasible = inflateReducedPoint(xycheckLast,fixedIndices,fixingValues);
    assert(isfeasible(xyFeasible,originalModel));
    fprintf('Diving successful\n');
elseif ~isnan(xyFeasible)
    assert(isfeasible(xyFeasible,originalModel));
    fprintf('Found a feasible point but fixed problem is not granular \n');
else 
    fprintf('Diving not successful\n');
end

