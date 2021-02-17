clear all;
pathname = '\\ior-kop-psi.ior.kit.edu\data\hg2412\Research\miplib\miplib2010\';
pathname2 = '\\ior-kop-psi.ior.kit.edu\data\hg2412\Research\miplib\testbedGranularPresolved\';
addpath(pathname);
addpath(pathname2);
testinstances = dir(strcat(pathname2,'/*.mps'));
%testinstances = textread('testset.txt', "%s"); 
mode = {'default','MC','RANDOM','MR'};
for j = 2:4
    current_mode = mode{j};
%    current_mode = 'MC';
    result = [];
    for i = 1:length(testinstances)
        fprintf('iteration %i\n',i);
        current_name = testinstances(i).name; % testinstances{i}; % 
        path1 = strcat(pathname,current_name);%,'.mps'
        path2 = strcat(pathname2,current_name);%,'.mps'
 %       if isfile(path1)
 %           currentmodel = gurobi_read(path1);
  %      elseif isfile(path2)
        currentmodel = gurobi_read(strcat(path2));
 %       end
        fprintf('model %s \n', current_name);
        currentmodel = preProcessModel(currentmodel);
        if~(containsEqualitiesOnInt(currentmodel))
            current_result = struct;
            current_result.name = current_name;
            
            resultSOR = MinOverT(currentmodel); 
            v_0 = resultSOR.objval;
            xy_s = getRounding(resultSOR.x,currentmodel);
            v_check_0 = transpose(xy_s)*currentmodel.obj;        
            [xyMinimal, depth, v_check, v_s] = optimalityDiving(currentmodel,current_mode);
            current_result.depth = depth;
            current_result.obj_diving = v_check;
            current_result.obj_0 = v_check_0;
            current_result.obj_diving_pr = v_s;
            current_result.obj_0_pr = v_0;
        result = [result;current_result];
        save(strcat(current_mode,'results_obj'),'result');
        end
    end
end