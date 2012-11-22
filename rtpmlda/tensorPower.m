k = 30;
theta = normrnd(0,1, [k,1]);
theta = theta / norm(theta);

while true
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
    n = norm(theta_new)
    theta = theta_new / n;
    theta'
end