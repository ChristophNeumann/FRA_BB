clear all;
pathname = '\\ior-kop-psi.ior.kit.edu\data\hg2412\Research\miplib\miplib2010\';
pathname = '\\ior-kop-psi.ior.kit.edu\data\hg2412\Research\miplib\collection\';
addpath(pathname);
testinstances = dir(strcat(pathname,'/*.mps'));
%testinstances = textread('testset2.txt', "%s");
mode = {'MC','RANDOM'};
result = [];
indicator_constrs = [];
for i = 699:length(testinstances)
    fprintf('############################# \n');
    fprintf('Iteration %i\n',i);
    current_name = testinstances(i).name; %testinstances{i}; 
    fprintf('Testing model %s \n', current_name);
    path = strcat(pathname,current_name);%,'.mps'
    currentmodel = gurobi_read(path);
    currentmodel = preProcessModel(currentmodel);
    objcon = 0;
    if isfield(currentmodel,'genconind')
        indicator_constrs = [indicator_constrs,strcat(' ',current_name)];
        fprintf('contains indicator constraints\n');
    end    
    if(~(containsEqualitiesOnInt(currentmodel)) && ~(isfield(currentmodel,'genconind')))
        if isfield(currentmodel,objcon)
           objcon = currentmodel.objcon; 
           fprintf('contains objective offset\n');
        end
        current_result = struct;
        current_result.name = current_name;
        minRLOR = RLOR(currentmodel);
        alpha = minRLOR.objval;
        current_result.granular=(alpha<=0);
        xy_root_node = getRounding(minRLOR.x(1:end-1),currentmodel);
        if current_result.granular
            resultSOR = MinOverT(currentmodel); 
            v_0 = resultSOR.objval;
            xy_s = getRounding(resultSOR.x,currentmodel);
            current_result.vCheck0 = transpose(xy_s)*currentmodel.obj + objcon;
            current_result.vCheck0PP = fixAndOptimize(currentmodel,xy_s) + objcon;
        elseif isfeasible(xy_root_node,currentmodel)
            current_result.vCheck0 = transpose(currentmodel.obj)*xy_root_node + objcon;
            current_result.vCheck0PP = fixAndOptimize(currentmodel,xy_root_node) + objcon;
        else
            current_result.vCheck0 = inf; current_result.vCheck0PP = inf;           
        end      
        for j = 1:2
            current_mode = mode{j};
            indices = []; values = []; point = nan; sumSuffCond = 0; sumSuffCond_OD = 0;
            if ~(current_result.granular)
                [point, indices, values, alpha,sumSuffCond] = feasibilityDiving(currentmodel,current_mode);
            end
            current_result.(strcat(current_mode,'_granular')) = (alpha <=0);  
            current_result.(strcat(current_mode,'_depth')) = length(indices);
            current_result.(strcat(current_mode,+'_objVal')) = inf;
            current_result.(strcat(current_mode,+'_objValPP')) = inf;
            if ~isnan(point)
                current_result.(strcat(current_mode,+'_objVal')) = transpose(currentmodel.obj)*point + objcon;
                current_result.(strcat(current_mode,+'_objValPP')) = fixAndOptimize(currentmodel,point)+ objcon;
            end
            if alpha <= 0
                [xyMinimal, depth, v_check, v_s, sumSuffCond_OD] = optimalityDiving(currentmodel,current_mode, indices, values);
                current_result.(strcat(current_mode,'_objVal')) = v_check + objcon;
                current_result.(strcat(current_mode,+'_objValPP')) = fixAndOptimize(currentmodel,xyMinimal)+ objcon;
            end
            if strcmp(current_mode,'MC')
               current_result.sumSuffCond= sumSuffCond;
               current_result.sumSuffCondOD = sumSuffCond_OD;
            end
        end
        result = [result;current_result];
        assert(current_result.(strcat(current_mode,+'_objValPP'))<=current_result.(strcat(current_mode,'_objVal'))+1E-6);
    end
    save('indicator_constrs','indicator_constrs')
    save(strcat('overall_results2'),'result');
end
%end