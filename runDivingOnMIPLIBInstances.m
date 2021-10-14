clear all;
%pathname = '\\ior-kop-psi.ior.kit.edu\data\hg2412\Research\miplib\collection_original\';
prompt = "pathname to folder where MIPLIB instances are located \n";
if ~exist('pathname','var')
    pathname = input(prompt,'s');
end
prompt = "Do you want to run Gurobi as a comparison? Answer {0,1}\n";
COMPARE_AGAINST_GUROBI = input(prompt);
while (COMPARE_AGAINST_GUROBI ~= 0) && (COMPARE_AGAINST_GUROBI~=1)
    prompt = "Valid input must be 0 or 1.\n";
    COMPARE_AGAINST_GUROBI = input(prompt);
end
addpath(pathname);
testinstances = dir(strcat(pathname,'/*.mps'));
%testinstances = textread('testset.txt', "%s"); 
mode = {'MC','RANDOM'};
result = [];
indicator_constrs = [];
starting_problem = 1;
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
        for j=1:length(mode)
            current_mode = mode{j};
            [currentResult.granular,currentResult.v0,currentResult.v0PP, ...
                currentResult.t,currentResult.tpp] = rootNodeFRA(currentmodel);
            results_diving= FRA_diving_heuristic(currentmodel,current_mode);
            currentResult = appendResultsDiving(currentResult,current_mode,results_diving);
            time = 0; objval = inf;
            if COMPARE_AGAINST_GUROBI
                if results_diving.objVal < inf
                 [time, objval] = runGurobi(currentmodel,results_diving.objVal);
                end
                currentResult.(strcat(current_mode,'timeGurobi'))= time;
                currentResult.(strcat(current_mode,'objGurobi')) = objval;
            end
        end
    result = [result;currentResult];
    save(strcat('results/compResults',num2str(starting_problem)),'result');
    save(strcat('results/indicator_constrs',num2str(starting_problem)),'indicator_constrs');
    end
end