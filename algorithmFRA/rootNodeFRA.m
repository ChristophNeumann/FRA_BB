function resultsRootNode = rootNodeFRA(currentmodel)
%ROOTNODEFRA Summary of this function goes here
%   Detailed explanation goes here
if isfield(currentmodel,'objcon')
   objcon = currentmodel.objcon; 
   fprintf('contains objective offset\n');
else
    objcon = 0;
end
minRLOR = RLOR(currentmodel);
time = minRLOR.runtime;
alpha = minRLOR.objval;
granular = (alpha<=0);
xy_root_node = getRounding(minRLOR.x(1:end-1),currentmodel);
if granular
    resultSOR = MinOverT(currentmodel); 
    time = resultSOR.runtime;
    xy_s = getRounding(resultSOR.x,currentmodel);
    vCheck0 = transpose(xy_s)*currentmodel.obj + objcon;
    [newPoint,vCheck0PP,timePP] = fixAndOptimize(currentmodel,xy_s);
    vCheck0PP = vCheck0PP+objcon;
elseif isfeasible(xy_root_node,currentmodel)
    vCheck0 = transpose(currentmodel.obj)*xy_root_node + objcon;
    [newPoint,vCheck0PP,timePP] = fixAndOptimize(currentmodel,xy_root_node);
else
    vCheck0 = inf; vCheck0PP = inf; timePP=0;
end      

resultsRootNode.granular = granular;
resultsRootNode.vCheck0 = vCheck0;
resultsRootNode.vCheck0PP = vCheck0PP;
resultsRootNode.time = time;
resultsRootNode.timePP = timePP;

end

