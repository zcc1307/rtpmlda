function O = defltensorPower(moments, input_args)

k = input_args.k;
trainX = input_args.trainX;
W = moments.W;
mu = moments.mu;
alpha_0 = input_args.alpha_0;
trainX = trainX(sum(trainX,2)>=20, :);
[Docs, Vocs] = size(trainX);


L = 5;
N = 10;
n_deflated = 0;
v_deflated = zeros(k,k);
lambda_deflated = zeros(1,k);

for t = 1:k
    theta_max = [];
    lambda_max = 0;
    for trials = 1:L
        theta = normrnd(0,1, [k,1]);
        theta = theta / norm(theta);
        for iter = 1:N
            eta = W * theta;

            eta_new = zeros(Vocs,1);
            temp1 = zeros(Vocs,1);
            temp2 = zeros(Vocs,2);


            for l = 1:Docs
                cl = trainX(l,:)';

                temp1 = cl*(eta'*cl)*(eta'*cl) + 2*(cl.* cl.* eta) - 2*(eta'*cl)*(cl .* eta) - cl * (cl'*(eta .* eta));
                temp1 = temp1 / (sum(cl) * (sum(cl)-1) * (sum(cl)-2));

                temp2 = (eta' * mu)*((eta'* cl)*cl - (cl .* eta)) + ((eta'*cl)*(mu'*cl)*cl - (eta'*mu)*(cl .* eta)) + ((eta'*cl)*(eta'*cl)*mu - mu * (cl'*(eta .* eta)));
                temp2 = -temp2 / (sum(cl) * (sum(cl)-1)) * (alpha_0)/(alpha_0+2);

                eta_new = eta_new + temp1 + temp2;
            end

            eta_new = eta_new / Docs;

            eta_new = eta_new + alpha_0^2/((alpha_0+1)*(alpha_0+2)) * (eta'*mu)*(eta'*mu)*mu;
            theta_new = W' * eta_new;
            for defl = 1:n_deflated
                theta_new = theta_new - lambda_deflated(defl) * (theta'* v_deflated(:,defl)) * (theta'* v_deflated(:,defl)) * v_deflated(:,defl);
            end
            
            n = norm(theta_new)
            theta = theta_new / n;
            theta'
        end
        
        if (n > lambda_max)
            lambda_max = n;
            theta_max = theta;
        end
    end
    
    lambda_max
    theta_max'
    n_deflated = n_deflated + 1;
    lambda_deflated(:,n_deflated) = lambda_max;
    v_deflated(:,n_deflated) = theta_max;
end

O = zeros(Vocs,k);
for t = 1:k
    O(:,t) = pinv(W)' * v_deflated(:,t);
end

end