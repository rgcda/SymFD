classdef SFDMexicanHatVsMexicanHat < SFDGeneratorHighpassVsHighpass
%SFDMexicanHatVsMexicanHat    

    properties (Constant)
        initialSymmetryX = SFDConstants.EVEN;
        initialSymmetryY = SFDConstants.NONE;
    end
    methods
        function obj = SFDMexicanHatVsMexicanHat(maxFeatureWidth,maxFeatureLength,symmetry,frequencyCone)
            obj = obj@SFDGeneratorHighpassVsHighpass(maxFeatureWidth,maxFeatureLength,symmetry,frequencyCone);
        end
        function values = evaluateHighpass(obj,X)
            values = (1i.*X).^2.*exp(-X.^2 / 2 );
        end
        function values = evaluateLowpass(obj,Y)
            values = exp(-Y.^2 / 2 );
        end
    end
end

% Written by Rafael Reisenhofer
%
% Part of SymFD Toolbox v 1.1
% Built on November 7, 2018
% Published under the MIT License