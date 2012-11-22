theta_new' * theta_new
theta_new = theta_new ./ (ones(k,1)*sqrt(sum(theta_new.^2,1)))

[~, I] = sort(O,1,'descend')