classdef (Abstract) CAMGenerator
%CAMGenerator Abstract class for alpha molecule generators
%
    properties (Abstract,Constant)
        domain %TIME or FREQUENCY
    end
    properties (Abstract)
        frequencyCone %1 (horizontal) or 2 (vertical).
    end
    methods (Abstract)
        values = evaluate(obj,X,Y) %returns the values of the generator at
                                   %the grid points specified by the
                                   %matrices X and Y
    end
    
end

% Written by Rafael Reisenhofer
%
% Part of SymFD Toolbox v 1.1
% Built on November 7, 2018
% Published under the MIT License