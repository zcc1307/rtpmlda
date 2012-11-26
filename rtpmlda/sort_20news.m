X = load('20news_train.data');
trainX = spconvert(X);
termfreq = sum(X,1);
[~, I] = sort(termfreq',1,'descend');
X = X(:,I);
trainX = trainX(:,1:5000);