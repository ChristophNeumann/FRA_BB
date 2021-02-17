function boolVectFixedVariables = getRandomFixingVector(yCheck, originalModel, k)
    m = length(yCheck);
    sampleSize = min([k,m]);
    index = datasample(1:m,sampleSize,'Replace',false);
    boolVectFixedVariables = indicesToBooleanVector(index,originalModel);
end