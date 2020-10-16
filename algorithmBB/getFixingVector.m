function boolVectFixedVariables = getFixingVector(y, yCheck, originalModel, activeConstraints)
B = originalModel.A(:,originalModel.vtype=='I');
B = B(activeConstraints,:);
freedom_matrix = B*diag(y-yCheck) + 1/2*abs(B);
freedom_measure = vecnorm(freedom_matrix,1,1);
[~,index] = max(freedom_measure);
boolVectFixedVariables = indicesToBooleanVector(index,originalModel);
end