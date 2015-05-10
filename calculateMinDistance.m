function [x y] = calculateMinDistance(center,datapoints)
% center: m*n - m center points with n dimension
% datapoint: p*n - p points with n dimension
% x: new category information
% y: min dist information
	x = zeros(size(datapoints,1),1);
	y = zeros(size(datapoints,1),1);
	
	for i = 1:size(datapoints,1)
		data = datapoints(i,:);
		repdata = repmat(data,[size(center,1) 1]); % m*n
		diff = center - repdata; % m*n
		dist = sum(diff.*diff,2); % euclidean distance
		y(i) = min(dist);
		x(i) = find(dist==min(dist));
	end
end

