function inflatedPoint = inflateReducedPoint(reducedPoint,fixed_indices, fixed_values)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    lengthNewPoint = length(reducedPoint) + length(fixed_values);
	fixed_indices_logical = logical(zeros(lengthNewPoint,1));
    fixed_indices_logical(fixed_indices)=1;
    inflatedPoint = zeros(lengthNewPoint,1);
    inflatedPoint(fixed_indices_logical) = fixed_values;
    inflatedPoint(~fixed_indices_logical) = reducedPoint;
end

