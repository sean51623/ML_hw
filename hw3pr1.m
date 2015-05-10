w = [0.1 0.2 0.3 0.4];

aa = sampleDiscrete(100,w);
hist(aa,4), title(['n=100'])
aa = sampleDiscrete(200,w);
hist(aa,4), title(['n=200'])
aa = sampleDiscrete(300,w);
hist(aa,4), title(['n=300'])
aa = sampleDiscrete(400,w);
hist(aa,4), title(['n=400'])
aa = sampleDiscrete(500,w);
hist(aa,4), title(['n=500'])

