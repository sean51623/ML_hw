%%% MLF hw1_15 PLA %%%

load('hw1_15.mat');

%{
w = zeros(5,1);
x5 = ones(400,1);

prev = 0;
cur = 1;
update = 0;
while prev~=cur
	score = w(1)*x1(cur)+w(2)*x2(cur)+w(3)*x3(cur)+w(4)*x4(cur)+w(5)*x5(cur);
	
	if score*y1(cur)<=0
		update = update + 1;
		w(1) = w(1)+y1(cur)*x1(cur);
		w(2) = w(2)+y1(cur)*x2(cur);
		w(3) = w(3)+y1(cur)*x3(cur);
		w(4) = w(4)+y1(cur)*x4(cur);
		w(5) = w(5)+y1(cur)*x5(cur);
		prev = cur;
	end
	
	if cur~=400
		cur = cur + 1;
	else
		cur = 1;
	end
end
%}

update = zeros(2000,1);
for i = 1:length(update)
	w = zeros(5,1);
	x5 = ones(400,1);
	order = randperm(400);
	previdx = 0;
	idx = 1;
	ita = 2;
	cur = order(idx);
	while previdx~=idx
		cur = order(idx);
		score = w(1)*x1(cur)+w(2)*x2(cur)+w(3)*x3(cur)+w(4)*x4(cur)+w(5)*x5(cur);
	
		if score*y1(cur)<=0
			update(i) = update(i) + 1;
			w(1) = w(1)+ita*y1(cur)*x1(cur);
			w(2) = w(2)+ita*y1(cur)*x2(cur);
			w(3) = w(3)+ita*y1(cur)*x3(cur);
			w(4) = w(4)+ita*y1(cur)*x4(cur);
			w(5) = w(5)+ita*y1(cur)*x5(cur);
			previdx = idx;
		end
	
		if idx~=400
			idx = idx + 1;
		else
			idx = 1;
		end
	end
	%hi = 1
end
mean(update)
