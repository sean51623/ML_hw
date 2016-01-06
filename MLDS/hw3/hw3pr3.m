%% hw3pr3 %% 
load('cancer.mat');

trainX = X(:,184:end);
testX = X(:, 1:183);

trainLabel = label(184:end);
testLabel = label(1:183);

%% no boost

avg = zeros(10,1);
for av = 1:10
	w = zeros(10,501);
	rp = 1:500;%randperm(500);
	newTrain = trainX(:,rp);
	newLabel = trainLabel(:,rp);

	for n = 2:501
		sigma = 1/(1+ exp(-1*newLabel(n-1) * (newTrain(:,n-1)') * (w(:,n-1))) ); % 1*10 X 10*1
		w(:,n) = w(:,n-1) + 0.1126 * (1-sigma) * newLabel(n-1) * newTrain(:,n-1); % 10*1 = 10*1
	end

	correct = 0;
	for te = 1:183
		es = exp((testX(:,te)')*w(:,501)); % 1*10 X 10*1 = 1*1
		fx = sign(es/(1+es)-0.5);
		if ((fx*testLabel(te)>0))
			correct = correct + 1;
		end
	end

	noboostAcc = correct/183;
	avg(av) = noboostAcc;
end
mean(avg)

%%%%%%%%%%%%%%%%
%% boost
%{
point3 = [101, 106, 121];
distri3 = zeros(1000,3);
avg = zeros(10:1);

for av = 1:10
	boostW = zeros(10,1000); % for final boost
	recordW = zeros(10,501); % for online recording
	currentW = zeros(10,1);

	distri = repmat([1/500],[1 500]);
	epsilon = zeros(1000,1);
	alpha = zeros(1000,1);

	nextTrain = zeros(10,500);
	nextLabel = zeros(1,500);
	score = zeros(1,500);
	weakClassfier = zeros(500,1);

	for ite = 1:1000
		sampleIndex = sampleDiscrete(500,distri);
		nextTrain = trainX(:,sampleIndex);
		nextLabel = trainLabel(sampleIndex);
	
		for n = 2:501
			sigma = 1/(1+ exp(-1*nextLabel(n-1) * (nextTrain(:,n-1)') * (recordW(:,n-1))) ); % 1*10 X 10*1
			recordW(:,n) = recordW(:,n-1) + 0.1 * (1-sigma) * nextLabel(n-1) * nextTrain(:,n-1); % 10*1 = 10*1
		end
		boostW(:,ite) = recordW(:,501);
		currentW = recordW(:,501);
	
		exptrainXW = exp((trainX')*currentW); % 500*1
		fxtrain = exptrainXW./(1+exptrainXW);  
		weakClassfier = sign(fxtrain-0.5);
		score = (weakClassfier').*trainLabel;
		epsilon(ite) = sum(distri(score<0));
		alpha(ite) = (1/2)*log((1-epsilon(ite))/(epsilon(ite)));
	
		distri = distri .* exp(-1*alpha(ite)*(score));
		distri = distri/sum(distri);
		distri3(ite,:) = distri(point3);
	end

	%boostAcc

	boostAcc = 0;
	boostCorrect = 0;
	for te = 1:size(testX,2)
		es = exp((testX(:,te)')*boostW); % 1*1000
		fx = sign((es./(1+es))-0.5);
		alphafx = sign(sum(fx*alpha));
		if (alphafx*testLabel(te)>0)
			boostCorrect = boostCorrect + 1;
		end
	end

	boostAcc = boostCorrect / 183;
	avg(av) = boostAcc;
end
mean(avg)

trainErr = 0;
testErr = 0;
for ite = 1:1000
	prepareTrES = exp((boostW(:,1:ite)')*trainX); % ite * 500
	pluginTrain = sign((prepareTrES./(1+prepareTrES))-0.5);
	alphaPluginTr = repmat(alpha(1:ite),[1 500]).*pluginTrain;
	resultTr = sign(sum(alphaPluginTr)).*trainLabel; % 1*500 X 1*500
	trainErr(ite) = length(resultTr(resultTr<0));
	
	prepareTeES = exp((boostW(:,1:ite)')*testX); % ite * 183
	pluginTest = sign((prepareTeES./(1+prepareTeES))-0.5);
	alphaPluginTe = repmat(alpha(1:ite),[1 183]).*pluginTest;
	resultTe = sign(sum(alphaPluginTe)).*testLabel; % 1*183 X 1*183
	testErr(ite) = length(resultTe(resultTe<0));
end

trainErr = trainErr/500; testErr = testErr/183;

subplot(1,2,1), plot(alpha), title(['alpha']);
subplot(1,2,2), plot(epsilon), title(['epsilon']);
subplot(1,2,1), plot(trainErr), title(['Train error rate']);
subplot(1,2,2), plot(testErr), title(['Test error rate']);
ssize = 1:1000;
subplot(1,2,1), semilogx(ssize, trainErr), title(['Train error rate']);
subplot(1,2,2), semilogx(ssize, testErr), title(['Test error rate']);

subplot(1,3,1), plot(distri3(:,1)), title(['101 distribution']);
subplot(1,3,2), plot(distri3(:,2)), title(['106 distribution']);
subplot(1,3,3), plot(distri3(:,3)), title(['121 distribution']);
%}
