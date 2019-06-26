function hFig = SFDplotMap(map,minMax,mapType,titleTxt,img)
%SFDplotMap

    overlay =  exist('img','var');
    colorType = 'parula';
    
    fontsize = 20;
    heightInPx = 500;
    
    if strcmpi(mapType,'feature')
        unit = '';
        if overlay
            colorType = 'red';
        else
            colorType = 'parula';
        end
    end    
    if strcmpi(mapType,'angle')
        colorType = 'angle';
        unit = sprintf('%c', char(176));
    end    
    if strcmpi(mapType,'angleError')
        colorType = 'parula';
        unit = sprintf('%c', char(176));
    end    
    if strcmpi(mapType,'height')
        colorType = 'parula';
        unit = '';
    end
    if strcmpi(mapType,'width')
        colorType = 'parula';
        unit = ' px';
    end
    if strcmpi(mapType,'curv')
        colorType = 'parula';
        unit = '';
    end
    if strcmpi(mapType,'blob')
        colorType = 'parula';
        unit = ' px';
        if size(map,3) > 1
            widthMapSize = map(:,:,1);
            widthMapColor = map(:,:,2);
        else
            widthMapSize = map;
            widthMapColor = map;
        end
    end

    if strcmpi(mapType,'blob')
        map = widthMapColor;
    end
    if strcmpi(minMax,'auto')
        minMax = [floor(min(map(:))*10)/10,ceil(max(map(:))*10)/10];
        minMax(isnan(minMax)) = 0;
        if minMax(1) >= minMax(2)
            minMax(2) = minMax(1) + 1;
        end
    end
    if minMax(2) < max(map(:))
        maxValIsGreater = '>';
    else
        maxValIsGreater = '';
    end
    if minMax(1) > min(map(:))
        minValIsLess = '<';
    else
        minValIsLess = '';
    end
    if overlay
        [imgRgb,cmap] = SFDrgbFromMap(map,colorType,minMax,img);
    else
        [imgRgb,cmap] = SFDrgbFromMap(map,colorType,minMax);
    end

    hFig = figure;image(imgRgb);axis tight;axis equal;axis off;
    hAxes = gca; 
    if strcmpi(mapType,'blob')
        SFDplotDetectedBlobs( hAxes, widthMapSize,widthMapColor, cmap );
    end
    
    colormap(cmap);
    hCol = colorbar;
    
    
    caxis manual;
    caxis([1,size(cmap,1)]);
%     if strcmpi(colorType,'angle')
%         caxis([-90,90]);
%     else        
%         caxis([minMax(1),minMax(2)]);
%     end
    cLimits = caxis;
    if strcmpi(colorType,'angle')
        %set(hCol,'YTick',[-90,0,90],'YTickLabel',{['-90',unit],'0',['90',unit]});
        set(hCol,'YTick',[cLimits(1),(cLimits(2)+cLimits(1))/2,cLimits(2)],'YTickLabel',{['-90',unit],'0',['90',unit]});
    else
        %set(hCol,'YTick',[minMax(1),(minMax(2)+minMax(1))/2,minMax(2)],'YTickLabel',{[minValIsLess,num2str(minMax(1)),unit],[num2str((minMax(2)+minMax(1))/2),unit],[maxValIsGreater,num2str(minMax(2)),unit]});
        set(hCol,'YTick',[cLimits(1),(cLimits(2)+cLimits(1))/2,cLimits(2)],'YTickLabel',{[minValIsLess,num2str(minMax(1)),unit],[num2str((minMax(2)+minMax(1))/2),unit],[maxValIsGreater,num2str(minMax(2)),unit]});
    end

    set(hCol,'fontsize',fontsize);
    
    pos = get(hFig,'Position');
    resizeFactor = heightInPx/pos(4);
    pos(1:2) = pos(1:2)/2;
    pos(3:4) = pos(3:4)*resizeFactor;
    pos(3) = pos(3) + 400;

   set(hFig,'Position',pos,'Units','pixels');
    
    if ~isempty(titleTxt)
        title(titleTxt, 'Interpreter', 'none','fontsize',16);
    end
end

% Written by Rafael Reisenhofer
%
% Part of SymFD Toolbox v 1.1
% Built on November 7, 2018
% Published under the MIT License
