%% load .avi video
videoName = 'A02_test';
videoExt = 'avi';
vid = VideoReader([videoName,'.',videoExt]);

rows = vid.Height;
cols = vid.Width;
nFrames = vid.FrameRate * vid.Duration;

%% specify the feature that is to be detected
feature = 'edges'; %'edges', 'ridges' or 'blobs'

%% specify the expected shapes of the feature
maxFeatureWidth = 25; %positive real value, measured in pixels; locally, an edge has a width of n pixels if it separates two regions of different contrast that are each 10 pixels wide
maxFeatureLength = 10; %positive real value, measured in pixels; an edge as a local length of n pixels, if n pixel long segments are approx. linear

minFeatureWidth = 6; %positive real value, measured in pixels

%% properties of the edge measure
minContrast = 15; %positive real value; soft-thresholding parameter that decimates noise and specifies the minimal contrast a feature has to have to be detected


%% properties of the alpha molecule system
alpha = 0.2; %real value between 0 and 1; alpha parameter, determines the degree of anistrophy with respect to scaling
nOrientations = 16; %integer; number of different orientations
scalesPerOctave = 2; %integer; if scalesPerOctave is n, the frequency of a molecule in the molecules system doubles after n scales 
evenOddScaleOffset = 1; %real value
generator = 'SFDDoG1VsGauss'; %name of the generator; can be any of the classes defined in the SymFD Generators folder
orientationOperator = 'rot'; %'shear' or 'rot'; specifies the operator that is used for changing the orienation

%% post-processing
thinningThreshold = 0.1; %real-value between 0 and 1; threshold for thinning
minComponentLength = 15;

%% compute moleculeSystem (can be re-used for every image)
moleculeSystem = SFDgetFeatureDetectionSystem(rows,cols,feature,maxFeatureWidth,maxFeatureLength,minFeatureWidth,alpha,nOrientations,scalesPerOctave,evenOddScaleOffset,generator,orientationOperator);

%% prepare output videos
videoFeatureMap = VideoWriter([videoName,'_',feature,'_overlay.avi']);
videoFeatureMap.FrameRate = 7;
videoFeatureMap.Quality = 100;
open(videoFeatureMap);

videoOrientations = VideoWriter([videoName,'_',feature,'_orientations_overlay.avi']);
videoOrientations.FrameRate = 7;
videoOrientations.Quality = 100;
open(videoOrientations);

videoCurvature = VideoWriter([videoName,'_',feature,'_curvature_overlay.avi']);
videoCurvature.FrameRate = 7;
videoCurvature.Quality = 100;
open(videoCurvature);


%% detect features
for n = 1:nFrames
    disp(['Processing frame ', num2str(n),' ...']);
    img = readFrame(vid);
    
    [featureMap,orientationMap,heightMap,widthMap] = SFDgetFeatures(img,moleculeSystem,minContrast);

    featureMapThinned = SFDthinFeatureMap(featureMap,thinningThreshold,minComponentLength,feature);
    orientationMapThinned = orientationMap;
    widthMapThinned = widthMap;
    heightMapThinned = heightMap;
    orientationMapThinned(~featureMapThinned) = nan;
    widthMapThinned(~featureMapThinned) = nan;
    heightMapThinned(~featureMapThinned) = nan;
    curvatureMap = SFDgetCurvatureMap(orientationMapThinned);
    
    writeVideo(videoFeatureMap,SFDrgbFromMap(featureMap,'red','auto',img));
    writeVideo(videoOrientations,SFDrgbFromMap(orientationMapThinned,'angle','auto',img));
    writeVideo(videoCurvature,SFDrgbFromMap(curvatureMap,'parula',[0,0.2],img));
    
end
disp(['Saving results as videos ...']);
close(videoFeatureMap);
close(videoOrientations);
close(videoCurvature);

% Written by Rafael Reisenhofer
%
% Part of SymFD Toolbox v 1.1
% Built on November 7, 2018
% Published under the MIT License