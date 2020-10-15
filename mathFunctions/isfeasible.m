function feas = isfeasible(x,model)
%Da nur gerundete Punkte übergeben werden, wird hier nur überprüft, ob der
%Punkt im Polyeder enthalten ist.
intInf = any(abs(x(model.vtype=='I')-round(x(model.vtype=='I')))>+1e-6);
binInf = any(abs(x(model.vtype=='B')-round(x(model.vtype=='B')))>+1e-6);
leqInf = any(model.A(model.sense=='<',:)*x>(model.rhs(model.sense=='<')+1e-6));
geqInf = any(model.A(model.sense=='>',:)*x<(model.rhs(model.sense=='>')-1e-6));
eqInf = ~all(model.A(model.sense=='=',:)*x<=model.rhs(model.sense=='=')+1e-6) || ~all(model.A(model.sense=='=',:)*x>=model.rhs(model.sense=='=')-1e-6); 
boundInf = (any(x>model.ub+1e-6) | any(x<model.lb-1e-6));
if intInf || binInf || leqInf ||geqInf || boundInf || eqInf
    feas = 0;
else
    feas = 1;
end
