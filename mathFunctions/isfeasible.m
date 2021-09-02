function feas = isfeasible(x,model)
%Überprüft, ob Punkt die Restirkionen von model erfüllt
FEAS_TOL = 1e-6;
intInf = any(abs(x(model.vtype=='I')-round(x(model.vtype=='I')))>+FEAS_TOL);
binInf = any(abs(x(model.vtype=='B')-round(x(model.vtype=='B')))>+FEAS_TOL);
leqInf = any(model.A(model.sense=='<',:)*x>(model.rhs(model.sense=='<')+FEAS_TOL));
geqInf = any(model.A(model.sense=='>',:)*x<(model.rhs(model.sense=='>')-FEAS_TOL));
eqInf = ~all(model.A(model.sense=='=',:)*x<=model.rhs(model.sense=='=')+FEAS_TOL) || ~all(model.A(model.sense=='=',:)*x>=model.rhs(model.sense=='=')-FEAS_TOL); 
boundInf = (any(x>model.ub+FEAS_TOL) | any(x<model.lb-FEAS_TOL));
if intInf || binInf || leqInf ||geqInf || boundInf || eqInf
    feas = false;
else
    feas = true;
end
