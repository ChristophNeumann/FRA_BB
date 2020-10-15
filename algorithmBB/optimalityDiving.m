function gurobiOutput = optimalityDiving(modelT,originalModel)
%OPTIMALITYDIVING Summary of this function goes here
%   Detailed explanation goes here
xycheck = getRounding(modelT.x,originalModel);
%i = getFixingIndex(modelT.x, xycheck,originalModel;
i=1;
for i=1:10
    reducedModel = buildFixedModel(originalModel,j,xycheck(j));
    currentIPSSolution = MinOverT(reducedModel);    
end

end

