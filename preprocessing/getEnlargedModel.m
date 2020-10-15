function [ enlargedModel ] = getEnlargedModel( model )
%GETENLARGEDINNERPARALLELSET Summary of this function goes here
%   Detailed explanation goes here
preProcessedModel = preProcessModel(model);
enlargedModel = enlargeMatrixConstraints(preProcessedModel);
[lbEnlarged,ubEnlarged] = enlargeBoxRestrictions(...
                          model.lb(model.vtype=='I'), model.ub(model.vtype=='I'));
enlargedModel.lb(model.vtype=='I') = lbEnlarged;
enlargedModel.ub(model.vtype=='I') = ubEnlarged;
end

