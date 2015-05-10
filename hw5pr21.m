% hw5.2 p1
%tic
load('./hw5mat/faces.mat');

w = rand(1024,25);
h = rand(25,1000);


error = zeros(200,1);

for i = 1:200
	tmp1 = w'*X;
	tmp2 = w'*w*h;
	h = h.*(tmp1./tmp2);

	tmp3 = X*h';
	tmp4 = w*h*h';
	w = w.*(tmp3./tmp4);
	diff = X-w*h;
	
	error(i) = norm(diff);
end

im3 = [101, 106, 121];
sl1 = X(:,im3(3));
tt = h(:,im3(3));
maxh = find(tt==max(tt));
sl2 = w(:,maxh);
sl1tmp = reshape(sl1,32,32);
sl2tmp = reshape(sl2,32,32);
subplot(1,2,1), imagesc(sl1tmp), title(['image121']);
subplot(1,2,2), imagesc(sl2tmp), title(['highest weight']);
%toc

%w = repmat(0.2,[1024 25]); %the same
%h = repmat(0.5,[25 1000]);
%w = [repmat(0.2,[512 25]) ; repmat(0.1,[512 25])];
%h = [repmat(0.4,[25 500]) repmat(0.8,[25 500])];
%error(i) = sqrt(sum(sum(diff.^2)));