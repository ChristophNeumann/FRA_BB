clear all;
pathname = '\\ior-kop-psi.ior.kit.edu\data\hg2412\Research\miplib\collection\';
addpath(pathname);
%testinstances = dir(strcat(pathname,'/*.mps'));
diving_results =  readtable('benchmark_results.xlsx');
testinstances = diving_results.name;
mode = {'MC','RANDOM'};
result = [];
indicator_constrs = [];
for i = 1:length(testinstances)
    fprintf('############################# \n');
    fprintf('Iteration %i\n',i);
    current_name = testinstances{i}; %testinstances{i}; 
    fprintf('Testing model %s \n', current_name);
    path = strcat(pathname,current_name,'.mps');%,'.mps'
    currentmodel = gurobi_read(path);
    current_result = struct;
    current_result.name = current_name;
    for j=1:2
        if j==1
            mode = 'MC_v';
        else
            mode = 'RA_v';
        end
        current_cutoff = diving_results.(mode)(i);
        [time, objval] = runGurobi(currentmodel,current_cutoff);
        current_result.(strcat('time_',mode))= time;
        current_result.(strcat('obj_',mode)) = objval;
    end
    result = [result;current_result];
    save('comp_gurobi','result');
end
%end