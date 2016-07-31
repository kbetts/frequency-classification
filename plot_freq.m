function plot_freq(y,a,baseName,plotType,fig)
	
	switch plotType
		
	case 'original'
		
		[m n] = size(y);
		figure(fig);
		for j=1:m
			subplot(3,1,j), plot((1:n)/a,y(j,:));
			set(gca,'Ylim',[-1 1]);
			ylabel('Amplitude');
			title(baseName(j,:));
		end
		xlabel('Time [sec]');
		drawnow;
		
	case 'fourier'
		
		[m n] = size(y);
		figure(fig);
		for j=1:m
			subplot(3,1,j), plot(a,y(j,:));
			set(gca,'Ylim',[0 100]);
			ylabel('fft(y)');
			title(baseName(j,:));
		end
		xlabel('Freq. [\omega]');
		drawnow;
		
	end
end