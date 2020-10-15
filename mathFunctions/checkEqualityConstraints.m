%Returns a vector of Instances for which the FRA is applicable
pathname = 'Z:\hg2412\Research\miplib2003';
pathname = strcat(pathname,'/');
testinstances = dir(strcat(pathname,'*.mps'));
containsNoEqConstraints = zeros(length(testinstances),1);
for i= 1:length(testinstances)
    currentmodel = gurobi_read(strcat(pathname,testinstances(i).name));
    [~,vEq] = find(currentmodel.A(currentmodel.sense=='=',:));
    if(all(currentmodel.vtype(vEq)=='C'))
        fprintf('Currently testing Problem %d for feasibility \n',i);
        containsNoEqConstraints(i) = 1;       
    end
end
sum(containsNoEqConstraints)