function [xyMinimal, depth, v_check,v_s, sumSuffCond, time] = optimalityDiving(originalModel, mode, fI, fV)
%OPTIMALITYDIVING Summary of this function goes here
%   Detailed explanation goes here
switch nargin
    case 4
        fixedValues = fV;
        fixedIndices = fI;
        numberOfFixings = length(fI);
        if numberOfFixings>0
            fprintf('Optimality Diving from depth %i.\n',numberOfFixings);
            boolVectFixedIndices = indicesToBooleanVector(fixedIndices,originalModel,false);
            [~,order] = sort(fixedIndices);
            sortedFixingValues = fV(order);
            reducedModel = buildFixedModel(originalModel,boolVectFixedIndices,sortedFixingValues);
            mn = length(originalModel.vtype);
            indexMap = setdiff(1:mn,fixedIndices);
        else
            fprintf('Optimality Diving from root node.\n');
            numberOfFixings = 0;
            fixedValues = [];
            fixedIndices = []; 
            reducedModel = preProcessModel(originalModel);
            fprintf('Optimality Diving from root node.\n');
            mn = length(originalModel.vtype);
            indexMap = 1:mn;
        end
    case 2
        numberOfFixings = 0;
        fixedValues = [];
        fixedIndices = []; 
        reducedModel = preProcessModel(originalModel);
        fprintf('Optimality Diving from root node.\n');
        mn = length(originalModel.vtype);
        indexMap = 1:mn;
    otherwise
        fprintf('inputargs must be either 2 or 4.\n');
end

maxIter = 30;
v_check = inf;
sumSuffCond = 0;
m_red = sum((reducedModel.vtype)=='I');
k = floor(m_red/maxIter-(10^-4)) + 1; 
xyMinimal = nan;
yCheck = zeros(m_red,1);
time = 0;
randStream = RandStream('mt19937ar'); 
while length(yCheck)>=k 
    resultSOR = MinOverT(reducedModel); 
    time = time + resultSOR.runtime;
    v_sk = transpose(inflateReducedPoint(resultSOR.x,fixedIndices,fixedValues))*originalModel.obj;
    fprintf('v^s is %.2f \n',v_sk);
    xy_s_red = getRounding(resultSOR.x,reducedModel);
    xy_s = inflateReducedPoint(xy_s_red,fixedIndices,fixedValues);
    v_check_k = transpose(xy_s)*originalModel.obj;
    if v_check_k< v_check
        depth = length(fixedIndices);
        fprintf('Updating v_check from %.2f to %.2f at depth %i \n',...
                 [v_check,v_check_k,depth]);
        xyMinimal = xy_s;
        v_check = v_check_k;
        v_s = v_sk;        
    end 
    y = resultSOR.x(reducedModel.vtype=='I');
    if k==0 || isempty(y)
        break; 
    end
    yCheck = xy_s_red(reducedModel.vtype=='I');
    assert(length(yCheck)==length(y));
    activeConstraints = (resultSOR.slack ==0);
    if strcmp(mode,'MC')
        [boolVectFixedVars, sumSuffCond_k] = getFixingVectorMaxConstrs(y, yCheck,reducedModel,activeConstraints,k);
        sumSuffCond = sumSuffCond + sumSuffCond_k;
    elseif strcmp(mode,'RANDOM')
        boolVectFixedVars = getRandomFixingVector(yCheck, reducedModel,k,randStream);
    elseif strcmp(mode,'MR')
        boolVectFixedVars = getFixingVector(y, yCheck,reducedModel,activeConstraints,k);
    else 
        boolVectFixedVars = getFixingVectorObjInfluence(y,yCheck, reducedModel,k);
    end
    numberOfFixings = length(indexMap(boolVectFixedVars));
    fixedIndices = [fixedIndices;reshape(indexMap(boolVectFixedVars),[numberOfFixings,1])];
    fixedValues = [fixedValues;xy_s_red(boolVectFixedVars)];
    indexMap = setdiff(1:mn,fixedIndices);
    assert(length(fixedIndices) == length(unique(fixedIndices)))
    reducedModel = buildFixedModel(reducedModel,boolVectFixedVars,xy_s_red(boolVectFixedVars));    
end
end

