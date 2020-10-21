function inflatedPoint = inflateReducedPoint(reducedPoint,fixed_indices, fixed_values)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    lengthNewPoint = length(reducedPoint) + length(fixed_values);
    inflatedPoint = zeros(lengthNewPoint,1);
    unfixed_indices = setdiff(1:lengthNewPoint,fixed_indices);
    inflatedPoint(fixed_indices) = fixed_values;
    inflatedPoint(unfixed_indices) = reducedPoint;
end

