
% Author: Hanhuai Shan. 04/2012
 
% Rows are documents, columns are the words, the data is a word count
% matrix
load data

% number of clusters
k=30;
[N,M]=size(trainX);

% initialization
alpha=rand(k,1);
beta=rand(k,M);
beta=beta./(sum(beta,2)*ones(1,M));
lap=0.0001;


% Fast LDA on training set
[resultAlpha,resultBeta,resultPhi,resultGamma,perplexity_time]=learnFastlda(trainX,alpha,beta,lap);
mm_train=resultPhi;  % resultPhi gives the membership for training docs.

% If there is a test set, run Fast LDA on test set
[mm_test,perplexity]=applyFastlda(testX,resultAlpha,resultBeta);