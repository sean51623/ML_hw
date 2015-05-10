%% ML hw 1 - 3.1 %%

rec = zeros(1000,1); % for recording
for i = 1:1000

	% split to train / test
	rp = randperm(392);
	Xtrain = X(rp(1:372),:);
	Xtest = X(rp(373:end),:);
	Ytrain = y(rp(1:372),:);
	Ytest = y(rp(373:end),:);
	
	% Analytic form of solving linear regression
	w = inv(Xtrain'*Xtrain)*Xtrain'*Ytrain;
	
	% prediction
	ypred = Xtest*w;
	ydiff = abs(ypred - Ytest);
	rec(i) = sum(ydiff)/20;
end

w
mean(rec)
std(rec)

