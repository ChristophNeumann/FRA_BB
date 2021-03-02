function [timeGurobi, objValGurobi] = runGurobi(model,objVal)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
timeLimit = 1800;
params.outputflag = 0;
params.timeLimit = timeLimit;
params.cutoff = objVal;
params.solutionlimit = 1;
params.heuristics = 1;
resGurobi = gurobi(model,params);
if strcmp(resGurobi.status,'TIME_LIMIT')
    objValGurobi = inf;
    timeGurobi = timeLimit;
else    
    objValGurobi = resGurobi.objval;
    timeGurobi = resGurobi.runtime;
end
end

