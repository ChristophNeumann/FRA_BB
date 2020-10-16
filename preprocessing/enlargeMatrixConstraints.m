function [ enlargedModel ] = enlargeMatrixConstraints( model )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
epsRound = 10^-8;
epsEnlargement = 10^-4;
%assert(sum(model.vtype=='I')+sum(model.vtype=='C') == length(model.obj));
enlargedModel = model;
A = model.A(:,model.vtype=='C');
B = model.A(:,model.vtype=='I');

%Due to memory reasons, the integegrality of B has to be tested separately
%rows with nonzero elements of B-floor(B) cannot be relaxed
I_enlarged = ~any(A,2) & ~any(abs(B-round(B))>epsRound,2)& ...
             ~isinf(enlargedModel.rhs);
B_l = round(B(I_enlarged,:));
enlargedModel.A(I_enlarged,model.vtype=='I') = B_l;
%[I,~] = find(B_l-floor(spfun(@(x) x+eps,B_l))>eps);
%[I,~] = find(any(B-floor(spfun(@(x) x+eps,B))~=0,2) & ~any(A,2),2);
%fprintf('Number of non integral rows in B_l: %i \n', length(I));
%fprintf('Number of constraints that may be relaxed: %i \n', sum(full(I_enlarged)));
k = ones(sum(I_enlarged),1);
i=1;
tic;
while toc < 20 && i <= size(B_l,1)
        beta_i = B_l(i,:);
        k(i) = gcd_vec(beta_i(beta_i~=0));    
        i = i+1;
end
if toc >=20 
    fprintf('Could not enlarge problem fully');
end
%fprintf('maximum enlargement: %i \n',max(k))
enlargedModel.rhs(I_enlarged) = model.rhs(I_enlarged)...
                               - mod(model.rhs(I_enlarged),k) + k - epsEnlargement;
end

