% hw4pr2 p2

load('hw4exp2.mat');
load('movies_matlab/movie_ratings.mat');

subplot(1,2,1), plot(error), title(['RMSE']);
subplot(1,2,2), plot(logli), title(['Log likelihood']);

selected_mv = [1101, 1106, 1121];
closest = zeros(3,6);
mvname = cell(3,6);
dist = zeros(3,6);


for i = 1:3
	mv = movied(selected_mv(i),:); % 1*20
	repmv = repmat(mv,[1682 1]); % 1682*20
	substract = movied-repmv;
	euc = sqrt(sum(substract.^2,2));
	[y idx] = sort(euc);
	closest(i,:) = idx(1:6);
	dist(i,:) = y(1:6);
	mvname(i,:) = movie_names(idx(1:6));
end


errorRec = zeros(21);

rp = randperm(943);
initC = userd(rp(1:30),:);
nextC = zeros(size(initC,1),20);
[nextCinfo, error] = calculateMinDistance(initC,userd);
errorRec(1) = sum(error);

k = 30;
for ite = 1:20
	for ce = 1:k
		temp = userd(find(nextCinfo==ce),:);
		nextC(ce,:) = mean(temp);
	end
	[nextCinfo, error] = calculateMinDistance(nextC,userd);
	errorRec(ite+1) = sum(error);
end

cent = [5 10 15 20 25];%1:30;
farnear = zeros(20,30);
farnear2 = zeros(20,30);
largest = zeros(10,length(cent));
mn = cell(10,length(cent));
test = zeros(1682,length(cent));
test2 = zeros(1682,length(cent));

for i = 1:length(cent)
	curcent = nextC(cent(i),:);
	prod = zeros(1,1682);
	for j = 1:1682	
		prod(j) = dot(curcent,movied(j,:));%curcent*movied';
	end
	[rank idy] = sort(prod,'descend');
	largest(:,i) = rank(1:10);
	mn(:,i) = movie_names(idy(1:10));
	
	test(:,i) = rank;
	test2(:,i) = idy;
	farnear(1:10,i) = rank(1:10);
	farnear(11:20,i) = rank(1673:1682);
	farnear2(1:10,i) = idy(1:10);
	farnear2(11:20,i) = idy(1673:1682);
end

