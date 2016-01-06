% problem 3.2
mu = zeros(20,10);
cov = zeros(20,20,10);
invcov = zeros(20,20,10);
detcov = zeros(10,1);
conf = zeros(10,10);

for lb = 0:9
	xtr = Xtrain(:,label_train==lb);
	mu(:,lb+1) = mean(xtr,2);
	murep = repmat(mu(:,lb+1),[1 500]);
	cov(:,:,lb+1) = ((xtr-murep)*(xtr-murep)')./500;
	invcov(:,:,lb+1) = inv(cov(:,:,lb+1));
	detcov(lb+1) = det(cov(:,:,lb+1));
end

%{
for t = 0:9
	wer = mean(Xtrain(:,t*500+1:(t+1)*500),2);
	xmean = reshape(Q*wer,28,28);
	subplot(2,5,t+1);
	imagesc(xmean);
end
%}

r=1;
for ts = 1:500
	x = Xtest(:,ts);
	plugin = zeros(10,1);
	for lb = 1:10
		temp = reshape(invcov(:,:,lb),20,20);
		plugin(lb) = (1/sqrt(detcov(lb)))*exp(-0.5*(x-mu(:,lb))'*temp*(x-mu(:,lb)));
	end
	maxidx = find(plugin==max(plugin));
	conf(label_test(ts)+1,maxidx) = conf(label_test(ts)+1,maxidx) + 1;
	%{
	if (label_test(ts)~=maxidx-1)
		xts = reshape(Q*Xtest(1:20,ts),28,28);
		ts
		maxidx-1
		subplot(1,3,r);
		imagesc(xts);
		r=r+1;
		if (r==4) break; end
	end
	%}
end

