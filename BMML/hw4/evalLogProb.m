function [lp, md] = evalLogProb(x,mu,covariance)

dim = length(x(:,1));
num_points = length(x(1,:));
[scale,inv_cov] =pcgf(covariance);

y=x-repmat(mu,1,num_points);
md2 = sum(y.*(inv_cov*y),1);
md = (md2).^(.5);
lp = -md2/2 +log(scale);


function [scale,inverse] = pcgf(covariance)

dimension = length(covariance(:,1));
if(rcond(covariance)<eps)
        inverse = pinv(covariance,eps);
        scale = 1/((2*pi)^(dimension/2)*sqrt(det(covariance)));
else
    inverse = inv(covariance);
    scale = 1/((2*pi)^(dimension/2)*sqrt(det(covariance)));
end
