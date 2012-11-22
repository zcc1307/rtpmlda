function [resultAlpha,resultBeta,resultPhi,resultGamma,perplexity_time]=learnFastlda(X,oldAlpha,oldBeta,lap)
%
% Author: Hanhuai Shan. 04/2012
% 
% Description:
%   Learn Fast LDA
%
% k = number of classes
% N = number of words in a doc
% V = vocabulary size
% M = number of samples
% 
% Input:
%   alpha:  k*1;
%   beta:   k*V;
%   lap:    laplacian smoothing parameter
%   X:      M*V; M docs, each is represented as times of words occurrence
%
% Ouptput:
%   resultAlpha:        k*1;
%   resultBeta:         k*V;
%   resultPhi:          k*M;
%   resultGama:         k*M;
%   perplexity_time:    perplexity over all iterations
%---------------------------------------------------


[M,V] = size(X);
[k,V]=size(oldBeta);

alpha_t=oldAlpha;
beta_t=oldBeta;
logProb_t=1;
perplexity_t=1;
phiAll=[];
gammaAll=[];

logProb_time=[];
perplexity_time=[];
e_time=[];
perplexity_peruser=0;

epsilon=0.001;
time=500;

e=100;
t=1;
disp(['Fast LDA training...'])
while e>epsilon && t<time
 
    % E-step 
    [phiAll,gammaAll]=fastldaEstep(alpha_t,beta_t,X);
    
    [logProb_tt,perplexity_tt]=fastldaGetPerplexity(X,alpha_t,beta_t,phiAll,gammaAll);
    logProb_time=[logProb_time,logProb_tt];
    perplexity_time=[perplexity_time,perplexity_tt];
    
    % M-step
    [alpha_tt,beta_tt]=fastldaMstep(alpha_t,phiAll,gammaAll,X,lap);
    
   
     if perplexity_tt==Inf||perplexity_t==Inf
        e=100;
     else
        e=abs(perplexity_tt-perplexity_t)/perplexity_t;
     end
     disp(['t=',int2str(t),' error= ',num2str(e), ' perplexity=',num2str(perplexity_tt)]);
     logProb_t=logProb_tt;
     perplexity_t=perplexity_tt;
 
     alpha_t=alpha_tt;
     beta_t=beta_tt;
        
     t=t+1;
    
end

resultAlpha=alpha_t;
resultBeta=beta_t;
resultPhi=phiAll;
resultGamma=gammaAll;