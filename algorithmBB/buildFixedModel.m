function fixedModel = buildFixedModel(originalModel,fixedVariables, xyCheck)
    fixedModel.vtype = originalModel.vtype(~fixedVariables);
    fixedModel.ub = originalModel.ub(~fixedVariables);
    fixedModel.lb = originalModel.lb(~fixedVariables);
    fixedModel.obj = originalModel.obj(~fixedVariables);
    fixedModel.A = originalModel.A(:,~fixedVariables);
    fixedModel.sense = originalModel.sense(~fixedVariables);
    fixedModel.rhs = originalModel.rhs - originalModel.A(:,fixedVariables)*xyCheck(fixedVariables);    
end