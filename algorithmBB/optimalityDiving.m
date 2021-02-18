function [xyMinimal, depth, v_check,v_s] = optimalityDiving(originalModel, mode, fI, fV)
%OPTIMALITYDIVING Summary of this function goes here
%   Detailed explanation goes here
switch nargin
    case 4
        fixedValues = fV;
        fixedIndices = fI;
        numberOfFixings = length(fI);
        boolVectFixedVars = indicesToBooleanVector(fixedIndices,originalModel);
        reducedModel = buildFixedModel(originalModel,boolVectFixedVars,fixedValues);         
    case 2
        fixedValues = [];
        fixedIndices = [];
        numberOfFixings = 0;
        reducedModel = preProcessModel(originalModel);
    otherwise
        fprintf('inputargs must be either 2 or 4.');
end
        
maxIter = 30;
v_check = inf;
m = sum((reducedModel.vtype)=='I');
mn = length(reducedModel.vtype);
k = floor(m/maxIter-(10^-4)) + 1; 
indexMap = 1:mn;
xyMinimal = nan;
yCheck = zeros(m,1);
while length(yCheck)>k
    resultSOR = MinOverT(reducedModel); 
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
    yCheck = xy_s_red(reducedModel.vtype=='I');
    assert(length(yCheck)==length(y));
    activeConstraints = (resultSOR.slack ==0);
    if strcmp(mode,'MC')
        fprintf('Running in fixing mode MC \n');
        boolVectFixedVars = getFixingVectorMaxConstrs(y, yCheck,reducedModel,activeConstraints,k);
    elseif strcmp(mode,'RANDOM')
        boolVectFixedVars = getRandomFixingVector(yCheck, reducedModel,k);
    elseif strcmp(mode,'MR')
        fprintf('Running in fixing max-ratio mode\n');
        boolVectFixedVars = getFixingVector(y, yCheck,reducedModel,activeConstraints,k);
    else 
        boolVectFixedVars = getFixingVectorObjInfluence(y,yCheck, reducedModel,k);
    end
    numberOfFixings = length(indexMap(boolVectFixedVars));
    fixedIndices = [fixedIndices;reshape(indexMap(boolVectFixedVars),[numberOfFixings,1])];
    fixedValues = [fixedValues;xy_s_red(boolVectFixedVars)];
    indexMap = setdiff(1:mn,fixedIndices);
    reducedModel = buildFixedModel(reducedModel,boolVectFixedVars,xy_s_red(boolVectFixedVars));    
end
end

