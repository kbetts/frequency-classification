function plot_histo(resultVecs,baseName,fig)
	
	sort1 = sort(resultVecs(:,1));
	sort2 = sort(resultVecs(:,2));
	sort3 = sort(resultVecs(:,3));
	
	xMax = ceil(max(max(resultVecs)));
	xMin = floor(min(min(resultVecs)));

	figure(fig)
	subplot(1,3,1), hist(sort1,30); 
	set(gca,'Xlim',[xMin xMax]), title(baseName(1,:));
	subplot(1,3,2), hist(sort2,30); 
	set(gca,'Xlim',[xMin xMax]), title(baseName(2,:));
	subplot(1,3,3), hist(sort3,30);
	set(gca,'Xlim',[xMin xMax]), title(baseName(3,:));
	
end