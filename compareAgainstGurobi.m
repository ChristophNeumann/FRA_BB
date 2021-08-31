clear all;
pathname = '\\ior-kop-psi.ior.kit.edu\data\hg2412\Research\miplib\collection_original\';
addpath(pathname);
testinstances = dir(strcat(pathname,'/*.mps'));
%testinstances = textread('testset.txt', "%s"); 
mode = {'MC','RANDOM'};
result = [];
indicator_constrs = [];
starting_problem = 5;%751;
for i = starting_problem:length(testinstances)
    fprintf('############################# \n');
    fprintf('Iteration %i\n',i);
    current_name = testinstances(i).name; %testinstances{i}; %
    fprintf('Testing model %s \n', current_name);
    path = strcat(pathname,current_name);%,,'.mps'
    currentmodel = gurobi_read(path);
    currentmodel = preProcessModel(currentmodel);
    objcon = 0;
    if isfield(currentmodel,'genconind')
        indicator_constrs = [indicator_constrs,strcat(' ',current_name)];
        fprintf('contains indicator constraints\n');
    end    
    if(~(containsEqualitiesOnInt(currentmodel)) && ~(isfield(currentmodel,'genconind')))
        currentResult = struct;
        currentResult.name = current_name;
        for j=1:2
            if j==1
                mode = 'MC';
            else
                mode = 'RANDOM';
            end
            [currentResult.granular,currentResult.v0,currentResult.v0PP, ...
                currentResult.t,currentResult.tpp] = rootNodeFRA(currentmodel);
            [node_granular, objective,objectivePP, time,iterF, depthO] = ...
                FRA_diving_heuristic(currentmodel,mode);
            currentResult.(strcat(mode,'granular')) = node_granular;
            currentResult.(strcat(mode,'time')) = time;
            currentResult.(strcat(mode,'obj')) = objective; 
            currentResult.(strcat(mode,'objPP')) = objectivePP; 
            currentResult.(strcat(mode,'iterF')) = iterF; 
            currentResult.(strcat(mode,'depthO')) = depthO; 
            time = 0; objval = inf;
             if objective < inf
                 [time, objval] = runGurobi(currentmodel,objective);
             end
            currentResult.(strcat(mode,'timeGurobi'))= time;
            currentResult.(strcat(mode,'objGurobi')) = objval;
        end
    result = [result;currentResult];
    save(strcat('compResults',num2str(starting_problem)),'result');
    save(strcat('indicator_constrs',num2str(starting_problem)),'indicator_constrs');
    end
end