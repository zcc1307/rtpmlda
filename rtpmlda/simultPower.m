% for simultaneously powering k vectors and re-normalize them.
k = 30;
s = 10;
theta = normrnd(0,1,k,s);
theta = theta ./ (ones(k,1) * sqrt(sum(theta.^2,1)));
twonorm = sqrt(sum(theta.^2,1))

for round = 1:20
    eta = W * theta; 
    eta_new = zeros(Vocs,s);
    
    
    for l = 1:Docs
        cl = trainX(l,:)';
        for t = 1:s
            temp1 = cl*(eta(:,t)'*cl)*(eta(:,t)'*cl) + 2*(cl.* cl.* eta(:,t)) - 2*(eta(:,t)'*cl)*(cl .* eta(:,t)) - cl * (cl'*(eta(:,t) .* eta(:,t)));
            temp1 = temp1 / (sum(cl) * (sum(cl)-1) * (sum(cl)-2));

            temp2 = (eta(:,t)' * mu)*((eta(:,t)'* cl)*cl - (cl .* eta(:,t))) + ((eta(:,t)'*cl)*(mu'*cl)*cl - (eta(:,t)'*mu)*(cl .* eta(:,t))) + ((eta(:,t)'*cl)*(eta(:,t)'*cl)*mu - mu * (cl'*(eta(:,t) .* eta(:,t))));
            temp2 = -temp2 / (sum(cl) * (sum(cl)-1)) * (alpha_0)/(alpha_0+2);

            eta_new(:,t) = eta_new(:,t) + temp1 + temp2;
        end
    end
    
    eta_new = eta_new / Docs;
    for t = 1:s
        eta_new(:,t) = eta_new(:,t) + alpha_0^2/((alpha_0+1)*(alpha_0+2)) * (eta(:,t)'*mu)*(eta(:,t)'*mu)*mu;
    end
   
    theta_new = W' * eta_new;
    

    if (round == 20)
        Z = zeros(s,1);
        for t = 1:s
            Z(t) = 2 / ((alpha_0 + 2)*theta(:,t)'*theta_new(:,t));
        end
        break;
    end
    
    %n = norm(theta_new)
    %theta = theta_new / n;
    twonorm = sqrt(sum(theta_new.^2,1))
    [theta, r ] = qr(theta_new);
    theta = theta(:,1:s);
    for t = 1:s
        if r(t,t) < 0
            theta(:,t) = -theta(:,t);
        end
    end
    
end

O = zeros(Vocs,s);
for t = 1:s
    O(:,t) = pinv(W)' * theta(:,t) / Z(t);
end

