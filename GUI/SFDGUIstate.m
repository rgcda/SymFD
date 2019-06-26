classdef SFDGUIstate
%SFDGUIstate
    
    properties
        image
        imageName
        featureMap
        featureMapThinned
        orientationMap
        widthMap
        heightMap
        curvatureMap
        orientationMapThinned
        widthMapThinned
        heightMapThinned
        generator
        orientationOperator
        moleculeSystem
        moleculeSystemIsUpToDate
        feature
        maxFeatureWidth
        maxFeatureLength
        minFeatureWidth
        scalesPerOctave
        nOrientations
        alpha
        currScale
        currOrientation
        minContrast
        evenOddScaleOffset
        scalesUsedForMostSignificantSearch
        overlay
        lastDirData
        lastDirConfig
        showOrientationsWidhtsOrHeightsOrCurvature
        showThinned
        thinningThreshold
        minComponentLength
        onlyPositiveOrNegativeFeatures   
        exportFigureState
    end    
    
end

% Written by Rafael Reisenhofer
%
% Part of SymFD Toolbox v 1.1
% Built on November 7, 2018
% Published under the MIT License

