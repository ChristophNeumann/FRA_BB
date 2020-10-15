function onlyInteger = isOnlyInteger(A)
onlyInteger = ~(any((A(:)-round(A(:)))>1E-8));
end
