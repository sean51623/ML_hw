%%% hw2 %%%

load('./hw2_data_mat/mnist_mat.mat');

wcur = zeros(15,1);
wnext = zeros(15,1);
wrec = zeros(15,100);
eqt = zeros(size(Xtrain,2),1);
objective = zeros(100,1);

trainPos = find(ytrain==1);
trainNeg = find(ytrain==0);

for t = 1:100
	funcPos = -Xtrain(:,trainPos)'*wcur/1.5; % x*15*15*1= x*1
	funcNeg = -Xtrain(:,trainNeg)'*wcur/1.5; % x*15*15*1= x*1
	eqt(trainPos) = Xtrain(:,trainPos)'*wcur + 1.5*(normpdf(funcPos)./(1-normcdf(funcPos))); % x*15*15*1 + x*1 = x*1
	eqt(trainNeg) = Xtrain(:,trainNeg)'*wcur + 1.5*(-normpdf(funcNeg)./normcdf(funcNeg)); % x*15*15*1 + x*1 = x*1
	wnext = (inv(eye(15)*((Xtrain*Xtrain')/2.25)))*(Xtrain*eqt/2.25); % ()*()
	wcur = wnext;
	wrec(:,t) = wcur;
	
	newfunc = Xtrain'*wcur/1.5;
	objective(t) = 7.5*log(1/(2*pi)) - 0.5*wcur'*wcur + ytrain*log(normcdf(newfunc)) + (1-ytrain)*log(1-normcdf(newfunc));
end


probit = normcdf(Xtest'*wnext/1.5);
probitRec = probit;
probit = probit';
pos = find(probit>=0.5);
neg = find(probit<0.5);
probit(pos)=1;
probit(neg)=0;
%{
correct = length(find(probit==ytest));
correct/1991

confusion = zeros(2,2);
confusion(1,1) = length(find(ytest==0 & probit==0));
confusion(1,2) = length(find(ytest==0 & probit==1));
confusion(2,1) = length(find(ytest==1 & probit==0));
confusion(2,2) = length(find(ytest==1 & probit==1));

%%%

mistake = find(ytest==0 & probit==1);
for i = 1:3
	temp = Xtest(:,mistake(i));
	recon = Q * temp;
	resh = reshape(recon, [28, 28]);
	subplot(1,3,i), imagesc(resh), title(['test data ' int2str(mistake(i))]);
	probitRec(mistake(i))
end

diff = abs(probitRec-0.5);
[~, order] = sort(diff,'ascend');
for i = 1:3
	temp = Xtest(:,order(i));
	recon = Q * temp;
	resh = reshape(recon, [28, 28]);
	subplot(1,3,i),imagesc(resh),title(['test data ' int2str(order(i))]);
	probitRec(order(i))
end
%}

ite = [1,5,10,25,50,100];
reconRec = zeros(784,6);
for i = 1:6
	recon = Q*wrec(:,ite(i));
	reconRec(:,i) = recon;
	resh = reshape(recon, [28, 28]);
	subplot(2,3,i), imagesc(resh), title(['iteration ' int2str(ite(i))]);
end

%{
reconRec2 = reconRec*100000;
for i = 1:6
	resh = reshape(reconRec(:,i), [28, 28]);
	subplot(2,3,i), image(resh), title(['iteration ' int2str(ite(i))]);
end
%}