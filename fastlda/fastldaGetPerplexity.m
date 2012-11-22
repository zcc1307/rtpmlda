function [logProb,perplexity]=fastLdaGetPerplexity(X,alpha,beta,phi,gama)
%
% Author: Hanhuai Shan. 04/2012
% 
% Description:
%   Get perplexity on X
%
% k = number of classes
% N = number of words in a doc
% V = vocabulary size
% M = number of samples
% 
% Input:
%   alpha:  k*1;
%   beta:   k*V;
%   phi:    k*M;
%   gama:   k*M;
%   X:      M*V; M docs, each is represented as times of words occurrence
%
% Ouptput:
%   logProb, perplexity
%---------------------------------------------------

[k,M]=size(phi);
[k,V]=size(beta);
Ns=sum(X,2);

item1=M*gammaln(sum(alpha))-M*sum(gammaln(alpha))+sum((alpha-1).*sum((psi(gama)-psi(ones(k,1)*sum(gama,1))),2));

item2=sum(sum(phi.*(psi(gama)-ones(k,1)*psi(sum(gama,1))),1).*Ns',2);

item4=sum(gammaln(sum(gama,1))-sum(gammaln(gama),1)+sum((gama-1).*(psi(gama)-ones(k,1)*psi(sum(gama,1)))));

item5=sum(sum(phi.*log(phi+realmin),1).*Ns');

item3=0;
for i=1:k
    temp=phi(i,:)'*log(beta(i,:)+realmin).*X;
    item3=item3+sum(sum(temp));
end


logProb=item1+item2+item3-item4-item5;
num=sum(sum(X));
perplexity=exp(-logProb/(num));
