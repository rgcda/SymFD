classdef (Abstract) SFDGeneratorSeparable2D < CAMGenerator
%SFDGeneratorSeparable2D

    properties (Constant)
        integralPrec=14;
    end
    properties (Constant)
        domain = CAMConstants.FREQUENCY;
    end
    properties (Constant,Abstract)
        initialSymmetryX;
        initialSymmetryY;
    end
    properties
        frequencyCone; %1: horizontal cone, 2: vertical cone
        symmetryX; %1 = odd, 2 = even
        symmetryY;
        initialScalingX;
        initialScalingY;
        generatorWidthX; %distance between two first zero crossings from the center; in pixels
        generatorWidthY; %95 % of the energy in pixels for lowpass/non-oscillating functions
        integralX;
        integralY;
        integralXWidth;
        integralYWidth;
        normalizingFactorX;
        normalizingFactorY;
    end
    
    methods (Abstract)
        values = evaluateX1D(obj,X);
        values = evaluateY1D(obj,Y);
    end
    methods (Access = private)
        function values = evaluate1D(obj,dim,X)
            if dim == 1
                values = obj.getHilbertTransformMultiplier(X,obj.symmetryX,obj.initialSymmetryX).*obj.evaluateX1D(X);
            end
            if dim == 2
                values = obj.getHilbertTransformMultiplier(X,obj.symmetryY,obj.initialSymmetryY).*obj.evaluateY1D(X);
            end
        end
    end
    methods (Access = protected)
        function multiplier = getHilbertTransformMultiplier(obj,grid,symmetry,initialSymmetry)
            if (symmetry ~= initialSymmetry && symmetry ~= SFDConstants.NONE && initialSymmetry ~= SFDConstants.NONE)
                grid(abs(grid)<eps) = 0;
                multiplier = -1i.*sign(grid);
            else
                multiplier = 1;
            end
        end
        function [generatorWidth,integral,integralWidth,normalizingFactor] = getProperties1D(obj,dim)
            if dim == 1
                symmetry = obj.symmetryX;
            else
                symmetry = obj.symmetryY;
            end
            foundZeroCrossings = 0;
            k = obj.integralPrec-4;
            while ~foundZeroCrossings && k > 0
                scalingFactor = 2^k;
                Xs = linspace(-pi,pi,2^obj.integralPrec + 1);
                Xs = Xs(1:(end-1))*scalingFactor;
                values = obj.evaluate1D(dim,Xs);
                values = real((ifft(ifftshift(values))));
                
                ctr = floor(length(Xs)/2)+1;
                if sum(abs(values((ctr-255):(ctr+255)))) < 0.001
                    
                    foundZeroCrossings = 1;
                    values(abs(values)<eps) = 0;
                    normalizingFactor = 1/sum(abs(values));
                    values = normalizingFactor*values;
                    zeroCrossings = (2*(values>=0)-1 + 2*(circshift(values,-1,2)>=0)-1) == 0;
                    zeroCrossings([1,end]) = 0;
                    if sum(zeroCrossings) >= 2
                        integralWidth = (find(zeroCrossings,1,'first') + (2^obj.integralPrec-find(zeroCrossings,1,'last')));
                    else
                        integralWidth = 2*find(cumsum(abs(values))>0.475,1,'first');
                    end
                    
                    generatorWidth = integralWidth/2^k;
                    integral = cumsum(fftshift(values));
                else
                    k = k -1;
                end
            end
        end
    end
    methods
        function obj = SFDGeneratorSeparable2D(maxFeatureWidth,maxFeatureLength,symmetryX,symmetryY,frequencyCone)
            if nargin > 2; obj.symmetryX = symmetryX; end
            if nargin > 3; obj.symmetryY = symmetryY; end
            if nargin > 4; obj.frequencyCone = frequencyCone; end
            [obj.generatorWidthX, obj.integralX,obj.integralXWidth,obj.normalizingFactorX] = obj.getProperties1D(1);
            [obj.generatorWidthY, obj.integralY,obj.integralYWidth,obj.normalizingFactorY] = obj.getProperties1D(2);
            
            if  nargin > 1;
                obj.initialScalingX = obj.generatorWidthX/maxFeatureWidth;
                obj.initialScalingY = obj.generatorWidthY/maxFeatureLength;
            else
                obj.initialScalingX = 1;
                obj.initialScalingY = 1;
            end
        end
        
        function values = evaluate(obj,X,Y)
            if obj.frequencyCone == 2
                %rotate by -pi/2 in the freq domain
                Z = X;
                X = Y;
                Y = -Z;
            end
            X = (1/obj.initialScalingX)*X;
            Y = (1/obj.initialScalingY)*Y;
            
            values = obj.normalizingFactorX*obj.normalizingFactorY*obj.evaluate1D(1,X).*obj.evaluate1D(2,Y);
            
        end
    end
    
end

% Written by Rafael Reisenhofer
%
% Part of SymFD Toolbox v 1.1
% Built on November 7, 2018
% Published under the MIT License

