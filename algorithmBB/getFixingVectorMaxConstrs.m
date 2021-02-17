function boolVectFixedVariables = getFixingVectorMaxConstrs(y, yCheck, originalModel, activeConstraints, k)
eps = 10^-4;
B = originalModel.A(:,originalModel.vtype=='I');
B = B(activeConstraints,:);
remainder = y-yCheck;
n = length(remainder);
index = zeros(min(k,n),1);
freedom_matrix = (B*spdiags(remainder(:),0,n,n) + 1/2*abs(B))>eps*abs(B);
affected_rows_sum = 0;
for i=1:k
    freedom_measure = sum(freedom_matrix,1);
    [affected_rows,index(i)] = max(freedom_measure);
    if affected_rows >= 1
        affected_rows_sum = affected_rows_sum + affected_rows;
        rows_affected = logical(zeros(size(freedom_matrix,1),1));
        rows_affected(find(freedom_matrix(:,index(i)))) = 1;
        freedom_matrix = freedom_matrix(~rows_affected,:);
    else
        freedom_matrix = B*spdiags(remainder(:),0,n,n) + 1/2*abs(B);
        freedomMeasureRemainingInstances = vecnorm(freedom_matrix,1,1);
        freedomMeasureRemainingInstances(index(1:i-1)) = 0; 
        [values2,index2] = maxk(freedomMeasureRemainingInstances, min(k,n)-sum(index~=0)+1);
        ub_index = min(k,n);
        index(i:ub_index)=index2;
        fprintf('Maximum and Minimum effect of second fixing are %.2f, %.2f\n',full([max(values2),min(values2)]));    
        fprintf('Number of constraints that is added via max freedom is %i of %i \n',[length(index2),k]); 
        break;
    end
end
fprintf('number of affected rows is %i of %i \n',[affected_rows_sum,sum(activeConstraints)]);
boolVectFixedVariables = indicesToBooleanVector(index,originalModel);
end