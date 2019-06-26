classdef (Abstract) SFDGeneratorHighpassVsLowpass < SFDGeneratorSeparable2D & SFDRidgeDetector & SFDEdgeDetector
%SFDGeneratorHighpassVsLowpass

    properties (Constant)
        initialSymmetryY = SFDConstants.NONE;
    end
    properties
        symmetry; %from SFDDetector
        halfSpaceIntegral; %from SFDEdgeDetector
        ridgeIntegral; %from SFDRidgeDetector
        ridgeIntegralReferenceWidth; %from SFDRidgeDetector
    end
    methods (Abstract)
        values = evaluateHighpass(obj,X); %evaluate highpass
        values = evaluateLowpass(obj,Y); %evaluate lowpass
    end
    methods
        function obj = SFDGeneratorHighpassVsLowpass(maxFeatureWidth,maxFeatureLength,symmetry,frequencyCone)
            obj = obj@SFDGeneratorSeparable2D(maxFeatureWidth,maxFeatureLength,symmetry,SFDConstants.NONE,frequencyCone);
        end
        
        function values = evaluateX1D(obj,X)
            values = obj.evaluateHighpass(X);
        end
        function values = evaluateY1D(obj,Y)
            values = obj.evaluateLowpass(Y);
        end
    end
    %% getter and setter
    methods
        function obj = set.symmetry(obj,val)
            obj.symmetryX = val;
        end
        function val = get.symmetry(obj)
            val = obj.symmetryX;
        end
        function val = get.halfSpaceIntegral(obj)
            val = obj.integralX(floor(end/2)+1);
        end
        function val = get.ridgeIntegral(obj)
            val = obj.integralX;
        end
        function val = get.ridgeIntegralReferenceWidth(obj)
            val = obj.integralXWidth;
        end
    end
    
end

% Written by Rafael Reisenhofer
%
% Part of SymFD Toolbox v 1.1
% Built on November 7, 2018
% Published under the MIT License

