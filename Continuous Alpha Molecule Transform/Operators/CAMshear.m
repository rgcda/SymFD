classdef CAMshear < CAMorientationOperator
%CAMshear Implementation of the 2D shear operator.

    methods
        function [Xnew,Ynew] = evaluate(obj,angle,X,Y,generator)
        %CAMSHEAR Summary of this function goes here
        %   Detailed explanation goes here        
           shearAxis = mod(2,1 + (generator.domain == CAMConstants.FREQUENCY) + (generator.frequencyCone-1)) + 1;
           s = tan(angle);
           if shearAxis == 1
               Ynew = Y + s*X;
               Xnew = X;
           else
               Xnew = X + s*Y;
               Ynew = Y;
           end
        end
    end
end

% Written by Rafael Reisenhofer
%
% Part of SymFD Toolbox v 1.1
% Built on November 7, 2018
% Published under the MIT License
