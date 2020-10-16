function booleanFixingVector = indicesToBooleanVector(indices,originalModel)
%booleanFixingVector takes as input the integer indices and translates
%these indices to a boolean mixed-integer vector where the indices come
%from the original model.
booleanFixingVector = logical(zeros(length(originalModel.vtype),1));
intIndices = find(originalModel.vtype == 'I');
fixedIndices = intIndices(indices);
booleanFixingVector(fixedIndices) = 1;
end

