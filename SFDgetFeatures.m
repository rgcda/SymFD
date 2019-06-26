function [featureMap,orientationMap,heightMap,widthMap] = SFDgetFeatures(img,moleculeSystem,minContrast,scalesUsedForMostSignificantSearch,minHeight,maxHeight)
%SFDgetFeatures Detects features and approximates feature heights and feature widths in an input image using systems of symmetric molecules. 
%
%Usage (optional parameters are enclosed in angle brackets):
%
% [featureMap,orientationMap,heightMap,widthMap] = SFDgetFeatures(img,moleculeSystem,minContrast,<scalesUsedForMostSignificantSearch>,<minHeight>,<maxHeight>)
%
%Input:
%   
%                   	                      img: Grayscale input image.
%                                  moleculeSystem: Structure containing a system of odd- and even-symmetric alpha molecules. 
%                                     minContrast: Positive real value. Soft-thresholding parameter that specifies the minimal contrast of the detected features.
%                                                  Should be chosen large in case of severe noise.
%   scalesUsedForMostSignificantSearch (optional): 'all' (default), 'highest', 'lowest', or vector containing specific scales. Specifies the scales which are used to find
%                                        the most significant scale.
%                            minHeight (optional): -Inf (default), or any real value. Specifies the minimal height of a feature.
%                            maxHeight (optional): Inf (default) or any real value. Specifies the maximal height of a feature.              
%                
%Output:
%
%                featureMap: Map of the respective edge, ridge, or blob measure for each pixel. 
%            orientationMap: Map containing estimates of the local tangent directions of a feature. 
%                 heightMap: Map containing estimates of the local heights of a feature. 
%                  widthMap: Map containing estimates of the local widths of a feature. 
%
%Example:
%
% imgName = 'monarch.bmp';
% img = double(rgb2gray(imread(imgName)));
% 
% rows = size(img,1);
% cols = size(img,2);
% 
% feature = 'edges'; 
% 
% maxFeatureWidth = 20; 
% maxFeatureLength = 10;
% minFeatureWidth = 4; 
% 
% minContrast = 4; 
% 
% alpha = 0.5; 
% nOrientations = 8; 
% scalesPerOctave = 2;
% evenOddScaleOffset = 1; 
% generator = 'SFDMexicanHatVsGauss';
% orientationOperator = 'rot';
% 
% moleculeSystem = SFDgetFeatureDetectionSystem(rows,cols,feature,maxFeatureWidth,maxFeatureLength,minFeatureWidth,alpha,nOrientations,scalesPerOctave,evenOddScaleOffset,generator,orientationOperator);
% [featureMap,orientationMap,heightMap,widthMap] = SFDgetFeatures(img,moleculeSystem,minContrast);
%
%
%See also: SFDgetFeatureDetectionSystem, SFDthinFeatureMap, SFDrgbFromMap, SFDplotMap, SFDplotDetectedBlobs

    if (nargin < 3), minContrast = (max(img(:)) - min(img(:)))/50; end
    if (nargin < 4), scalesUsedForMostSignificantSearch = 'all'; end
    if (nargin < 5), minHeight = -Inf; end
    if (nargin < 6), maxHeight = Inf; end

   
    coeffs = real(CAMdec(img,moleculeSystem));  
    coeffs = reshape(coeffs,size(coeffs,1),size(coeffs,2),moleculeSystem.nOris,moleculeSystem.nScales*2);
    
    coeffsSym1 = coeffs(:,:,:,1:moleculeSystem.nScales);
    coeffsSym2 = coeffs(:,:,:,(moleculeSystem.nScales+1):end);
    
    if ischar(scalesUsedForMostSignificantSearch)
        switch scalesUsedForMostSignificantSearch
            case 'all'
                scalesUsedForMostSignificantSearch = 1:moleculeSystem.nScales;
            case 'highest'
                scalesUsedForMostSignificantSearch = moleculeSystem.nScales;
            case 'lowest'
                scalesUsedForMostSignificantSearch = 1;
            otherwise
                warning('scalesUsedForMostSignificantSearch string not recognized, default value "all" is applied');
                scalesUsedForMostSignificantSearch = 1:moleculeSystem.nScales;                    
        end
    end
    orientationOperatorIsShear = strcmp(moleculeSystem.orientationOperator,'shear');

    mostSignificant = abs(coeffsSym1(:,:,:,scalesUsedForMostSignificantSearch));
    if orientationOperatorIsShear
        mostSignificant(:,:,[1,end/2,(end/2)+1,end],:) = 0; %exclude more than 45 degree shears
    end
    [~,maxMostSignificant] = max(reshape(mostSignificant,size(mostSignificant,1),size(mostSignificant,2),size(mostSignificant,3)*size(mostSignificant,4)),[],3);
    mostSignificantOris = mod(maxMostSignificant-1,moleculeSystem.nOris)+1;
    mostSignificantScales = scalesUsedForMostSignificantSearch(fix((maxMostSignificant-1)/moleculeSystem.nOris)+1);    
    
    orientationMap = zeros(size(img,1),size(img,2));        
    heightMap = zeros(size(img,1),size(img,2));
    widthMap = zeros(size(img,1),size(img,2));
    featureMap = ones(size(widthMap));
    
    
    if strcmp(moleculeSystem.feature,'ridges')
        [heightMap,widthMap] = SFDgetHeightAndWidthMap((coeffsSym1),uint16(mostSignificantOris),uint16(mostSignificantScales),moleculeSystem.generators{1}.ridgeIntegral,moleculeSystem.generators{1}.ridgeIntegralReferenceWidth,moleculeSystem.moleculeWidths(1:(end/2)),uint16(find(strcmp(moleculeSystem.feature,{'edges','ridges','blobs'}))));
        orientationMap = SFDgetOrientationMap(abs(coeffsSym1),uint16(mostSignificantOris),uint16(mostSignificantScales),uint16(orientationOperatorIsShear));
        featureMap = SFDgetRidgeMap(coeffsSym1,abs(coeffsSym2),uint16(mostSignificantOris),uint16(mostSignificantScales),minContrast,moleculeSystem.generators{1}.ridgeIntegral,moleculeSystem.generators{1}.ridgeIntegralReferenceWidth,widthMap,moleculeSystem.moleculeWidths(1:(end/2)),heightMap);
    end
        
    if strcmp(moleculeSystem.feature,'edges')
        [heightMap,widthMap] = SFDgetHeightAndWidthMap((coeffsSym1),uint16(mostSignificantOris),uint16(mostSignificantScales),moleculeSystem.generators{1}.halfSpaceIntegral,0,moleculeSystem.moleculeWidths(1:(end/2)),uint16(find(strcmp(moleculeSystem.feature,{'edges','ridges','blobs'}))));
        orientationMap = SFDgetOrientationMap(coeffsSym1,uint16(mostSignificantOris),uint16(mostSignificantScales),uint16(orientationOperatorIsShear));
        featureMap = SFDgetEdgeMap(coeffsSym1,abs(coeffsSym2),uint16(mostSignificantOris),uint16(mostSignificantScales),minContrast,moleculeSystem.generators{1}.halfSpaceIntegral);
    end
    
    if strcmp(moleculeSystem.feature,'blobs')
        [heightMap,widthMap] = SFDgetHeightAndWidthMap((coeffsSym1),uint16(mostSignificantOris),uint16(mostSignificantScales),moleculeSystem.generators{1}.blobIntegral,moleculeSystem.generators{1}.blobIntegralReferenceWidth,moleculeSystem.moleculeWidths(1:(end/2)),uint16(find(strcmp(moleculeSystem.feature,{'edges','ridges','blobs'}))));
        featureMap = SFDgetBlobMap(coeffsSym1,abs(coeffsSym2),uint16(mostSignificantOris),uint16(mostSignificantScales),minContrast,moleculeSystem.generators{1}.blobIntegral,moleculeSystem.generators{1}.blobIntegralReferenceWidth,widthMap,moleculeSystem.moleculeWidths(1:(end/2)),heightMap);
    end
    if minHeight > -Inf
        featureMap(heightMap < minHeight) = 0;
    end
    if maxHeight < Inf
        featureMap(heightMap > maxHeight) = 0;
    end
    helpIndexes = featureMap<eps;
    orientationMap(helpIndexes) = NaN;
    widthMap(helpIndexes) = NaN;
    heightMap(helpIndexes) = NaN;
end

% Written by Rafael Reisenhofer
%
% Part of SymFD Toolbox v 1.1
% Built on November 7, 2018
% Published under the MIT License