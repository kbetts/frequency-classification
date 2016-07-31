%% Kellen Betts  |  kellen.betts@gmail.com
%% Date: 120314  |  Version: 1.0
%% Description: 	Time-freq. analysis (Gabor) and linear discrimination
%%					analysis (SVD/LDA) to classify music... machine learning.

clear all; close all;
tic

experArray = ['test3'];
%experArray = ['test1'; 'test2'; 'test3'];
[numExper dummy] = size(experArray);

numTrials = 1;

for outer=1:numExper
	for inner=1:numTrials

%%===========================================================     initialization

experiment = experArray(outer,:)

switch experiment
case 'test1'
	baseName = ['alef'; 'mrly'; 'ofsp'];
case 'test2'
	baseName = ['cold'; 'dmbd'; 'phsh'];
case 'test3'
	baseName = ['clas'; 'rock'; 'tech'];
end

sample = 20;			% number of tracks per training group
test = 10;				% number of tracks per test group

featureArray = 20;
%featureArray = [1; 2; 4; 6; 8; 10; 20; 30; 40; 50; 60];
successRate = zeros(length(featureArray),1);

% track params
time = 5;			% track length [sec]
sampFreq = 8000;	% freq output from Audacity
sampReduce = 4;
n = (time*sampFreq)/sampReduce;

% Gabor params
filterType = 'Gaussian';
width = 500;
slices = 100;

%%=============================================================     training set

m = sample;

% import data
Y1 = zeros(3*m,n);
for j=1:3
	fileName = strcat('data/',baseName(j,:));
	Y1(j*m-(m-1):j*m,:) = loadTrack(fileName,sample,time,sampFreq,sampReduce);
end

% gabor transform (or fourier)
%Y2 = zeros(3*m,n);
Y2 = zeros(3*m,n*slices);
for j=1:(3*m)
	%[Y2(j,:) ks] = fourier(Y1(j,:),sampFreq,'reduced');
	[Y2(j,:) ks t] = gabor(Y1(j,:),sampFreq,filterType,width,slices,'full');		
end

%save('data/Y2.mat','Y2');

yPlot1 = [Y1(1,:); Y1(m+1,:); Y1(2*m+1,:)];
plot_freq(yPlot1,sampFreq/sampReduce,baseName,'original',1);

clear Y1;

%%=================================================================     test set

m = test;

% import data
Y3 = zeros(3*m,n);
for j=1:3
	fileName = strcat('data/',baseName(j,:));
	Y3(j*m-(m-1):j*m,:) = loadTrack(fileName,test,time,sampFreq,sampReduce);
end

% gabor transform (or fourier)
%Y4 = zeros(3*m,n);
Y4 = zeros(3*m,n*slices);
for j=1:(3*m)
	%[Y4(j,:) ks2] = fourier(Y3(j,:),sampFreq,'reduced');
	[Y4(j,:) ks2 t2] = gabor(Y3(j,:),sampFreq,filterType,width,slices,'full');		
end

save('data/Y4.mat','Y4');

clear Y3 Y4 ks2 t2;

%%=================================================================     LDA loop

for j=1:length(featureArray)
	
	features = featureArray(j);

	%load('data/Y2.mat');

	[U,S,V,w,resultVecs,resultMeans] = trainer(Y2,features);
	
	clear Y2;
	load('data/Y4.mat');

	testMat = V'*Y4';		% SVD projection
	pval = (w'*testMat)';	% LDA projection

	% classify result
	differ = zeros(length(pval),3);
	classify = zeros(length(pval),1);
	trueClass = [ones(test,1); 2*ones(test,1); 3*ones(test,1)];
	errorCount = 0;
	for i=1:length(pval)
		differ(i,1) = abs(pval(i)-resultMeans(1));
		differ(i,2) = abs(pval(i)-resultMeans(2));
		differ(i,3) = abs(pval(i)-resultMeans(3));
		[minVal classify(i)] = min(differ(i,:));
		if classify(i) ~= trueClass(i)
			errorCount = errorCount + 1;
		end
	end
	errorCount;
	successRate(j) = (1 - errorCount/(3*test)) *100;
	
	%clear U V Y4;
	
end

successRate
toc
disp('');

end %inner
end	%outer

%%===================================================================     output

%yPlot2 = [Y2(1,:); Y2(sample+1,:); Y2(2*sample+1,:)];
%plot_freq(yPlot2,ks,baseName,'fourier',2);

plot_lda(U,S,V,t,ks,'singVals',baseName,2,1);
plot_lda(U,S,V,t,ks,'princComp',baseName,3,1);
plot_lda(U,S,V,t,ks,'projections',baseName,4,3);
plot_histo(resultVecs,baseName,5);

sig = diag(S);
energy = zeros(length(sig),1);
for j=1:length(energy)
	energy(j) = sum(sig(1:j))/sum(sig);
end
energies = energy(1:features);

%%======================================================================     end
