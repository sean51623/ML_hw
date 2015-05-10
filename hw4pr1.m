% hw4.1

mu1 = [0 0];
sigma1 = [1 0 ; 0 1];

mu2 = [3 0];
sigma2 = [1 0 ; 0 1];

mu3 = [0 3];
sigma3 = [1 0 ; 0 1];

p = [0.2 0.5 0.3];

sampleG = sampleDiscrete(500,p);
g1 = mvnrnd(mu1,sigma1,length(sampleG(sampleG==1)));
g2 = mvnrnd(mu2,sigma2,length(sampleG(sampleG==2)));
g3 = mvnrnd(mu3,sigma3,length(sampleG(sampleG==3)));

alldat = [g1;g2;g3]; % 500*2
errorRec = zeros(21,4);

for k = 2:5
	rp = randperm(500);
	initC = alldat(rp(1:k),:);
	nextC = zeros(size(initC,1),2);
	
	[nextCinfo, error] = calculateMinDistance(initC,alldat);
	errorRec(1,k-1) = sum(error);
	for ite = 1:20
		for ce = 1:k
			temp = alldat(find(nextCinfo==ce),:);
			nextC(ce,:) = mean(temp);
		end
		[nextCinfo, error] = calculateMinDistance(nextC,alldat);
		errorRec(ite+1,k-1) = sum(error);
	end
	
	if (k==3)
		group1 = alldat(find(nextCinfo==1),:);
		group2 = alldat(find(nextCinfo==2),:);
		group3 = alldat(find(nextCinfo==3),:);
	
		subplot(1,2,1),
		scatter(group1(:,1),group1(:,2),'b'), hold on,
		scatter(group2(:,1),group2(:,2),'k'), hold on,
		scatter(group3(:,1),group3(:,2),'m'),
		title(['k=3'])
	end
	
	
	if (k==5)
		group1 = alldat(find(nextCinfo==1),:);
		group2 = alldat(find(nextCinfo==2),:);
		group3 = alldat(find(nextCinfo==3),:);
		group4 = alldat(find(nextCinfo==4),:);
		group5 = alldat(find(nextCinfo==5),:);
		
		subplot(1,2,2),
		scatter(group1(:,1),group1(:,2),'b'), hold on,
		scatter(group2(:,1),group2(:,2),'c'), hold on,
		scatter(group3(:,1),group3(:,2),'g'), hold on,
		scatter(group4(:,1),group4(:,2),'k'), hold on,
		scatter(group5(:,1),group5(:,2),'m'),
		title(['k=5'])
	end
	
end

subplot(2,2,1), plot(errorRec(:,1)), title(['k=2']);
subplot(2,2,2), plot(errorRec(:,2)), title(['k=3']);
subplot(2,2,3), plot(errorRec(:,3)), title(['k=4']);
subplot(2,2,4), plot(errorRec(:,4)), title(['k=5']);

