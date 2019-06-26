classdef (Abstract) SFDGeneratorHighpassVsHighpass < SFDGeneratorSeparable2D & SFDBlobDetector
%SFDGeneratorHighpassVsHighpass

    properties
        symmetry; %from SFDDetector
        blobIntegral; %from SFDBlobDetector
        blobIntegralReferenceWidth; %from SFDBlobDetector
        
    end
    methods (Abstract)
        values = evaluateHighpass(obj,X); %evaluate highpass
    end
    methods
        function obj = SFDGeneratorHighpassVsHighpass(maxFeatureWidth,maxFeatureLength,symmetry,frequencyCone)
            obj = obj@SFDGeneratorSeparable2D(maxFeatureWidth,maxFeatureLength,symmetry,symmetry,frequencyCone);
        end
        
        function values = evaluateX1D(obj,X)
            values = obj.evaluateHighpass(X);
        end
        function values = evaluateY1D(obj,Y)
            if obj.symmetry == SFDConstants.ODD
                values = obj.evaluateLowpass(Y);
            else
                values = obj.evaluateHighpass(Y);
            end
        end
    end
    %% getter and setter
    methods
        function obj = set.symmetry(obj,val)
            obj.symmetryX = val;
            obj.symmetryY = val;
        end
        function val = get.symmetry(obj)
            val = obj.symmetryX;
        end
        function val = get.blobIntegral(obj)
            val = (obj.integralX((floor(end/2)+1):end)-obj.integralX((floor(end/2)):-1:1)).*(obj.integralY((floor(end/2)+1):end)-obj.integralY((floor(end/2)):-1:1));
        end
        function val = get.blobIntegralReferenceWidth(obj)
            val = obj.integralXWidth;
        end
    end
end

% Written by Rafael Reisenhofer
%
% Part of SymFD Toolbox v 1.1
% Built on November 7, 2018
% Published under the MIT License

