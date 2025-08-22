function [D]=distance3(X,Y)

D=abs(sqrt(bsxfun(@plus,bsxfun(@plus,sum(Y.*Y,2)',sum(X.*X,2)),-2*X*Y')));

