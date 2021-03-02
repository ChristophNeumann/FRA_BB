function booleanFixingVector = indicesToBooleanVector(indices,originalModel,onlyIntIndices)
%booleanFixingVector takes as input the (integer) indices and translates
%these indices to a boolean mixed-integer vector where the indices come
%from the original model. If onlyIntIndices is set to false, it assumes
%that the index set already corresponds to the mixed-integer variables.
if nargin==2
   onlyIntIndices=true; 
end
booleanFixingVector = logical(zeros(length(originalModel.vtype),1));
if onlyIntIndices
    intIndices = find(originalModel.vtype == 'I');
    fixedIndices = intIndices(indices);
else 
    fixedIndices = indices;
end
booleanFixingVector(fixedIndices) = 1;
end

