function currentResult = appendResultsDiving(currentResult,current_mode,diving_output)
%APPENDRESULTS Summary of this function goes here
%   Detailed explanation goes here
currentResult.(strcat(current_mode,'granular')) = diving_output.node_granular;
currentResult.(strcat(current_mode,'time')) = diving_output.time;
currentResult.(strcat(current_mode,'obj')) = diving_output.objVal; 
currentResult.(strcat(current_mode,'objPP')) = diving_output.objValPP; 
currentResult.(strcat(current_mode,'iterF')) = diving_output.iterF; 
currentResult.(strcat(current_mode,'depth0')) = diving_output.depth0; 
end

