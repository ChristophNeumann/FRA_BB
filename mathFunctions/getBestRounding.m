function [ checkY, time ] = getBestRounding( y1,y2,model,x )
%getBestRounding solves the finite optimization problem for a fixed value
%of t and ambiguous roundings. Here x is the continuous variable and y1 and
%y2 iterations of the post processing. If #J(t)>30, we only test y1 on
%feasiblility.
%Returns nan if no feasible rounding exists
indexInt = find(model.vtype == 'I');
indexCon = find(model.vtype == 'C');
time = 0;
if(sum(y1~=y2)>30)
    disp('not Performing whole linesearch due to too many Swichting points');
    disp('                     ');
    xCandidate = zeros(length(indexCon)+length(indexInt),1);
    if(~isempty(indexCon))
        xCandidate(indexCon) = x; 
        xCandidate(indexInt) = y1;
    else
        xCandidate = y1;
    end
    if isfeasible(xCandidate,model)
        checkY = y1;
    else
        checkY = nan;
    end
else
    if(size(indexCon,1)==0)
        reduction_rhs = 0;
    else
        reduction_rhs = model.A(:,indexCon) * x;
    end
    rhs = model.rhs - reduction_rhs;
    d = model.obj(indexInt);
    B = model.A(:,indexInt);
    clear model;
    model.lb = min(y1,y2);
    model.ub = max(y1,y2);
    model.vtype = 'I';
    model.sense = '<';
    model.obj = d;
    model.A = B;
    model.rhs = rhs;
    clear params;
    params.outputflag = 0;
    resultEx = gurobi(model, params);
    if (strcmp(resultEx.status,'OPTIMAL'))
        checkY = resultEx.x;
    else
        checkY = nan;
    end
    time = resultEx.runtime;
end
end



