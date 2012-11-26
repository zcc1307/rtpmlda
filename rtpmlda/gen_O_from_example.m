% random sample document from the corpus:
%-------------------------
%if we deal with data.mat:
%load('data.mat')
%-------------------------

%-------------------------
%if we deal with 20 newsgroups dataset:
% load train.data
% trainX_ = spconvert(train);
% [Docs, ~] = size(trainX_);
% trainX_ = trainX_(:,1:5000);
% randsel = randsample(1:Docs,5000,false,[]);
% trainX = trainX_(randsel,:);
% trainX = trainX(sum(trainX,2)>=3, :);
%-------------------------

%f = fopen('classic4_terms.txt');
% voc = textscan(f,'%s');
% voc = voc{1};
% fclose(f);
load('20news_stemmed/20news_voc_mini.mat');

%load('classic4_docbyterm.txt');
%trainX = spconvert(classic4_docbyterm);
load('20news_stemmed/20news_mini.mat');
trainX = spconvert(X);
trainX = trainX(:,1:5000);


%trainX = trainX(3205:7095,:);
[Docs, Vocs] = size(trainX);
%randsel = randsample(1:Docs,3000,false,[]);
%alpha_0 = 0.1469;
alpha_0 = 0;


trials = 10;
shuffled = randsample(1:Docs,Docs,false);
wordcount = zeros(1,trials);
doccount = [10 20 40 80 160 320 640 1280 2560 5120];
topic_O = zeros(5000,20,trials);

for T = 1:10
    randsel = shuffled(1:doccount(T));
    input_args = [];
    input_args.trainX = trainX(randsel,:);
    input_args.alpha_0 = alpha_0;
    input_args.k = 20;
    input_args.k2 = 30;
    input_args.voc = voc;
    wordcount(:,T) = sum(sum(input_args.trainX));
    moments = constructMoments(input_args);
    %tempO = simultPower(moments,input_args);
    tempO = defltensorPower(moments, input_args);
    topic_O(:,:,T) = tempO;
end