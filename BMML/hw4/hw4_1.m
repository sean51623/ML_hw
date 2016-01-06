%BMML
% X = 2*250

load('hw4_data.mat');

K = 10;
d = size(X,1);
N = size(X,2);

% kmeans initialization
alldat = X'; % 250*2
rp = randperm(250);
initC = alldat(rp(1:K),:); % K*2
nextC = zeros(size(initC,1),d); % K*d
covC = zeros(d,d,K);

[nextCinfo, error] = calculateMinDistance(initC,alldat);
for ite = 1:20
	for ce = 1:K
		temp = alldat(find(nextCinfo==ce),:);
		nextC(ce,:) = mean(temp);
		covC(:,:,ce) = cov(temp);
	end
	[nextCinfo, error] = calculateMinDistance(nextC,alldat);
end

%{
group1 = alldat(find(nextCinfo==1),:);
group2 = alldat(find(nextCinfo==2),:);
scatter(group1(:,1),group1(:,2),'b'), hold on,
scatter(group2(:,1),group2(:,2),'k'), hold on,
title(['k=2'])

%%%
scatter(X1(:,1),X1(:,2),'b'), hold on,
scatter(X2(:,1),X2(:,2),'k')
%}

%%%
% GMM

mu = nextC; % K*2
sigma = covC; % d*d*K
pi = ones(K,1); % K*1
pi = pi/sum(pi);

gamma = zeros(K,250); % k*250
pregamma = zeros(K,250);
likelihood = zeros(100,1);

for ite = 1:100

	% E-step
	for j = 1:K
		rec = mvnpdf(alldat,mu(j,:),sigma(:,:,j)); % mvnpdf(250*2, 1*2, 2*2) => 250*1
		pregamma(j,:) = rec'; % 1*250
	end
	temp = repmat(pi,1,250).*pregamma; % repmat(k*1,1,250) .* (k*250) => k*250
	gamma = temp ./ repmat(sum(temp),K,1); % k*250 ./ repmat(1*250,k,1) => k*250
	
	% M-step
	Nk = sum(gamma,2); % k*1
	mu = gamma*alldat./repmat(Nk,1,2); % (K*250)*(250*2)/(k*2) = k*2
	for j = 1:K
		register = zeros(d,d,250);
		for i = 1:250
			temp = (alldat(i,:)-mu(j,:));
			register(:,:,i) = gamma(j,i)*(temp'*temp);
		end
		sigma(:,:,j) = sum(register,3)/Nk(j); % 2*2
	end
	pi = Nk/N; % k*1
	
	% likelihood
	likelihoodTemp = zeros(250,K); % 250*k
	for j = 1:K
		likelihoodTemp(:,j) = pi(j)*mvnpdf(alldat,mu(j,:),sigma(:,:,j)); % 250*1
	end
	likelihood(ite) = sum(log(sum(likelihoodTemp,2)));
end

% plot
% -- using gamma to assign the clusters
%scatter(X1(:,1),X1(:,2),'b'), hold on,
%scatter(X2(:,1),X2(:,2),'k')

color = [[0 0 1]; [1 1 0]; [0 1 0]; [1 0 1]; [0 1 1]; [1 0 0]; [0 0 0]; [0.25 0.75 0]; [0 0.75 0.25]; [0.5 0.5 0.5]];
recCluster = zeros(1,N);
for i = 1:N
	recCluster(i) = find(gamma(:,i)==max(gamma(:,i)));
end
cluster = cell(K,1);
for j = 1:K
	colorC = alldat(recCluster==j,:);
	scatter(colorC(:,1),colorC(:,2),'MarkerEdgeColor',color(j,:))
	if (j~=K)
		hold on
	end
end
