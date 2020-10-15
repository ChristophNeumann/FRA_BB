clear all;
pathname = '\\ior-kop-psi.ior.kit.edu\data\hg2412\Research\miplib\miplib2010\';
pathname2 = '\\ior-kop-psi.ior.kit.edu\data\hg2412\Research\miplib\collection\';
addpath(pathname);
addpath(pathname2);
modelname = '30_70_4.5_0.95_100.mps';
%nameOfTextFileWithTestInstances = 'only2010.txt';
%testinstances = textread(nameOfTextFileWithTestInstances, "%s"); 
current_result = struct;
path1 = strcat(pathname,modelname);%,'.mps'
path2 = strcat(pathname2,modelname);%,'.mps'
if isfile(path1)
    currentmodel = gurobi_read(path1);
elseif isfile(path2)
    currentmodel = gurobi_read(strcat(path2));
end
fprintf('model %s \n', modelname);
    if~(containsEqualitiesOnInt(currentmodel))
        current_result.name = modelname;
        result_min_T = MinOverT(currentmodel);
        fprintf('Model is %s \n', result_min_T.status);
        if strcmp(result_min_T.status,'OPTIMAL')
            fprintf('Success with problem %s \n',modelname);
            current_result.ips_nonempty = true;
            current_result.obj_val_ips = result_min_T.objval;
        else
           current_result.ips_nonempty = false;
           fprintf('No success with problem %s \n',modelname);
        end   
            current_result.time_ips = result_min_T.runtime;
    end