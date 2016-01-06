load('./hw1_data_mat/mnist_mat.mat')

train_pos = Xtrain(:,ytrain==1);
train_neg = Xtrain(:,ytrain==0);

pos_parameter = zeros(15,7);
neg_parameter = zeros(15,7);

pos_prior = (1+size(train_pos,2))/(size(Xtrain,2)+2);
neg_prior = (1+size(train_neg,2))/(size(Xtrain,2)+2);

base_p1 = (size(train_pos,2)+1); % n+ 1/a
base_n1 = (size(train_neg,2)+1); % n+ 1/a
base_p2 = size(train_pos,2)/2+1; % n/2 + 1
base_n2 = size(train_neg,2)/2+1; % n/2 + 1

%% mu_0 = 0, lambda_0 = 1, alpha_0 = 1, beta_0 = 1

for x = 1:15
	% pos
	tmp_sum_p = sum(train_pos(x,:));
	tmp_avg_p = mean(train_pos(x,:));
	tmp_var_p = var(train_pos(x,:));
	pos_parameter(x,1) = sum(train_pos(x,:))/base_p1; % mu_n
	pos_parameter(x,2) = base_p1; % lambda_n
	pos_parameter(x,3) =  base_p2; % alpha_n
	pos_parameter(x,4) = 1+0.5*sum((train_pos(x,:)-tmp_avg_p).^2)+0.5*size(train_pos,2)*(tmp_avg_p^2)/base_p1; % beta_n
	pos_parameter(x,5) = (pos_parameter(x,3)*pos_parameter(x,2))/(pos_parameter(x,4)*(pos_parameter(x,2)+1)); % sigma_n
	pos_parameter(x,6) = (1/sqrt(pi))*exp(gammaln(pos_parameter(x,3)+0.5)-gammaln(pos_parameter(x,3)))*(sqrt(pos_parameter(x,5)/(2*pos_parameter(x,3))));
	
	% neg
	tmp_sum_n = sum(train_neg(x,:));
	tmp_avg_n = mean(train_neg(x,:));
	tmp_var_n = var(train_neg(x,:));
	neg_parameter(x,1) = sum(train_neg(x,:))/base_n1; % mu_n
	neg_parameter(x,2) = base_n1; % lambda_n
	neg_parameter(x,3) = base_n2; % alpha_n
	neg_parameter(x,4) = 1+0.5*sum((train_neg(x,:)-tmp_avg_n).^2)+0.5*size(train_neg,2)*(tmp_avg_n^2)/base_n1; % beta_n
	neg_parameter(x,5) = (neg_parameter(x,3)*neg_parameter(x,2))/(neg_parameter(x,4)*(neg_parameter(x,2)+1)); % sigma_n
	neg_parameter(x,6) = (1/sqrt(pi))*exp(gammaln(neg_parameter(x,3)+0.5)-gammaln(neg_parameter(x,3)))*(sqrt(neg_parameter(x,5)/(2*neg_parameter(x,3))));

end


prediction = zeros(3,size(ytest,2));

a1 = repmat(pos_parameter(:,5),1,size(ytest,2));
a2 = ((Xtest-repmat(pos_parameter(:,1),1,size(ytest,2))).^2);
a3 = (2*repmat(pos_parameter(:,3),1,size(ytest,2)));
a4 = -0.5-repmat(pos_parameter(:,3),1,size(ytest,2));
lastterm = (1+a1.*a2./a3).^(a4);
a5 = repmat(pos_parameter(:,6),1,1991);

prediction(1,:) = prod(a5.*lastterm)*pos_prior;

a1 = repmat(neg_parameter(:,5),1,size(ytest,2));
a2 = ((Xtest-repmat(neg_parameter(:,1),1,size(ytest,2))).^2);
a3 = (2*repmat(neg_parameter(:,3),1,size(ytest,2)));
a4 = -0.5-repmat(neg_parameter(:,3),1,size(ytest,2));
lastterm = (1+a1.*a2./a3).^(a4);
a5 = repmat(neg_parameter(:,6),1,1991);

prediction(2,:) = prod(a5.*lastterm)*neg_prior;


prediction(3,:) = (prediction(1,:)>prediction(2,:));
rec = (prediction(3,:)==ytest);
length(find(rec==1))

confusion = zeros(2,2);
confusion(1,1) = length(find(ytest==0 & prediction(3,:)==0));
confusion(1,2) = length(find(ytest==0 & prediction(3,:)==1));
confusion(2,1) = length(find(ytest==1 & prediction(3,:)==0));
confusion(2,2) = length(find(ytest==1 & prediction(3,:)==1));

mistake = find(ytest==0 & prediction(3,:)==1);
for i = 1:3
	temp = Xtest(:,mistake(i));
	recon = Q * temp;
	resh = reshape(recon, [28, 28]);
	subplot(1,3,i), imagesc(resh), title(['test data ' int2str(mistake(i))]);
	prediction(1,mistake(i))
	prediction(2,mistake(i))
end


%diff = abs(prediction(1,:)-prediction(2,:));
diff = abs(abs(prediction(1,:)-prediction(2,:))./(prediction(1,:)+prediction(2,:)));
[~, order] = sort(diff,'ascend');
for i = 1:3
	temp = Xtest(:,order(i));
	recon = Q * temp;
	resh = reshape(recon, [28, 28]);
	subplot(1,3,i),imagesc(resh),title(['test data ' int2str(order(i))]);
	q1 = prediction(1,order(i))
	q2 = prediction(2,order(i))
	q1/(q1+q2)
end
