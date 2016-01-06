% hw 4.2
load('movies_matlab_matrix.mat');

%%
%{
fromuser = zeros(943,1682);
for i = 1:943
	user_movie = user(i).movie_id;
	user_rating = user(i).rating;
	fromuser(i,user_movie) = user_rating;
end

frommovie = zeros(943,1682);
for i = 1:1682
	movie_user = movie(i).user_id;
	movie_rating = movie(i).rating;
	frommovie(movie_user,i) = movie_rating;
end
%}

%%
inim = zeros(1,20);
iniv = 10*eye(20);

userd = mvnrnd(inim,iniv,943);
movied = mvnrnd(inim,iniv,1682);
cst = 2.5;
rec = zeros(943,20,10);

error = zeros(100,1);
logli = zeros(100,1);

%tic

for ite = 1:100
	lg1 = 0; lg2 = 0; lg3 = 0;
	
	for i = 1:943
		rated = find(fromuser(i,:)~=0); % rated_number*1
		vj = movied(rated,:); % rated_number*20
		former = inv(cst+trace(vj*vj')); %1*1
		temp = repmat((fromuser(i,rated)'),[1 20]); %repmat(rated_number*1,[1 20])
		latter = sum(temp.*vj); % sum((rated_number*20).X(rated_number*20))=>1*20
		userd(i,:) = former*latter;
		
		lg2 = lg2+5*(norm(userd(i,:))^2);
	end
	
	for j = 1:1682
		rated = find(fromuser(:,j)~=0); % rated_number*1
		ui = userd(rated,:); % rated_number*20;
		former = inv(cst+trace(ui*ui')); % 1*1
		temp = repmat(fromuser(rated,j),[1 20]); %repmat(rated_number*1,[1 20]) = rated_number*20
		latter = sum(temp.*ui); % sum((rated_number*20).X(rated_number*20))=>1*20
		movied(j,:) = former*latter;
		
		lg3 = lg3+5*(norm(movied(j,:))^2);
	end
	
	diff = zeros(943,1682);
	multi = userd*movied'; % 943*1682
	for i = 1:943
		for j = 1:1682
			if (fromuser(i,j)~=0)
				diff(i,j) = multi(i,j)-fromuser(i,j);
			end
		end
	end
	lg1 = 2*(norm(diff)^2);
	logli(ite) = -(lg1+lg2+lg3);
	
	errortmp = 0;
	for k = 1:5000
		diff = round(userd(ratings_test(k,1),:)* movied(ratings_test(k,2),:)') - ratings_test(k,3);
		errortmp = errortmp + diff^2;
	end
	error(ite) = sqrt(errortmp/5000);
end

%toc

