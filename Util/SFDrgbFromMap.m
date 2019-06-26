function [mapRgb,cmap] = SFDrgbFromMap(map,colorType,minMax,img)
%SFDrgbFromMap

    overlay = exist('img','var');
    if strcmpi(minMax,'auto')
        maxVal = max(map(:));
        minVal = min(map(:));
    else
        maxVal = minMax(2);
        minVal = minMax(1);
    end
    if strcmpi(colorType,'red')
        cmap = ones(256,3);
        cmap(:,1) = cmap(:,1) + (1 - cmap(:,1)).*linspace(0,1,256)';
        cmap(:,2) = cmap(:,2) - cmap(:,2).*linspace(0,1,256)';
        cmap(:,3) = cmap(:,3) - cmap(:,3).*linspace(0,1,256)';
        colorMapIdxs = gray2ind(max(0,map-minVal)/(maxVal - minVal),256);
    end
    if strcmpi(colorType,'angle')
        ncmap = 181;
        cmap = squeeze(hsv2rgb(cat(3,0:1/(ncmap-1):1,ones(1,ncmap),ones(1,ncmap))));
        colorMapIdxs = uint16(round(map));
    end
    if strcmpi(colorType,'parula')    
        cmap = parula(256); 
        colorMapIdxs = uint16(gray2ind(max(0,map-minVal)/(maxVal - minVal),256));
    end
    

    if sum(isnan(map(:))) > 0
        colorMapIdxs = colorMapIdxs + 1;
        colorMapIdxs(isnan(map)) = 0;
        mapRgb = ind2rgb(colorMapIdxs,[[0,0,0];cmap]);
    else
        mapRgb = ind2rgb(colorMapIdxs,cmap);        
    end
    if overlay
        if strcmpi(colorType,'red')
            map = double(map);
            img = (mat2gray(img) + 2)/3;
            mask = map>0;
            tmpR = img + (mask - img) .* (map);
            tmpG = img -img.*map;
            tmpB = img -img.*map;

            mapRgbR = img;
            mapRgbG = img;
            mapRgbB = img;

            mapRgbR(mask) = tmpR(mask);
            mapRgbG(mask) = tmpG(mask);
            mapRgbB(mask) = tmpB(mask);

            mapRgb = cat(3,mapRgbR,mapRgbG,mapRgbB);
        else
            help1 = cat(3,map,map,map);
            help2 = cat(3,zeros(size(img)),zeros(size(img)),(mat2gray(img)+2)/3);
            help2 = SFDhsl2rgb(help2);
            mapRgb(isnan(help1)) = help2(isnan(help1));
        end
    end

end

% Written by Rafael Reisenhofer
%
% Part of SymFD Toolbox v 1.1
% Built on November 7, 2018
% Published under the MIT License