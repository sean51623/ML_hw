%%% MLF hw1_18 POCKET %%%

load('hw1_18_train2.mat');
load('hw1_18_test2.mat');
ite = 0;

update = zeros(2000,1);
error = zeros(2000,1);
for i = 1:length(update)
	w = zeros(5,1);
	wpocket = zeros(5,1);
	curmin = 1000;
	
	order = randperm(500);
	previdx = 0;
	idx = 1;
	cur = order(idx);
	while update(i)<100 && previdx~=idx
		cur = order(idx);
		score = Xtr(cur,:)*w;
			
		if score*Ytr(cur)<=0
			w = w + (Ytr(cur)*Xtr(cur,:))';
			
			score2 = (Xtr*w).*Ytr;
			recError = length(find(score2<0));
			if recError < curmin
				curmin = recError;
				wpocket = w;
			end
			update(i) = update(i) + 1;
			previdx = idx;
		end
	
		idx = mod(idx,500)+1;
	end
	
	
	score3 = (Xte*wpocket).*Yte;
	%score3 = (Xte*w).*Yte;
	error(i) = length(find(score3<=0))/500;
end
mean(error)

%{
https://class.coursera.org/ntumlone-002/forum/thread?thread_id=79
每次都隨機拿，有可能兩次抽到同一筆數據
這個問題特別值得注意。注意到這裡pocket所扮演的角色。pocket不負責"更新" w，只負責記錄目前為止"最好"的w。那麼題目上說的add the 'pocket' steps是什麼意思呢？可以想像有一個旁觀者，在那裡觀察PLA在更新w，但是它所能做的，只是"偷偷"記錄下來每一次更新的w，注意是"偷偷"記下來，pocket是"完全"不會去影響PLA如何去更新的。當PLA更新了50次w停下之後，pocket再告訴你："嗯，這50個w中，第k個w，效果最棒，所以我們最後用第k個w吧！"
經過PLA(with Pocket)在訓練資料跑出的w(最好的w)，把這個w用在test set中，得到1個error。按照這樣試驗2000次，一共有2000個error rate，取平均數。

https://class.coursera.org/ntumlone-002/forum/thread?thread_id=144
%}