function fixedModel = buildFixedModel(originalModel,fixedVariables, xyCheck)
    fixedModel.vtype = originalModel.vtype(~fixedVariables);
    fixedModel.ub = originalModel.ub(~fixedVariables);
    fixedModel.lb = originalModel.lb(~fixedVariables);
    fixedModel.obj = originalModel.obj(~fixedVariables);
    fixedModel.A = originalModel.A(:,~fixedVariables);
    fixedModel.sense = originalModel.sense;
    fixedModel.rhs = originalModel.rhs - originalModel.A(:,fixedVariables)*xyCheck(fixedVariables);  
%    fixedModel.objcon = originalModel.obj(fixedVariables)*xyCheck(fixedVariables);
    fixedModel.varnames = originalModel.varnames(~fixedVariables);
%    fprintf('objective difference is %f \n',fixedModel.objcon);
end