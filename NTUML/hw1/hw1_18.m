%%% MLF hw1_18 POCKET %%%

load('hw1_18_train2.mat');
load('hw1_18_test2.mat');
ite = 0;

update = zeros(2000,1);
error = zeros(2000,1);
for i = 1:length(update)
	w = zeros(5,1);
	neww = zeros(5,1);
	
	order = randperm(500);
	previdx = 0;
	idx = 1;
	cur = order(idx);
	while update(i)<50 && previdx~=idx
		%ite = ite+1;
		cur = order(idx);
		score = Xtr(cur,:)*w;
		%Ytr(cur)
		
		%{
		if score*Ytr(cur)>0
			neww = w + (Ytr(cur)*Xtr(cur,:))';
			ts1 = (Xtr*w).*Ytr;
			ts2 = (Xtr*neww).*Ytr;
			count1 = length(find(ts1<=0));
			count2 = length(find(ts2<=0));
			if count1>count2
				w = neww;
				%previdx = idx;
				update(i) = update(i) + 1;
			end
		else
		%}
		if score*Ytr(cur)<=0
			w = w + (Ytr(cur)*Xtr(cur,:))';
			update(i) = update(i) + 1;
			previdx = idx;
		end
	
		if idx~=500
			idx = idx + 1;
		else
			idx = 1;
		end
	end
	%hi = 1
	
	score2 = (Xte*w).*Yte;
	error(i) = length(find(score2<=0))/500;
end
mean(error)
