%% select and load image
imgName = 'monarch.bmp';
img = double(rgb2gray(imread(imgName)));

rows = size(img,1);
cols = size(img,2);

%% specify the feature that is to be detected
feature = 'ridges'; %'edges', 'ridges' or 'blobs'

%% specify the expected shapes of the feature
maxFeatureWidth = 15; %positive real value, measured in pixels; locally, an edge has a width of n pixels if it separates two regions of different contrast that are each 10 pixels wide
maxFeatureLength = 10; %positive real value, measured in pixels; an edge as a local length of n pixels, if n pixel long segments are approx. linear
minFeatureWidth = 2; %positive real value, measured in pixels

%% properties of the ridge measure
minContrast = 4; %positive real value; soft-thresholding parameter that decimates noise and specifies the minimal contrast a feature has to have to be detected

%% properties of the alpha molecule system
alpha = 0.2; %real value between 0 and 1; alpha parameter, determines the degree of anistrophy with respect to scaling
nOrientations = 8; %integer; number of different orientations
scalesPerOctave = 2; %integer; if scalesPerOctave is n, the frequency of a molecule in the molecules system doubles after n scales 
evenOddScaleOffset = 1; %real value
generator = 'SFDMexicanHatVsGauss'; %name of the generator; can be any of the classes defined in the SymFD Generators folder
orientationOperator = 'rot'; %'shear' or 'rot'; specifies the operator that is used for changing the orienation


%% post-processing
thinningThreshold = 0.1; %real-value between 0 and 1; threshold for thinning
minComponentLength = 5;
maxFeatureHeight = 0;  %only ridges with negative contrast


%% compute moleculeSystem
moleculeSystem = SFDgetFeatureDetectionSystem(rows,cols,feature,maxFeatureWidth,maxFeatureLength,minFeatureWidth,alpha,nOrientations,scalesPerOctave,evenOddScaleOffset,generator,orientationOperator);

%% detect features
[featureMap,orientationMap,heightMap,widthMap] = SFDgetFeatures(img,moleculeSystem,minContrast,'all',[],maxFeatureHeight);

featureMapThinned = SFDthinFeatureMap(featureMap,thinningThreshold,minComponentLength,feature);
orientationMapThinned = orientationMap;
heightMapThinned = heightMap;
widthMapThinned = widthMap;
orientationMapThinned(~featureMapThinned) = NaN;
heightMapThinned(~featureMapThinned) = NaN;
widthMapThinned(~featureMapThinned) = NaN;


SFDplotMap(img,'auto','feature','Input');
SFDplotMap(featureMap,'auto','feature','Ridge Measure',img);
SFDplotMap(orientationMapThinned,'auto','angle','Tangent Directions',img);
SFDplotMap(heightMapThinned,'auto','height','Feature Heights',img);
SFDplotMap(widthMapThinned,'auto','width','Feature Widths',img);

% Written by Rafael Reisenhofer
%
% Part of SymFD Toolbox v 1.1
% Built on November 7, 2018
% Published under the MIT License