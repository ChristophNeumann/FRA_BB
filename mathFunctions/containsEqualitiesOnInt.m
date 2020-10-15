function result = containsEqualitiesOnInt( model )
%CONTAINSEQUALITIESONINT Summary of this function goes here
%   Detailed explanation goes here
q_rows = find(model.sense == '=');
indInt = find(model.vtype=='I');
D = model.A(q_rows,indInt);
result = ~isempty(D) & ~isempty(find(D));
end

