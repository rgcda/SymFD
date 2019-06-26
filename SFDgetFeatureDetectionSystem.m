function moleculeSystem = SFDgetFeatureDetectionSystem(rows,cols,feature,maxFeatureWidth,maxFeatureLength,minFeatureWidth,alpha,nOrientations,scalesPerOctave,evenOddScaleOffset,generator,orientationOperator)
%SFDgetFeatureDetectionSystem Returns a system of digital symmetric alpha molecule filters that can be used for feature detection.
%
%Usage:
%
% moleculeSystem = SFDgetFeatureDetectionSystem(rows,cols,feature,maxFeatureWidth,maxFeatureLength,minFeatureWidth,alpha,nOrientations,scalesPerOctave,evenOddScaleOffset,generator,orientationOperator)
%
%Input:
%   
%                    rows: Number of rows in the input image.
%                    cols: Number of cols in the input image.
%                 feature: 'edges', 'ridges', or 'blobs'.
%         maxFeatureWidth: Positive real value. Maximum expected width of the respective feature in pixels.
%         minFeatureWidth: Positive real value. Minimal expected width of the respective feature in pixels.
%                   alpha: Real value in [0,1]. Specifies the degree of anisotropy in the scaling matrix.%                         
%           nOrientations: Integer. Number of differently oriented symmetric moelcules per scale.
%         scalesPerOctave: Integer. Number of scales in the alpha molecule system per octave. 
%      evenOddScaleOffset: Real value. Scaling offset between the used systems of even- and odd-symmetric molecules.
%                          Specified in octaves.
%               generator: String specifying the two-dimensional generator of the used systems of symmetric molecules.
%                          For a list of possible choices, see folder 'SymFD Generators/2D/Separable'. 
%     orientationOperator: 'rot' (rotation operator), or 'shear' (shear operator) 
%                
%Output:
%
%                moleculeSystem: Structure containing the specified systems of digital symmetric molecules. 
%
%Example:
%
% imgName = 'monarch.bmp';
% img = double(rgb2gray(imread(imgName)));
% rows = size(img,1);
% cols = size(img,2);
% 
% feature = 'edges';
% maxFeatureWidth = 20; 
% maxFeatureLength = 10;
% minFeatureWidth = 4; 
% alpha = 0.5;
% nOrientations = 8; 
% scalesPerOctave = 2; 
% evenOddScaleOffset = 1;
% generator = 'SFDMexicanHatVsGauss'; 
% orientationOperator = 'rot'; 
% 
% moleculeSystem = SFDgetFeatureDetectionSystem(rows,cols,feature,maxFeatureWidth,maxFeatureLength,minFeatureWidth,alpha,nOrientations,scalesPerOctave,evenOddScaleOffset,generator,orientationOperator);
%
%See also: SFDgetAMParamSet, CAMgetAMSystem
    if strcmp(feature,'edges')
        symmetry = SFDConstants.ODD;
    elseif strcmp(feature,'ridges')
        symmetry = SFDConstants.EVEN;
    elseif strcmp(feature,'blobs')
        symmetry = SFDConstants.EVEN;
    end
    if strcmp(orientationOperator,'rot')
        generators = {feval(generator,maxFeatureWidth,maxFeatureLength,symmetry,1)};
        oriOperator = CAMrot;

    elseif strcmp(orientationOperator,'shear')
        generators = {feval(generator,maxFeatureWidth,maxFeatureLength,symmetry,1),feval(generator,maxFeatureWidth,maxFeatureLength,symmetry,2)};
        oriOperator = CAMshear;
    end
    nGenerators = length(generators);
    [paramSet,nScales,nOris] = SFDgetAMParamSet(maxFeatureWidth,minFeatureWidth,nOrientations,scalesPerOctave,orientationOperator);
    paramSetOtherSymmetry = paramSet;
    paramSetOtherSymmetry.generators = paramSetOtherSymmetry.generators + nGenerators;
    paramSetOtherSymmetry.scaleFactors = paramSetOtherSymmetry.scaleFactors*2^(-evenOddScaleOffset);

    paramSet.generators = cat(1,paramSet.generators,paramSetOtherSymmetry.generators);
    paramSet.scaleFactors = cat(1,paramSet.scaleFactors,paramSetOtherSymmetry.scaleFactors);
    paramSet.orientations = cat(1,paramSet.orientations,paramSetOtherSymmetry.orientations);

    for k = 1:nGenerators
        generators{end+1} = feval(generator,1,1,~(generators{k}.symmetry-1)+1,generators{k}.frequencyCone);
        generators{end}.initialScalingX = generators{k}.initialScalingX;
        generators{end}.initialScalingY = generators{k}.initialScalingY;
    end

    moleculeSystem = CAMgetAMSystem(rows,cols,alpha,paramSet,generators,oriOperator);
    moleculeSystem.feature = feature;
    moleculeSystem.orientationOperator = orientationOperator;
    moleculeSystem.generator = generator;
    moleculeSystem.maxFeatureWidth = maxFeatureWidth;
    moleculeSystem.minFeatureWidth = minFeatureWidth;
    moleculeSystem.maxFeatureLength = maxFeatureLength;
    moleculeSystem.evenOddScaleOffset = evenOddScaleOffset;


    moleculeSystem.nScales = nScales;
    moleculeSystem.nOris = nOris;
    moleculeSystem.moleculeWidths = zeros(moleculeSystem.nMolecules,1);
    moleculeSystem.moleculeLengths = zeros(moleculeSystem.nMolecules,1);
    moleculeSystem.scalesPerOctave = scalesPerOctave;
    
    for k = 1:moleculeSystem.nMolecules
        moleculeSystem.moleculeWidths(k) = generators{moleculeSystem.paramSet.generators(k)}.generatorWidthX/generators{moleculeSystem.paramSet.generators(k)}.initialScalingX/moleculeSystem.paramSet.scaleFactors(k);
        moleculeSystem.moleculeLengths(k) = generators{moleculeSystem.paramSet.generators(k)}.generatorWidthY/generators{moleculeSystem.paramSet.generators(k)}.initialScalingY/(moleculeSystem.paramSet.scaleFactors(k))^moleculeSystem.alpha;
    end    
end

% Written by Rafael Reisenhofer
%
% Part of SymFD Toolbox v 1.1
% Built on November 7, 2018
% Published under the MIT License
