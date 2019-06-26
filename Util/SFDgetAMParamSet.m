function [paramSet,nScales,nOris] = SFDgetAMParamSet(maxFeatureWidth,minFeatureWidth,nOrientations,scalesPerOctave,orientationOperator)
%SFDgetAMParamSet Computes a parameter set that specifies a system of
%symmetric alpha molecules.
%
%Usage:
%
% [paramSet,nScales,nOris] = SFDgetAMParamSet(maxFeatureWidth,minFeatureWidth,nOrientations,scalesPerOctave,orientationOperator);
%
%Input:
%
%         maxFeatureWidth: Maximum expected width of the respective feature in pixels.
%         minFeatureWidth: Minimal expected width of the respective feature in pixels.
%           nOrientations: Number of differently oriented symmetric moelcules per scale.
%         scalesPerOctave: Number of scales in the alpha molecule system per octave. 
%     orientationOperator: 'rot' (rotation operator) or 'shear' (shear operator) 
%                
%Output:
%
%                paramSet: Structure containing a set of parameters that specify an alpha
%                          molecule sytem.
%                 nScales: Number of scales in the system.
%                   nOris: Number of orientations in the system.
%
%Example:
%
% maxFeatureWidth = 16;
% minFeatureWidth = 2;
% nOrientations = 8;
% scalesPerOctave = 2;
% orientationOperator = 'rot';
%
% [paramSet,nScales,nOris] = SFDgetAMParamSet(maxFeatureWidth,minFeatureWidth,nOrientations,scalesPerOctave,orientationOperator);
%
%See also: SFDgetFeatureDetectionSystem, CAMgetAMSystem
    maxScaleFactor = maxFeatureWidth/minFeatureWidth;
    
    scaleFactor = 1;
        
    if strcmp(orientationOperator,'rot')    
        orientationParameters = linspace(-pi/2,pi/2,nOrientations+1);
        orientationParameters = orientationParameters(1:(end-1))';
        nOris = nOrientations;
        paramSet.scaleFactors = [];  
        paramSet.orientations = [];
        nScales = 0;
        while (scaleFactor <= maxScaleFactor)    
            nScales = nScales + 1;    
            paramSet.scaleFactors = cat(1,paramSet.scaleFactors,scaleFactor*ones(nOrientations,1));
            paramSet.orientations = cat(1,paramSet.orientations,orientationParameters);
            scaleFactor = 2^(1/scalesPerOctave)*scaleFactor;
        end
        paramSet.generators = ones(nOris*nScales,1);
    elseif strcmp(orientationOperator,'shear')
        orientationParameters = ((-floor(nOrientations/4)-1):(floor(nOrientations/4)+1))';
        orisPerGenerator = length(orientationParameters);
        nOris = orisPerGenerator * 2;
        if orisPerGenerator > 1
            orientationParameters = atan(orientationParameters/floor(nOrientations/4));
        end
        paramSet.scaleFactors = [];  
        paramSet.orientations = [];
        paramSet.generators = [];
        nScales = 0;
        while (scaleFactor <= maxScaleFactor)   
            nScales = nScales + 1;
            %first cone
            paramSet.scaleFactors = cat(1,paramSet.scaleFactors,scaleFactor*ones(orisPerGenerator,1));
            paramSet.orientations = cat(1,paramSet.orientations,orientationParameters);
            paramSet.generators = cat(1,paramSet.generators,ones(orisPerGenerator,1));
            %second cone
            paramSet.scaleFactors = cat(1,paramSet.scaleFactors,scaleFactor*ones(orisPerGenerator,1));
            paramSet.orientations = cat(1,paramSet.orientations,-orientationParameters);
            paramSet.generators = cat(1,paramSet.generators,2*ones(orisPerGenerator,1));
            scaleFactor = 2^(1/scalesPerOctave)*scaleFactor;
        end
    end   

end

% Written by Rafael Reisenhofer
%
% Part of SymFD Toolbox v 1.1
% Built on November 7, 2018
% Published under the MIT License
