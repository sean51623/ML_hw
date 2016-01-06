%{
BMML HW3

n: number of data
d: dimension of data

qw(Normal), qa(Gamma), ql(Gamma)

ew: mut*mut'+sigmat

el: 1*1, et/ft

ea: d*d, 
diag = eye(d)
for i = 1 to d
	diag(i,i) = at/bt

qw:
sigmat: d*d, inv(ea+el*x'*x)
mut: d*1, sigmat*el*x'*y

qa:
for i = 1 to d
	at = 1*1, a0+0.5
	bt = 1*1, b0+0.5*ew(i,i)

ql:
et = 1*1, e0+n/2
ft = 1*1, f0+0.5sum((y)^2+x'*sigmat*x)

L = sum of all the parts (1+2+3+4-5-6-7)
part1 = n*0.5*(psi(et)-log(ft))-n*0.5*log(2*pi)-0.5*et*()/ft
part2 = sum
part3 =
part4 = e0*log(f0)-gammaln(e0)+(e0-1)*(psi(et)-log(ft))-f0*et/ft
part5 = 0.5*log(det(sigmat))+d*0.5*(1+log(2*pi))
part6 = sum()
part7 = et*log(ft)-gammaln(et)+(et-1)*(psi(et)-log(ft))-et

%}

load('data3.mat');

n = size(X,1);
d = size(X,2);

a0 = 10^-16;
b0 = 10^-16;
e0 = 1;
f0 = 1;

at = repmat(10^-16, d,1);
bt = repmat(10^-16, d,1);
et = 1;
ft = 1;
ea = diag(at./bt);
el = et/ft;

nextSigmat = ea+el*X'*X;
sigmat = inv((nextSigmat));
mut = el*sigmat*X'*y; % d*1
ew = mut*mut'+sigmat;

L = zeros(500,1);

for t = 1:500

	
%%
	at = ones(d,1)*a0+0.5;
	bt = b0+0.5*diag(ew);
	et = e0+0.5*n;
	tmp1 = 0.5*sum((y-X*mut).^2)+0.5*trace(X*sigmat*X');
	ft = f0+tmp1;
	ea = diag(at./bt);
	el = et/ft;
%%
	nextSigmat = ea+el*X'*X;
	sigmat = nextSigmat\eye(d);
	mut = el*sigmat*X'*y; % d*1
	ew = mut*mut'+sigmat;
%%	

	tmp2 = (psi(at)-log(bt));
	part1 = n*0.5*(psi(et)-log(ft))-n*0.5*log(2*pi)-0.5*el*tmp1;
	part2 = -0.5*d*log(2*pi)+sum(0.5*(tmp2)-0.5*(at./bt).*diag(ew));
	part3 = d*(a0*log(b0)-gammaln(a0))+sum((a0-1)*tmp2-b0*(at./bt));
	part4 = e0*log(f0)-gammaln(e0)+(e0-1)*(psi(et)-log(ft))-f0*et/ft;
	%%
	tmp3 = log_det(sigmat);
	tmp31 = det(sigmat);
	tmp32 = log(tmp31);
	if (isinf(tmp32))
		tmp33 = chol(sigmat);
		tmp34 = 2*sum(log(diag(tmp33)));
		part5 = 0.5*tmp34+d*0.5*(1+log(2*pi));
	else
		part5 = 0.5*tmp32+d*0.5*(1+log(2*pi));
	end
	%%
	part6 = sum(at.*log(bt)-gammaln(at)+(at-1).*tmp2-at);
	part7 = et*log(ft)-gammaln(et)+(et-1)*(psi(et)-log(ft))-et;
	L(t) = part1+part2+part3+part4+part5-part6-part7;	

end

plot(L)


%b)
eak = ones(d,1)./(at./bt);
stem(eak)
%c)
ft/et
%d)
yest = X*mut;
plot(z,yest,z,10*sinc(z)), legend('Estimated y vs z','Ground Truth'), hold on, scatter(z,y,'MarkerFaceColor',[0 .7 .7])



%{ code fragments
	if (isinf(log(det(sigmat))))
		[Ltr,pp] = chol(sigmat);
		tmp3 = 2*sum(log(diag(Ltr)));
	else
		tmp3 = log(det(sigmat));
	end
	part5 = 0.5*tmp3+d*0.5*(1+log(2*pi));
	
	tmp3 = log(det(sigmat));
	if (isinf(tmp3))
		tmp3 = log_det(sigmat);
	end
	
	[warnmsg, msgid] = lastwarn;
	if strcmp(msgid,'MATLAB:nearlySingularMatrix')
		tmp4 = chol(nextSigmat);
		sigmat = inv(tmp4')*inv(tmp4);
	end
	
	tmp12 = b0;
	for i = 1:n
		tmp12 = tmp12 + 0.5*((y(i)-X(i,:)*mut)^2+X(i,:)*sigmat*(X(i,:)'));
	end
%}