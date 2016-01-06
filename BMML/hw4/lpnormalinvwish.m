function lp = lpnormalinvwish(mu,sigma,mu_0,k_0,v_0,lambda_0)
lp = evalLogProb(mu,mu_0,sigma);
k = size(mu_0,1);
lp = lp -(v_0*k/2*log(2) + k*(k-1)/4*log(pi) + sum(gammaln((v_0+1-1:k)/2)))+v_0/2*log(det(lambda_0))-(v_0+k+1)/2*det(sigma)-1/2*trace(lambda_0*inv(sigma));
