%BMML
%hw4_2
% X = 2*250
load('hw4_data.mat');
N = size(X,2);
d = size(X,1);

%initialize
K = 25;
alpha = 1;
c = 10;
a = d;
A = cov(X'); % 2*2
B = 0.2*A;

nIte = zeros(K,1);
alphaIte = ones(K,1);
sigmaIte = zeros(d,d,K);
meanIte = zeros(K,d);
aIte = zeros(K,1);
BIte = zeros(d,d,K);
phiIte = zeros(N,K);
obj = zeros(100,1);

for j = 1:K
	sigmaIte(:,:,j) = wishrnd(B,a);
	meanIte(j,:) = mvnrnd(zeros(1,d),c*eye(d));
	BIte(:,:,j) = eye(d);
	aIte(j) = K+1;
end

%iteration
for ite = 2:100
	% qci
	for i = 1:N
		tmprecord = zeros(1,K); % N*K
		for j = 1:K
			t1temp = [0.5*aIte(j):-1:0.5*((1-d)+aIte(j))]; % 1*d
			t1 = sum(psi(t1temp));
			t1 = t1 - log(det(BIte(:,:,j)));
			t2temp = X(:,i)'-meanIte(j,:); % (2*1)'-(1*2) => 1*2
			t2 = t2temp*(aIte(j)*inv(BIte(:,:,j)))*t2temp'; % (1*2)*(2*2)*(2*1) = 1*1
			t3 = trace(aIte(j)*inv(BIte(:,:,j))*sigmaIte(:,:,j)); % trace((1*1)*(2*2)*(2*2))
			t4 = psi(alphaIte(j))-psi(sum(alphaIte));
			tmprecord(j) = exp(0.5*t1-0.5*t2-0.5*t3+t4);
		end
		phiIte(i,:) = tmprecord/sum(tmprecord);
	end
	
	for j = 1:K
		nIte(j) = sum(phiIte(:,j)); % k*1
		alphaIte(j) = alpha+nIte(j); % k*1
		% inv((1*1)*(d*d) + (1*1)*(1*1)*inv(d*d)) => d*d
		sigmaIte(:,:,j) = inv((1/c)*eye(d)+nIte(j)*aIte(j)*inv(BIte(:,:,j)));
		% ((d*d)*((1*1)*(d*d)*sum(repmat(1*n,d,1).*(d*n))))' => 1*d
		meanIte(j,:) = (sigmaIte(:,:,j)*(aIte(j)*inv(BIte(:,:,j))*sum(repmat(phiIte(:,j)',d,1).*X,2)))';
		aIte(j) = a+nIte(j);
		%
		btemp = zeros(d,d,N);
		for i = 1:N
			% ((2*1)+(2*1))((2*1)-(2*1))' => 2*1
			% (1*1)*((2*1)*(1*2)+(2*2)) => 2*2
			btemp(:,:,i) = phiIte(i,j)*((X(:,i)+meanIte(j,:)')*((X(:,i)-meanIte(j,:)')')+sigmaIte(:,:,j));
		end
		BIte(:,:,j) = B + sum(btemp,3);
	end
	
	recCluster = zeros(1,N);
	for i = 1:N
		recCluster(i) = find(phiIte(i,:)==max(phiIte(i,:)));
	end
	
	%{
	% objective function
	% part1, part2
	part1 = 0;
	part2 = 0;
	for j = 1:K
		clusterj = X(:,recCluster==j);
		for i = 1:size(clusterj,2)
			meanDiff = (clusterj(:,i)'-meanIte(j,:));
			part1 = part1-0.5*meanDiff*inv(sigmaIte(:,:,j))*meanDiff';
		end
	end
	
	% part3
	% part4
	% part5
	% part6
	% part7
	% part8
	% part9
	
	obj(ite) = part1+part2+part3+part4+part5;
	%}
end


color = [[0 0 1]; [1 1 0]; [0 1 0]; [1 0 1]; [0 1 1]; [1 0 0]; [0 0 0]; [0.25 0.75 0]; [0 0.75 0.25]; [0.5 0.5 0.5];...
[0.5 0.3 1]; [1 0.75 0]; [0.8 0.7 0.2]; [0.2 0.7 1]; [0.3 0.3 0.5]; [0.6 0.1 0.9]; [0.1 0.3 0.8]; [0.9 0.4 0.2]; [0.67 0.5 0.6]; [0.7 0.2 0.4];...
[0.8 0.9 0.7]; [0.5 0.6 0.9]; [0.75 0.3 0.4]; [0.2 0.6 1]; [0.2 0.9 0.1];];
alldat = X';


recCluster = zeros(1,N);
for i = 1:N
	recCluster(i) = find(phiIte(i,:)==max(phiIte(i,:)));
end
cluster = cell(K,1);
for j = 1:K
	colorC = alldat(recCluster==j,:);
	if (j>10)
		scatter(colorC(:,1),colorC(:,2),'MarkerEdgeColor',rand(1,3));%color(j,:)
	else 
		scatter(colorC(:,1),colorC(:,2),'MarkerEdgeColor',color(j,:));
	end
	
	if (j~=K)
		hold on
	end
end

aaa = zeros(max(recCluster),1);
for i = 1:max(recCluster)
	aaa(i) = length(find(recCluster==i));
end

