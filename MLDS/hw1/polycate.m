function X = polycate(a,b)
	if (b==1) 
		X=a;
	end
	
	tmp = a(:,2:end);
	for i = 2:b
		tmp = tmp.*tmp;
		a = [a, tmp];
	end
	X=a;
end	

