Code for Fast Latent Dirichlet Allocation


The folder is for the matlab code for fast latent Dirichlet allocation (Fast LDA) using fast variational inference. The model was proposed in the paper "H. Shan and A. Banerjee. Mixed-membership Naive Bayes Models. DMKD 2010".

The zip file contains the following files:

runFastlda.m:                    An example on how to run the code.
learnFastlda.m:                  Learn Fast LDA from the training set. It calls fastldaEstep.m and fastldaMstep.m.
fastldaEstep.m:                  Variational E-step.
fastldaMstep.m:                  Variational M-step.
applyFastlda.m:                  Apply Fast LDA on the test set.
fastldaGetPerplexity:            Compute the perplexity
data.mat:                        Sample data (word counts).
readme.txt:                      Readme file.

