function boolVectFixedVariables = getFixingVector(y, yCheck, originalModel, activeConstraints, k)
B = originalModel.A(:,originalModel.vtype=='I');
B = B(activeConstraints,:);
freedom_matrix = B*diag(y-yCheck) + 1/2*abs(B);
freedom_measure = vecnorm(freedom_matrix,1,1);
[~,index] = maxk(freedom_measure,k);
boolVectFixedVariables = indicesToBooleanVector(index,originalModel);
end