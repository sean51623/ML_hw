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