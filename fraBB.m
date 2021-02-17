clear all;
pathname = '\\ior-kop-psi.ior.kit.edu\data\hg2412\Research\miplib\miplib2010\';
pathname2 = '\\ior-kop-psi.ior.kit.edu\data\hg2412\Research\miplib\collection\';
addpath(pathname);
addpath(pathname2);
testinstances = dir(strcat(pathname,'/*.mps'));
testinstances = textread('testset.txt', "%s"); 
mode = {'MC','NN'};
%for j = 1:2
%    current_mode = mode{j};
    current_mode = 'MC';
    result = [];
    for i = 1:length(testinstances)
        fprintf('iteration %i\n',i);
        current_name = testinstances{i}; %testinstances(i).name;% 
        path1 = strcat(pathname,current_name);%,'.mps'
        path2 = strcat(pathname2,current_name);%,'.mps'
        if isfile(path1)
            currentmodel = gurobi_read(path1);
        elseif isfile(path2)
            currentmodel = gurobi_read(strcat(path2));
        end
        fprintf('model %s \n', current_name);
        currentmodel = preProcessModel(currentmodel);
        if~(containsEqualitiesOnInt(currentmodel))
            current_result = struct;
            current_result.name = current_name;
            current_result.successful = false;
            [point, indices,values, alpha] = feasibilityDiving(currentmodel,current_mode);
            fprintf('number of iterations %i\n',length(indices));
            if ~isnan(point)
             current_result.successful = true;
            end
            current_result.depth = length(indices);
            current_result.alpha = alpha;
        result = [result;current_result];
        end
    end
    save(strcat(current_mode,'results'),'result');
%end