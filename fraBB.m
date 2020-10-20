clear all;
pathname = '\\ior-kop-psi.ior.kit.edu\data\hg2412\Research\miplib\miplib2010\';
pathname2 = '\\ior-kop-psi.ior.kit.edu\data\hg2412\Research\miplib\collection\';
addpath(pathname);
addpath(pathname2);
nameOfTextFileWithTestInstances = 'only2010.txt';
testinstances = textread(nameOfTextFileWithTestInstances, "%s"); 
current_result = struct;
result = [];
for i = 1:length(testinstances) 
    fprintf('iteration %i\n',i);
    current_name = testinstances{i};%testinstances(i).name;% 
    path1 = strcat(pathname,current_name);%,'.mps'
    path2 = strcat(pathname2,current_name);%,'.mps'
    if isfile(path1)
        currentmodel = gurobi_read(path1);
    elseif isfile(path2)
        currentmodel = gurobi_read(strcat(path2));
    end
    fprintf('model %s \n', current_name);
    if~(containsEqualitiesOnInt(currentmodel))
        current_result.name = current_name;
        [point, indices,values] = feasibilityDiving(currentmodel);
        fprintf('number of iterations %i',length(indicies));
    end
end