function diving_output = FRA_diving_heuristic(model, mode)
%FRA_DIVING_HEURISTIC Summary of this function goes here
%   Detailed explanation goes here
model = preProcessModel(model);
depth0 = 0; 
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
    [~, depth0, v_check, v_pp, ~, timeOD] = optimalityDiving(model,mode,fixedIndices,fixingValues);
    time = time+timeOD;
    objVal = v_check + objCon;
    objValPP = v_pp + objCon;
end
diving_output.node_granular = node_granular;
diving_output.objVal = objVal;
diving_output.objValPP = objValPP;
diving_output.time = time;
diving_output.iterF = iterF;
diving_output.depth0 = depth0;
end

