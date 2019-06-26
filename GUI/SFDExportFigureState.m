classdef SFDExportFigureState
%SFDExportFigureState
    
    properties
        exportFeatureMap=0;
        exportOrientationMap=0;
        exportHeightMap=0;
        exportWidthMap=0;
        exportCurvatureMap=0;
        exportAsOverlay=0;
        exportThinned=0;
        exportType='png';
        exportForPrint=0;
        exportWithColormap=0;
        exportVolume=0;
        exportFolder;
    end  
    
end

% Written by Rafael Reisenhofer
%
% Part of SymFD Toolbox v 1.1
% Built on November 7, 2018
% Published under the MIT License
