function x = sampleDiscrete(n, k)

if (sum(k)~=1) 
	knorm = k/sum(k);
else
	knorm = k;
end

kcum = cumsum([0 knorm]);
rd = rand(1,n);
[t1, t2] = histc(rd,kcum);
ss = 1:length(k);
x=ss(t2);

end

