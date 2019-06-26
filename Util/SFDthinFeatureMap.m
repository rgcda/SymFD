function thinnedFeatureMap = SFDthinFeatureMap(featureMap,thinningThreshold,minComponentLength,feature)
% SFDthinFeatureMap Threshold and thin the results SFDgetFeatures
% 
% Usage:
% 
%  thinnedFeatureMap = SFDthinFeatureMap(featureMap,thinningThreshold,minComponentLength,feature)
% 
% 
% See also: SFDgetFeatures 
    if strcmp(feature,'edges') || strcmp(feature,'ridges')
        thinnedFeatureMap = bwmorph(featureMap > thinningThreshold,'thin',Inf);
        components = bwconncomp(thinnedFeatureMap);
        for k = 1:components.NumObjects
            if length(components.PixelIdxList{k}) < minComponentLength
                thinnedFeatureMap(components.PixelIdxList{k}) = 0;                
            end
        end
    elseif strcmp(feature,'blobs')
        s = regionprops(featureMap>thinningThreshold,'centroid');
        idxs = round(reshape([s.Centroid],2,length(s)));
        thinnedFeatureMap = false(size(featureMap));
        thinnedFeatureMap(sub2ind(size(featureMap),idxs(2,:),idxs(1,:))) = true;
        %thinnedFeatureMap = imregionalmax(featureMap,26).*(featureMap>thinningThreshold);
    end
end

% Written by Rafael Reisenhofer
%
% Part of SymFD Toolbox v 1.1
% Built on November 7, 2018
% Published under the MIT License