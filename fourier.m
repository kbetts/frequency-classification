function [yts ks] = fourier(y,Fs,dataLength)

	L = length(y)/Fs;
	n = length(y);
	
	k = (2*pi/L)*[0:n/2-1 -n/2:-1];
	ks = fftshift(k);
	%h = abs( k/(2*pi) );
	%hs = abs( ks/(2*pi) );
	
	yt = fft(y);
	yts = real(fftshift(yt));
	
	switch dataLength
	case 'full'
		% as is
	case 'reduced'
		% trim negative spectrum
		ks = ks(n/2+1:end);
		%hs = abs( ks/(2*pi) );
		yts = abs(yts(n/2+1:end));
	end
	
	%plot(ks,yts);
	
end