function [objVal,time] = FRA_diving_heuristic(model, mode)
%FRA_DIVING_HEURISTIC Summary of this function goes here
%   Detailed explanation goes here
model = preProcessModel(model);
if ~isfield(model,'objcon')
    objCon = 0;
else
    objCon = model.objcon;
end
[xyFeasible, fixedIndices, fixingValues, alpha, ~, timeFD] = feasibilityDiving(model,mode);
time = timeFD;
if isnan(xyFeasible)
   objVal = inf;
elseif alpha>0
    objVal = transpose(currentmodel.obj)*point + objCon;
else
    [~, ~, v_check,~, ~, timeOD] = optimalityDiving(model,mode,fixedIndices,fixingValues);
    time = time+timeOD;
    objVal = v_check + objCon;
end
end

