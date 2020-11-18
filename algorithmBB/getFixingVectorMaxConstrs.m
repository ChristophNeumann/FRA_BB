function boolVectFixedVariables = getFixingVectorMaxConstrs(y, yCheck, originalModel, activeConstraints, k)
B = originalModel.A(:,originalModel.vtype=='I');
B = B(activeConstraints,:);
remainder = y-yCheck;
n = length(remainder);
freedom_matrix = B*spdiags(remainder(:),0,n,n) + 1/2*abs(B);
freedom_measure = vecnorm(freedom_matrix,1,1);
[~,index] = maxk(freedom_measure,k);
boolVectFixedVariables = indicesToBooleanVector(index,originalModel);
end