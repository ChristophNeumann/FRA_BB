function boolVectFixedVariables = getRandomFixingVector(yCheck, originalModel, k, randStream)
    sampleSize = min([k,m]);
    index = datasample(randStream,1:m,sampleSize,'Replace',false);
    boolVectFixedVariables = indicesToBooleanVector(index,originalModel);
end