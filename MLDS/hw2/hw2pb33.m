% problem 3.3
conf = zeros(10,10);
w = zeros(21,10);
nextw = zeros(21,10);
smxbase = zeros(5000,10);
Xtrain(21,:) = 1;
Xtest(21,:) = 1;
itegraph = zeros(1000,1);
like2 = 0;

for ite = 1:1000
	beta = 0;
	smxbase = sum(exp(Xtrain'*w),2); % 5000*1, sum of the value generate by 10 classifiers (each data0)
	for j = 0:9
		xtr = Xtrain(:,label_train==j); % 21*500, for a specific class
		tmp = repmat(exp((xtr')*w(:,j+1))./ smxbase(j*500+1:(j+1)*500), [1 21]); % coefficient
		like = (tmp.*(xtr')); % 500*21
		nextw(:,j+1) = w(:,j+1) + 0.1*(sum(xtr'-like))'/5000; % w(class, t+1) = w(class, t) + n*grad
		
		aloha = log(exp(xtr'*w(:,j+1))./smxbase(j*500+1:(j+1)*500));
		beta = sum(aloha);
	end
	w = nextw;
	itegraph(ite) = beta;
end


r = 1;
for ts = 1:500
	xts = Xtest(:,ts); % 21*1
	plugin = zeros(10,1);
	for j = 1:10
		plugin(j) = exp(xts'*w(:,j))/ sum(exp(xts'*w)); % (1*21)*(21*1) / sum((1*21)*(21*10))
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

