classdef (Abstract) SFDRidgeDetector < SFDDetector
%SFDRidgeDetector

    properties (Abstract)
        ridgeIntegral;
        ridgeIntegralReferenceWidth;
    end   
    
end

% Written by Rafael Reisenhofer
%
% Part of SymFD Toolbox v 1.1
% Built on November 7, 2018
% Published under the MIT License
