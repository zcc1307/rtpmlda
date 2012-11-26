% Step3.2 SVD the W'Triples(W\theta)W
[v ,~ ,~] = svd(Triples_theta);

eta = W * v;
% Step4 Reconstruct and Scale: 
% Step4.1 construct Z:
Z = zeros(1,k);

for l = 1:Docs
    l
    for t = 1:k
        cl = trainX(l,:)';
        clcletaeta = (cl .* cl)' * (eta(:,t) .* eta(:,t));
        cletaeta = cl' * (eta(:,t) .* eta(:,t));
        cleta = cl' * eta(:,t);
        
        temp1 = (eta(:,t)' * cl)^3 + 2*clcletaeta - 3*cleta*cletaeta;
        temp1 = temp1 / (sum(cl) * (sum(cl)-1) * (sum(cl)-2));

        temp2 = 3 * (eta(:,t)' * mu) * (cleta^2 - cletaeta); 
        temp2 = -temp2 / (sum(cl) * (sum(cl)-1)) * (alpha_0)/(alpha_0+2);

        Z(t) = Z(t) + temp1 + temp2;
    end
end

Z = Z / Docs;

for t = 1:k
    Z(t) = Z(t) + alpha_0^2/((alpha_0+1)*(alpha_0+2)) * (eta(:,t)'*mu)^3;
    Z(t) = 2 / ((alpha_0 + 2) * Z(t));
end
% Step4.2 Recover O
O = zeros(Vocs, k);
for t = 1:k
    O(:,t) = pinv(W)' * v(:,t) / Z(t);
end
