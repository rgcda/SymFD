% This script compiles all necessary MEX files. Call this script from the main folder.

cd  Mex
mex SFDgetEdgeMap.cpp
mex SFDgetHeightAndWidthMap.cpp
mex SFDgetOrientationMap.cpp
mex SFDgetRidgeMap.cpp
mex SFDgetCurvatureMap.cpp
mex SFDgetBlobMap.cpp
cd ..

% Written by Rafael Reisenhofer
%
% Part of SymFD Toolbox v 1.1
% Built on November 7, 2018
% Published under the MIT License