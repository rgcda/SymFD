function SFDplotDetectedBlobs( hAxes, widthMapSize,widthMapColor, cmap )
%SFDplotDetectedBlobs

    detectedWidthIdxs = find(~isnan(widthMapSize));
    widthMapColorMin = min(widthMapColor(:));
    if isnan(widthMapColorMin)
        widthMapColorMin = 0;
    end
    widthMapColorMax = max(widthMapColor(:));
    if isnan(widthMapColorMax)
        widthMapColorMax = widthMapColorMin + 1;
    end
    widthMapColor = (widthMapColor-widthMapColorMin)./(widthMapColorMax - widthMapColorMin);
    widthMapColor(isnan(widthMapColor)) = 0;
    widthMapColorIdxs = gray2ind(widthMapColor,256);
    
    linewidth = 1;
    
    for k = 1:length(detectedWidthIdxs)
        idx = detectedWidthIdxs(k);
        r = widthMapSize(idx)/2;
        color = cmap(widthMapColorIdxs(idx)+1,:);
        [y,x] = ind2sub(size(widthMapSize),idx);
        pos = [[x,y] - r,2*r,2*r];
        rectangle('Position',pos,'Curvature',[1 1],'EdgeColor',color,'LineWidth',linewidth);   
        line([x-r,x+r],[y,y],'Color',color,'LineWidth',linewidth);
        line([x,x],[y+r,y-r],'Color',color,'LineWidth',linewidth);
    end
end

% Written by Rafael Reisenhofer
%
% Part of SymFD Toolbox v 1.1
% Built on November 7, 2018
% Published under the MIT License
