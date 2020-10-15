function v = getObjectiveValue(x,y)
P = model.obj;
n = size(P,1);
indexInt = find(model.vtype == 'I');
indexCon = find(model.vtype =='C');
xi = xT(indexCon)-xRel(indexCon);
eta = xT(indexInt) - xRel(indexInt);