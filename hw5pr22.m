% hw5.2 p2
tic
load('./hw5mat/nyt_data.mat');

X = zeros(3012,8447);
for i = 1:8447
	tmp1 = Xid{i};
	tmp2 = Xcnt{i};
	X(tmp1,i) = tmp2;
end

w = rand(3012,25);
h = rand(25,8447);
error = zeros(200,1);

eps1 = repmat(eps,[3012 25]);
eps2 = repmat(eps,[25 8447]);
eps3 = repmat(eps,[3012 8447]);

for i = 1:200
	purple = X./ (w*h+eps3);
	pink = (w')./ (repmat(sum(w',2), [1 size(w,1)])+eps1');
	h = h.*(pink*purple);
	
	purple = X./ (w*h+eps3);
	water = (h')./ (repmat(sum(h'),[size(h',1) 1])+eps2');
	w = w.*(purple*water);
	
	lg = (log(ones(3012,8447)./ (w*h+eps3)));
	entropy = sum(sum(X.*lg+w*h));
	error(i) = entropy;
end
toc

%%
highestprob = zeros(10,5);
highestvocab = cell(10,5);
art = [1,2,3,4,5];
normW = w./ repmat(sum(w),[3012 1]);
for i = 1:5
	hi = normW(:,art(i));
	[h1, h2] = sort(hi,'descend');
	highestprob(:,i) = h1(1:10);
	highestvocab(:,i) = nyt_vocab(h2(1:10));
end


%w = repmat(0.1,[3012 25]);
%h = repmat(0.1,[25 8447]);