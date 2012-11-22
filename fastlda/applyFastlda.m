function [mm,perplexity]=applyFastlda(X,alpha,beta)
%
% Author: Hanhuai Shan. 04/2012
% 
% Description:
%   Apply Fast LDA on test set
%
% k = number of classes
% N = number of words in a doc
% V = vocabulary size
% M = number of samples
% 
% Input:
%   alpha:      k*1, parameter of Dirichlet distribution
%   beta:       k*V, paramters for k discrete distributions
%   X:          M*V, test docs. Each doc represented by words' occurence (e.g.[3,0,2..])
%
% Output:
%   mm:         k*M, mixed membership for each doc
%   perplexity: perplexity for X
%----------------------------------------------------------------------
disp(['Fast LDA test...']);

[k,V]=size(beta);
M=size(X,1);

[phi,gama]=fastldaEstep(alpha,beta,X);

[logProb,perplexity]=fastldaGetPerplexity(X,alpha,beta,phi,gama);

% mm is the mixed membership for all test documents
mm=phi;

disp(['Finish test']);