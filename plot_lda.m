function plot_lda(U,S,V,t,ks,plotType,baseName,fig,num)

	[m n] = size(U);
	n = n/3;			% group size

	switch plotType
		
	case 'singVals'
		% plot singular values
		figure(fig);
		subplot(2,1,1), plot(diag(S),'bo'), title('Singular values');
		subplot(2,1,2), semilogy(diag(S),'bo'), title('Singular values (log)');
		
	case 'princComp'
		% plot principal components
		V = V';
		V2 = [];
		L = length(V);
		l = length(ks);
		for j=1:L/l
			V2 = [V2; V(num,j*l-l+1:j*l)];
		end
		whos
		plot_spectro(t,ks,V2,strcat('Princ. Comp. (',num2str(num),')'),fig);
		
	case 'projections'
		% plot projections
		figure(fig)
		for j=1:num
			subplot(num,3,3*j-2), plot(1:n,U(1:n,j),'ko-');
			subplot(num,3,3*j-1), plot(n+1:n+n,U(n+1:n+n,j),'ko-');
			subplot(num,3,3*j), plot(n+n+1:n+n+n,U(n+n+1:end,j),'ko-');
		end
		subplot(3,3,1), title(baseName(1,:));
		subplot(3,3,2), title(baseName(2,:));
		subplot(3,3,3), title(baseName(3,:));
	
	end
end