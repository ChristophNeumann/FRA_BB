function objMeasure = objectiveMeasure(originalModel,xy)
    intVars = (originalModel.vtype == 'I');
    posIntVars = (originalModel.obj>0) & intVars;
    negIntVars = (originalModel.obj<0) & intVars;
    objMeasure = zeros(length(intVars),1);
    objMeasure(posIntVars) = -originalModel.obj(posIntVars)*(1-(round(xy(posIntVars)-1)+0.5-xy(posIntVars)));
    objMeasure(negIntVars) = originalModel.obj(negIntVars)*(1-(round(xy(negIntVars)+1)-0.5-xy(negIntVars)));
end
    