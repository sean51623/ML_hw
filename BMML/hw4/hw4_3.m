% BMML
% hw4_3
% X: 2*250
load('D:\Program Files\Columbia\fall15\BMML\hw4_data.mat');
N = size(X,2);
d = size(X,1);

m = mean(X,2); % mean
c = 0.1;
a = d; % dimension, freedom
A = cov(X'); % cov
B = c*d*A;
alpha = 1; % start cluster

[class_id] = DirichP_GMM(X,m,a,alpha,B);
count = zeros(6,500);
numOfCluster = zeros(1,500);
for i = 1:50
	for j = 1:6
		count(j,i) = length(find(class_id(:,i)==j));
	end
	%
	count(:,i) = sort(count(:,i),'descend');
	numOfCluster(i) = max(class_id(:,i));
end

y = [1:500];
plot(y,count(1,:),y,count(2,:),y,count(3,:),y,count(4,:),y,count(5,:),y,count(6,:))
%plot(y,numOfCluster)
