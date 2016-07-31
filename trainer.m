function [U,S,V,w,resultVecs,resultMeans] = trainer(Y,features)

%%======================================================================     SVD

[rows cols] = size(Y);
n = rows/3;

% reduced SVD
[U,S,V] = svd(Y,'econ');

% principal components
groups = S*U';
group1 = groups(1:features,1:n);
group2 = groups(1:features,n+1:n+n);
group3 = groups(1:features,n+n+1:end);
V = V(:,1:features);

%%======================================================================     LDA

% means
mn1 = mean(group1,2);
mn2 = mean(group2,2);
mn3 = mean(group3,2);
mnAll = mean([mean(mn1),mean(mn2),mean(mn3)]);

% within class scatter
Sw = 0;
for i=1:n
	Sw = Sw + (group1(:,i)-mn1)*(group1(:,i)-mn2)';
end
for i=1:n
	Sw = Sw + (group2(:,i)-mn2)*(group2(:,i)-mn2)';
end
for i=1:n
	Sw = Sw + (group3(:,i)-mn3)*(group3(:,i)-mn3)';
end

% between class scatter
Sb = (mn1-mnAll)*(mn1-mnAll)' + (mn2-mnAll)*(mn2-mnAll)' + (mn3-mnAll)*(mn3-mnAll)';

% solve eigen prob
[V2,D] = eig(Sb,Sw);
[lambda,ind] = max(abs(diag(D)));
w = V2(:,ind);
w = w/norm(w,2);

% project results
v1 = w'*group1;
v2 = w'*group2;
v3 = w'*group3;
resultVecs = [v1', v2', v3'];

% means of groups
resultMeans = [mean(v1); mean(v2); mean(v3)];

%%======================================================================     end
end