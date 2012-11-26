function O = simultPower(moments, input_args)

% for simultaneously powering k vectors and re-normalize them.
k = input_args.k;
trainX = input_args.trainX;
W = moments.W;
mu = moments.mu;
alpha_0 = input_args.alpha_0;
trainX = trainX(sum(trainX,2)>=20, :);
[Docs, Vocs] = size(trainX);

theta = normrnd(0,1,k,k);
theta = theta ./ (ones(k,1) * sqrt(sum(theta.^2,1)));
twonorm = sqrt(sum(theta.^2,1))
totalrounds = 20;


for round = 1:totalrounds
    eta = W * theta; 
    eta_new = zeros(Vocs,k);
    
    
    for l = 1:Docs
        cl = trainX(l,:)';
        for t = 1:k
            temp1 = cl*(eta(:,t)'*cl)*(eta(:,t)'*cl) + 2*(cl.* cl.* eta(:,t)) - 2*(eta(:,t)'*cl)*(cl .* eta(:,t)) - cl * (cl'*(eta(:,t) .* eta(:,t)));
            temp1 = temp1 / (sum(cl) * (sum(cl)-1) * (sum(cl)-2));

            temp2 = (eta(:,t)' * mu)*((eta(:,t)'* cl)*cl - (cl .* eta(:,t))) + ((eta(:,t)'*cl)*(mu'*cl)*cl - (eta(:,t)'*mu)*(cl .* eta(:,t))) + ((eta(:,t)'*cl)*(eta(:,t)'*cl)*mu - mu * (cl'*(eta(:,t) .* eta(:,t))));
            temp2 = -temp2 / (sum(cl) * (sum(cl)-1)) * (alpha_0)/(alpha_0+2);

            eta_new(:,t) = eta_new(:,t) + temp1 + temp2;
        end
    end
    eta_new = eta_new / Docs;
    for t = 1:k
        eta_new(:,t) = eta_new(:,t) + alpha_0^2/((alpha_0+1)*(alpha_0+2)) * (eta(:,t)'*mu)*(eta(:,t)'*mu)*mu;
    end
    %eta_new
    theta_new = W' * eta_new
    

    if (round == totalrounds)
        Z = zeros(k,1);
        for t = 1:k
            Z(t) = 2 / ((alpha_0 + 2)*theta(:,t)'*theta_new(:,t));
        end
        break;
    end
    
    %n = norm(theta_new)
    %theta = theta_new / n;
    twonorm = sqrt(sum(theta_new.^2,1))
    [theta, r ] = qr(theta_new);
    theta = theta(:,1:k);
    for t = 1:k
        if r(t,t) < 0
            theta(:,t) = -theta(:,t);
        end
    end
    
end

O = zeros(Vocs,k);
for t = 1:k
    O(:,t) = pinv(W)' * theta(:,t) / Z(t);
end

end
