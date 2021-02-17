function boolVectFixedVariables = getFixingVectorObjInfluence(y, yCheck, originalModel,k)
    obj_influence = originalModel.obj(originalModel.vtype =='I').*(y-yCheck);
    [influences,indices] = mink(abs(obj_influence),k);
    fprintf('the least influence on the objective value is %.2f \n',influences(end));
    boolVectFixedVariables = indicesToBooleanVector(indices,originalModel);
end