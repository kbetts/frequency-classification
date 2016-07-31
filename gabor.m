function [yft_all ks slide] = gabor(y,fs,filterType,width,slices,dataLength)
	
	L = length(y)/fs;
	n = length(y);

	% time domain
	t2 = linspace(1/fs,L,n+1);
	t = t2(1:n);

	% freq. domain
	k = (2*pi/L)*[0:n/2-1 -n/2:-1];
	ks2 = fftshift(k);

	% select filter type
	switch filterType
	case 'Gaussian'
		filterFxn = @(a,b) exp( -a * (t-b).^2 );
	case 'MexHat'
		filterFxn = @(a,b) (1/sqrt(a)) * ( 1 - ( (t-b)/a ).^2 ) .* exp( -( ((t-b)/a).^2 )/2 );
	end

	slide = linspace(t(1),t(end),slices);	% slide discritization
	yft_all = [];							% saving spectral data


	% slide the window across time domain
	for j=1:length(slide)

	    f = filterFxn(width,slide(j));

		yf = f.*y;
	    yft = fft(yf);
	
		switch dataLength
		case 'full'
			yft_all = [yft_all,abs(fftshift(yft))];
			ks = ks2;
		case 'reduced'
			% trim negative spectrum
			yft_all = [yft_all,abs(fftshift(yft(n/2+1:end)))];
			ks = ks2(n/2+1:end);
		end

		%plot_run(t,y,g,Sg,ks,Sgt,hertzS,trackTitle,2);

	end

	%plot_spectro(slide,ks,yft_all,'Spectrogram',1);
	
end
