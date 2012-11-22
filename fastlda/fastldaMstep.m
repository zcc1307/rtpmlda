function [alpha,beta]=fastldaMstep(alpha,phi,gama,X,lap)
%
% Author: Hanhuai Shan. 04/2012
% 
% Description:
%   Variational EM - M step
%
% k = number of classes
% N = number of words in a doc
% V = vocabulary size
% M = number of samples
% 
% Input:
%   alpha:  k*1;
%   phi:    k*M;
%   gama:   k*M;
%   X:      M*V; M docs, each is represented as times of words occurrence
%   lap:    laplacian parameter
%
% Ouptput:
%   alpha:  k*1;
%   beta:   k*V;
%------------------------------------


[k,M]=size(phi);
[M,V]=size(X);

% get beta
for i=1:k
    tempphi=phi(i,:)'*ones(1,V);
    beta(i,:)=sum(tempphi.*X,1);
end
beta=beta+lap;
beta=beta./(sum(beta,2)*ones(1,V));


%get alpha
alpha_t=alpha;
epsilon=0.001;
time=500;

t=0;
e=100;
psiGama=psi(gama);
psiSumGama=psi(sum(gama,1));
while e>epsilon&&t<time
    g=sum((psiGama-ones(k,1)*psiSumGama),2)+M*(psi(sum(alpha_t))-psi(alpha_t));
    h=-M*psi(1,alpha_t);
    z=M*psi(1,sum(alpha_t));
    c=sum(g./h)/(1/z+sum(1./h));
    delta=(g-c)./h;

    eta=1;
    alpha_tt=alpha_t-delta;
    while (length(find(alpha_tt<=0))>0)
        eta=eta/2;
        alpha_tt=alpha_t-eta*delta;
    end
    e=sum(abs(alpha_tt-alpha_t))/sum(alpha_t);
    
    alpha_t=alpha_tt;

    t=t+1;
end
alpha=alpha_t;