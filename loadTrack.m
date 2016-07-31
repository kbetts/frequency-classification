function y = loadTrack(fileName,num,time,sampFreq,sampReduce)
	
	y2 = wavread(fileName);
	L = floor(length(y2));
	
	n = (time*sampFreq);
	
	y = zeros(num,n/sampReduce);
	for j=1:num
		% psuedo-random sampling
		r = randi(L-(n+1),1);
		y3 = y2(r:r+(n-1),1)';
		for i=1:length(y)
			y(j,i) = y3(1,sampReduce*i);
		end
	end
	
end