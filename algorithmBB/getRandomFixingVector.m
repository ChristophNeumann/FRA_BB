function boolVectFixedVariables = getRandomFixingVector(yCheck, originalModel, k, randStream)
    m = length(yCheck);    
    sampleSize = min([k,m]);
    index = datasample(randStream,1:m,sampleSize,'Replace',false);
    boolVectFixedVariables = indicesToBooleanVector(index,originalModel);
end