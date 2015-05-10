%% ML hw 1 - 3.2 %%

rec = zeros(20,1000,4);

for p = 1:4
	for i = 1:1000
		xnew = polycate(X,p);
		
		% split to train / test
		rp = randperm(392);
		Xtrain = xnew(rp(1:372),:);
		Xtest = xnew(rp(373:end),:);
		Ytrain = y(rp(1:372),:);
		Ytest = y(rp(373:end),:);
		
		% Analytic form of solving linear regression
		w = inv(Xtrain'*Xtrain)*Xtrain'*Ytrain;
		
		ypred = Xtest*w;
		rec(:,i,p) = Ytest - ypred;
	end
end	

sqr = rec.*rec;
mn = sum(sqr,1)/20;
rt = sqrt(mn);
RMSE = squeeze(rt);

statis = zeros(4,2);  % record mean, std of RMSE
gausParam = zeros(4,2); % record mean and var of original error
loglike = zeros(4,1);  % record log likelihood

for p = 1:4
	statis(p,1) = mean(RMSE(:,p));
	statis(p,2) = std(RMSE(:,p));
	tmp = reshape(rec(:,:,p),1,20000);
	subplot(2,2,p), hist(tmp,100), title(['p=' num2str(p)]);
	mu = mean(tmp); sigma = std(tmp);
	gausParam(p,1) = mu; gausParam(p,2) = sigma;
	prob = normpdf(tmp, mu, sigma); % calculate the probability of generating data under given Gaussian distribution
	loglike(p) = sum(log(prob)); % sum them up to get log-likelihood
end

