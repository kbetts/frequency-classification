function plot_spectro(t,ks,Y,titleName,fig)
	
	hs = abs( ks/(2*pi) );
	
	figure(fig);
	pcolor(t,hs,Y.'), shading interp, colormap(hot);
	set(gca,'Fontsize',[12]), xlabel('Time [sec]'), ylabel('Frequency [Hz]');
	title(titleName);
	drawnow;
	
end