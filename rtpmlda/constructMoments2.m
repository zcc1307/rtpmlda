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

f = fopen('classic4_terms.txt');
voc = textscan(f,'%s');
voc = voc{1};

load('classic4_docbyterm.txt');
trainX = spconvert(classic4_docbyterm);
trainX = trainX(3205:7095,:);


%[Docs, Vocs] = size(trainX);
%randsel = randsample(1:Docs,3000,false,[]);
%trainX = trainX(randsel,:);
trainX = trainX(sum(trainX,2)>=3, :);
[Docs, Vocs] = size(trainX);
alpha_0 = 0.1469;
k = 30;
k2 = 50;


V_abs = sum(trainX,2);
mu = zeros(1,Vocs);
for i = 1:Docs
    mu = mu + trainX(i,:) /V_abs(i);
end
mu = mu / Docs;
mu = mu';


%Step1 Find Empirical Averages: construct Pairs Matrix
% If we are going to write down Pairs matrix explicitly

V_abs_corr1 = V_abs.*(V_abs-1);
Pairs = full((((trainX ./ (V_abs_corr1 * ones(1,Vocs)))' * trainX) / Docs) ...
 - (diag(sum(trainX ./ (V_abs_corr1 * ones(1,Vocs)), 1) ) / Docs)...
 - (alpha_0/(alpha_0+1)* (mu * mu')));
V_abs_corr2 = V_abs_corr1.*(V_abs-2);
1

R = normrnd(0, 1, [Vocs k2]);
PR = Pairs*R;

% Else implicitly: seems much slower in testing..(?)
%PR = zeros(Vocs, k2);
%for i = 1:Docs
%    i
%    PR = PR + (trainX(i,:)' * (trainX(i,:) * R) - diag(trainX(i,:)') * R)/(V_abs(i) * (V_abs(i)-1));
% end
% PR = PR / Docs;
% PR = PR - alpha_0 / (alpha_0 + 1) * (mu * (mu' * R));
2

% Step2 Whiten:
[U, S, V] = svd(PR);
U = U(:,1:k);
UPU = U' * Pairs * U;
% UPU = zeros(k,k);
% for i = 1:Docs
%     UPU = UPU + ((U' * trainX(i,:)') * (trainX(i,:) * U) - U' * diag(trainX(i,:)') * U ) / (V_abs(i) * (V_abs(i)-1));
% end
% UPU = UPU / Docs;
% UPU = UPU - alpha_0 / (alpha_0 + 1) * (U' * mu) * (mu' * U);

[U2, T, V2] = svd(UPU);
% Verifying WPW approximately equals I.
W = U * U2 * diag(sqrt(ones(k,1)./diag(T)));
WPW = W' * Pairs * W;


% WPW = zeros(k,k);
% for i = 1:Docs
%     WPW = WPW + ((W' * trainX(i,:)') * (trainX(i,:) * W) - W' * diag(trainX(i,:)') * W ) / (V_abs(i) * (V_abs(i)-1));
% end
% WPW = WPW / Docs;
% WPW = WPW - alpha_0 / (alpha_0 + 1) * (W' * mu) * (mu' * W);



% Step3 SVD
% Step3.1 construct W'Triples(W\theta)W
k = 30;
Triples_theta = zeros(k,k);

theta = normrnd(0,1, [k,1]);
theta = theta / norm(theta);
eta = W*theta;

Wmu = W'*mu;
etamu = eta' * mu;

for l = 1:Docs
        l
        cl = trainX(l,:)';
        Wcl = (W' * cl);
        etacl = eta'*cl;
        WdiagclW = W'*diag(cl)*W;
        WdiagcletaW = W' * diag(cl .* eta) * W;
        Wcleta = W'*(cl .* eta);
        temp1 = etacl * (Wcl * Wcl') + 2 * WdiagcletaW - etacl * WdiagclW - Wcleta * Wcl' - Wcl * Wcleta';
        temp1 = temp1 / (sum(cl) * (sum(cl)-1) * (sum(cl)-2));
        
        temp2 = etamu * (Wcl * Wcl' - WdiagclW) + (Wcl * etacl - Wcleta) * Wmu' + Wmu * (Wcl' * etacl - Wcleta');
        temp2 = -temp2 / (sum(cl) * (sum(cl)-1)) * (alpha_0)/(alpha_0+2);
        
        Triples_theta = Triples_theta + temp1 + temp2;
end
    
Triples_theta = Triples_theta / Docs;

Triples_theta = Triples_theta + alpha_0^2/((alpha_0+1)*(alpha_0+2)) * (eta'*mu)*(W'*mu)*(W'*mu)';


