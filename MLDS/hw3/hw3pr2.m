%% problem 2 %%
load('cancer.mat');

trainX = X(2:10,184:end);
testX = X(2:10, 1:183);

trainLabel = label(184:end);
testLabel = label(1:183);

%% no boost
posTrain = trainX(:,trainLabel==1);
negTrain = trainX(:,trainLabel==-1);
muPosTrain = mean(posTrain,2);
muNegTrain = mean(negTrain,2);

trainMean = mean(trainX(:,:),2);
repTrainMean = repmat(trainMean,[1 500]);
sharedCov = (trainX-repTrainMean)*(trainX-repTrainMean)' ./ 500;
invcov = inv(sharedCov);
detcov = det(sharedCov);
correct = 0;

w0 = log(size(posTrain,2)/size(negTrain,2))-(1/2)*((muPosTrain+muNegTrain)')*invcov*(muPosTrain-muNegTrain);
w = invcov * (muPosTrain-muNegTrain);

for te = 1:size(testX,2)
	sig = (testX(:,te)')*w+w0;
	if (sig*testLabel(te)>0)
		correct = correct+1;
	end
end

noboostAcc = correct/length(testLabel)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% boost

point3 = [101, 106, 121];
distri3 = zeros(1000,3);
avg = zeros(10,1);

for av = 1:10

	distri = repmat([1/500],[1 500]);
	epsilon = zeros(1000,1);
	alpha = zeros(1000,1);
	weakClassifier = zeros(500,1);
	w0 = zeros(1000,1);
	w = zeros(1000,9);
	%iteAcc = zeros(1000,1);

	%% boost
	for t = 1:1000
		sampleIndex = sampleDiscrete(500,distri);
		sampleSet = trainX(:, sampleIndex);
	
		samplePosIdx = sampleIndex(trainLabel(sampleIndex)==1);
		sampleNegIdx = sampleIndex(trainLabel(sampleIndex)==-1);

		samplePos = trainX(:,samplePosIdx);
		muSamplePos = mean(samplePos,2);
		sampleNeg = trainX(:,sampleNegIdx);
		muSampleNeg = mean(sampleNeg,2);

		w0(t) = log((size(samplePos,2))/(size(sampleNeg,2)))-(1/2)*((muSamplePos+muSampleNeg)')*invcov*(muSamplePos-muSampleNeg); %1*1
		w(t,:) = invcov * (muSamplePos-muSampleNeg); %1*9
	
		weakClassifier = sign((w(t,:)*trainX)'+w0(t)); %(1*9)*(9*500)
		score = weakClassifier.*trainLabel';
		epsilon(t) = sum(distri(score<0));
		alpha(t) = (1/2)*log((1-epsilon(t))/(epsilon(t)));
	
		distri = distri.*exp(-1*alpha(t)*(score'));
		distri = distri/sum(distri);
		distri3(t,:) = distri(point3);
		
		%%
		
		%%
	end

	%boostAcc
	boostAcc = 0;
	boostCorrect = 0;
	for te = 1:size(testX,2)
		xte = testX(:,te);
		WX = w*xte+w0;
		alphaWX = sign(sum(alpha .* sign(WX)));
		if (alphaWX*testLabel(te)>0)
			boostCorrect = boostCorrect + 1;
		end
	end

	boostAcc = boostCorrect / 183;
	avg(av) = boostAcc;
end
mean(avg)

trainErr = zeros(1000,1);
testErr = zeros(1000,1);
for ww = 1:1000
	pluginTrain = sign(w(1:ww,:)*trainX+repmat(w0(1:ww),[1 500])); % 1000*500
	alphaPluginTr = repmat(alpha(1:ww),[1 500]).*pluginTrain;
	resultTr = sign(sum(alphaPluginTr)).*trainLabel; % 1*500 X 1*500
	trainErr(ww) = length(resultTr(resultTr<0));
	
	pluginTest = sign(w(1:ww,:)*testX+repmat(w0(1:ww),[1 183])); % 1000*183
	alphaPluginTe = repmat(alpha(1:ww),[1 183]).*pluginTest;
	resultTe = sign(sum(alphaPluginTe)).*testLabel; % 1*183 X 1*183
	testErr(ww) = length(resultTe(resultTe<0));
end

trainErr = trainErr/500; testErr = testErr/183;

subplot(1,2,1), plot(alpha), title(['alpha']);
subplot(1,2,2), plot(epsilon), title(['epsilon']);
subplot(1,2,1), plot(trainErr), title(['Train error rate']);
subplot(1,2,2), plot(testErr), title(['Test error rate']);
ssize = 1:1000;
subplot(1,2,1), semilogx(ssize, trainErr), title(['Train error rate']);;
subplot(1,2,2), semilogx(ssize, testErr), title(['Test error rate']);

subplot(1,3,1), plot(distri3(:,1)), title(['101 distribution']);
subplot(1,3,2), plot(distri3(:,2)), title(['106 distribution']);
subplot(1,3,3), plot(distri3(:,3)), title(['121 distribution']);

