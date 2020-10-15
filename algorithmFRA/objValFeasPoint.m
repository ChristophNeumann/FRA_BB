function [objVal, feasPoint] = objValFeasPoint(reducedPoint, reducedModel, originalModel, modelinfo)
    feasPoint = transformPointRedModel(getRounding(reducedPoint,reducedModel),modelinfo);
    assert(isfeasible(feasPoint, originalModel)==1);
    objVal = originalModel.obj'*feasPoint;
end

