% problem 3.1
conf = zeros(10,10,5);
idx = 1;

for ts = 1:500
	xte = Xtest(:,ts);
	xterp = repmat(xte,[1 5000]);
	diff = Xtrain - xterp;
	diff = sum(diff.*diff);
		
	[dist, order] = sort(diff);
	knn = label_train(order(1:5));
	for k = 1:5
		countMax = mode(knn(1:k));
		conf(label_test(ts)+1,countMax+1,k) = conf(label_test(ts)+1,countMax+1,k)+1;
	end
end

%{
y = zeros(5,1)
for x = 1:5
	a = conf(:,:,x);
	a = reshape(a,10,10);
	y(x) = trace(a)/500;
end

misclassify = zeros(2,300);
		if (label_test(ts)~= countMax)
			misclassify(1,idx) = ts;
			misclassify(2,idx) = countMax;
			idx = idx + 1;
		end
		
ax(1,1:3) = [11 20 457];
ax(2,1:3) = [194 206 261];
ax(3,1:3) = [155 166 323];

for q = 1:3
	tq = reshape(Q*Xtest(:,ax(2,q)),28,28);
	subplot(1,3,q);
	imagesc(tq);
end
&}