% reference: modified from Frank Wood's code of Infinite GMM: http://www.gatsby.ucl.ac.uk/~fwood/code.html

function [class_id] = DirichP_GMM(training_data,empMean,v_0,clusInnoPara,lambda_0)
num_iter = 500;

% initialize
alogPha = 1;
Kcluster = 1;
N = size(training_data,2);
y = training_data;
D = size(training_data,1);
a_0 = 1;
b_0 = 2;

% record
mean_rec = cell(num_iter,1);
covar_rec = cell(num_iter,1);
inv_covar_rec = cell(num_iter,1);
class_id = zeros(N,num_iter);

class_id(:,1) = 1;
mean_rec{1} = y(:,1);
covar_rec{1} = zeros(D,D,1);
covar_rec{1}(:,:,1) = eye(size(y,1));
inv_covar_rec{1} = zeros(D,D,1);
inv_covar_rec{1}(:,:,1) = eye(size(y,1));

% compute the log likelihood
logP = logP_crp(class_id(:,1),alogPha);
for k = 1:Kcluster
    classK_index = find(class_id(:,1)==k);
    logP = logP + sum(evalLogProb(y(:,classK_index),mean_rec{1}(:,k),covar_rec{1}(:,:,k)));
    mu = mean_rec{1}(:,k);
    sigma = covar_rec{1}(:,:,k);
    logP = logP + lpnormalinvwish(mu,sigma,empMean,clusInnoPara,v_0,lambda_0);
end
logP_rec(1) = logP;

for ite = 2:num_iter
    mean_rec{ite} = mean_rec{ite-1};
    covar_rec{ite} = covar_rec{ite-1};
    inv_covar_rec{ite} = inv_covar_rec{ite-1};
    class_id(:,ite) = class_id(:,ite-1);

    for i = 1:N
        m_k = zeros(Kcluster,1);
        for k = 1:Kcluster
            if (k>Kcluster)
                break;
            end
            m_k(k) = length(find(class_id(:,ite)==k));
            if (class_id(i,ite)==k)
                m_k(k) = m_k(k)-1;
                if (m_k(k)==0)
                    mean_rec{ite} = mean_rec{ite}(:,[1:k-1 k+1:end]);
                    covar_rec{ite} = covar_rec{ite}(:,:,[1:k-1 k+1:end]);
                    inv_covar_rec{ite} = inv_covar_rec{ite}(:,:,[1:k-1 k+1:end]);
                    for j = k:Kcluster
                        change_inds = find(class_id(:,ite)==j);
                        class_id(change_inds,ite) = j-1;
                    end
                    Kcluster = Kcluster-1;
                    m_k = m_k(1:end-1);
                end
            end
        end

        prior = [m_k; alogPha]/(N-1+alogPha);
        likelihood = zeros(length(prior)-1,1);

        for l = 1:length(likelihood)
            l1 = y(:,i)-mean_rec{ite}(:,l);
            logP = -l1'*inv_covar_rec{ite}(:,:,l)*l1/2-.5*log(det(covar_rec{ite}(:,:,l)))-(D/2)*log(2*pi);
            likelihood(l) = logP;
        end

        newLikelihood = 0;
        new_covar = iwishrnd(lambda_0, v_0);
        new_mean = mvnrnd(empMean',new_covar'/clusInnoPara)';
        l1 = y(:,i) - new_mean;
        inverse_new_covar = inv(new_covar);
        newLikelihood = newLikelihood-l1'*inverse_new_covar*l1/2-.5*log(det(new_covar))-(D/2)*log(2*pi);
        likelihood = [likelihood; newLikelihood];
        likelihood = exp(likelihood-max(likelihood));
        likelihood = likelihood/sum(likelihood);
        if(sum(likelihood==0))
            likelihood(end) = eps;
        end
        temp = prior.*likelihood;
        temp = temp/sum(temp);

        cdf = cumsum(temp);
        rn = rand;
        new_class_id = min(find((cdf>rn)==1));

        if(new_class_id == Kcluster+1)
            mean_rec{ite} = [mean_rec{ite} new_mean];
            covar_rec{ite}(:,:,new_class_id) =  new_covar;
            inv_covar_rec{ite}(:,:,new_class_id) =  inv(new_covar);
            Kcluster = Kcluster+1;
        end
        class_id(i,ite) = new_class_id;
    end

    for k = 1:Kcluster
        classK_index = find(class_id(:,ite)==k);
        numOfCurClass = length(classK_index);
        S = cov(y(:,classK_index)')'*(numOfCurClass-1);
        y_bar = mean(y(:,classK_index)')';
        mu_n = (numOfCurClass*y_bar+clusInnoPara*empMean)/(clusInnoPara+numOfCurClass);
		lambda_n = lambda_0 + (clusInnoPara*numOfCurClass)/(clusInnoPara+numOfCurClass)*((y_bar-empMean)*(y_bar-empMean)')+S;
		
		k_n = clusInnoPara + numOfCurClass;
		v_n = v_0 + numOfCurClass;
		new_covar = iwishrnd(lambda_n, v_n);
		new_mean = mvnrnd(mu_n',new_covar'/k_n)';
        mean_rec{ite}(:,k) = new_mean;
        covar_rec{ite}(:,:,k) = new_covar;
        inv_covar_rec{ite}(:,:,k) = inv(new_covar);
    end

	logP = logP_crp(class_id(:,ite),alogPha);
	for k = 1:Kcluster
		classK_index = find(class_id(:,ite)==k);
		logP = logP + sum(evalLogProb(y(:,classK_index),mean_rec{ite}(:,k),covar_rec{ite}(:,:,k)));
		mu = mean_rec{ite}(:,k);
		sigma = covar_rec{ite}(:,:,k);
		logP = logP + lpnormalinvwish(mu,sigma,empMean,clusInnoPara,v_0,lambda_0);
		logP = logP - gamlike([a_0 b_0],alogPha);
	end

	alogPha_prop = alogPha + randn*.1;
	logP_alogPha_prop = logP_crp(class_id(:,ite),alogPha_prop);
	logP_alogPha_prop = logP_alogPha_prop - gamlike([a_0 b_0],alogPha_prop);
	log_acceptance_ratio = logP_alogPha_prop - logP;
	if(log(rand)<min(log_acceptance_ratio,0))
		alogPha = alogPha_prop;
	end	
end
