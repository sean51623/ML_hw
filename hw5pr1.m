% hw5.1

load('./hw5mat/CFB2014.mat');

M = zeros(759,759);

for i = 1:size(scores,1)
	pj1 = scores(i,2)/(scores(i,2)+scores(i,4));
	pj2 = scores(i,4)/(scores(i,2)+scores(i,4));
	
	M(scores(i,1), scores(i,1)) = M(scores(i,1), scores(i,1)) + cpr(scores(i,2), scores(i,4)) + pj1;
	M(scores(i,3), scores(i,3)) = M(scores(i,3), scores(i,3)) + cpr(scores(i,4), scores(i,2)) + pj2;
	M(scores(i,1), scores(i,3)) = M(scores(i,1), scores(i,3)) + cpr(scores(i,4), scores(i,2)) + pj2;
	M(scores(i,3), scores(i,1)) = M(scores(i,3), scores(i,1)) + cpr(scores(i,2), scores(i,4)) + pj1;

end

normM = M ./ repmat(sum(M,2),[1 759]);
% sum(normM(1,:))
%%%

w0 = repmat(1/759,[759 1]);
wrec = zeros(759,4);
value = zeros(20,4);
ranking = zeros(20,4);
rank_name = cell(20,4);
wite = [10, 100, 200, 1000];

for i = 1:4
	wcur = w0;
	for j = 1:wite(i)
		wnext = (normM')*wcur;
		wcur = wnext;
	end
	wrec = wcur;
	[t1, t2] = sort(wnext,'descend');
	value(:,i)=t1(1:20);
	ranking(:,i)=t2(1:20);
	rank_name(:,i) = legend(ranking(:,i));
end

[egvc, eg] = eig(normM');
error = zeros(1000,1);
%%
egg = zeros(759,1);
for i = 1:759
	egg(i) = eg(i,i);
end
%findidx = find(egg==max(egg));
%winf = egvc(:,findidx);
[rr, ii] = sort(egg,'descend');
winf = egvc(:,ii(2));
%% 

winf = winf./sum(winf);
wcur = w0;
for i = 1:1000
	wnext = (normM')*wcur;
	error(i) = sum(abs(wnext-winf));
	wcur = wnext;
end
plot(error)

