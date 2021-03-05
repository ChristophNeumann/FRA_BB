function [node_granular, objVal,objValPP, time, iterF, depthO] = FRA_diving_heuristic(model, mode)
%FRA_DIVING_HEURISTIC Summary of this function goes here
%   Detailed explanation goes here
model = preProcessModel(model);
depthO = 0;
objValPP = inf;
node_granular = false;
if ~isfield(model,'objcon')
    objCon = 0;
else
    objCon = model.objcon;
end
fprintf('Running Feasibility diving\n');
[xyFeasible, fixedIndices, fixingValues, alpha, iterF, timeFD] = feasibilityDiving(model,mode);
time = timeFD;
if isnan(xyFeasible)
   objVal = inf;
elseif alpha>0
    objVal = transpose(model.obj)*xyFeasible + objCon;
else
    fprintf('Running Optimality diving\n');
    node_granular = true;
    [~, depthO, v_check, v_pp, ~, timeOD] = optimalityDiving(model,mode,fixedIndices,fixingValues);
    time = time+timeOD;
    objVal = v_check + objCon;
    objValPP = v_pp + objCon;
end
end

