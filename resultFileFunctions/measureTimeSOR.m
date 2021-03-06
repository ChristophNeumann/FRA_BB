clear all;
pathname = '\\ior-kop-psi.ior.kit.edu\data\hg2412\Research\miplib\collection\';
addpath(pathname);
%testinstances = dir(strcat(pathname,'/*.mps'));
gurobiResults =  load('comp_gurobi.mat');
gurobiResults = gurobiResults.result;
time = transpose([gurobiResults.time_RA_v;gurobiResults.time_MC_v]);
interestingIndices = find(any(time>10,2));
mode = {'MC','RANDOM'};
result = [];
indicator_constrs = [];
for i = 2:length(interestingIndices)
    fprintf('############################# \n');
    fprintf('Iteration %i\n',i);
    current_name = gurobiResults(interestingIndices(i)).name; %testinstances{i}; 
    fprintf('Testing model %s \n', current_name);
    path = strcat(pathname,current_name,'.mps');%,'.mps'
    currentmodel = gurobi_read(path);
    current_result = struct;
    current_result.name = current_name;
    for j=1:2
        if j==1
            mode = 'MC';
        else
            mode = 'RANDOM';
        end
        [objective,time] = FRA_diving_heuristic(currentmodel,mode);
        current_result.(strcat(mode,'obj')) = objective; 
        current_result.(strcat(mode,'time')) = time;
    end
    result = [result;current_result];
    save('compTimeSOR','result');
end
%end