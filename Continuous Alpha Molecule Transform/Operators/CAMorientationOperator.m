classdef (Abstract) CAMorientationOperator
%CAMorientationOperator Abstract class for operator that change the
%preferred orientation of an alpha molecule generator.
            
    methods (Abstract)
        [Xnew,Ynew] = evaluate(obj,angle,X,Y,generator)
    end
    
end

% Written by Rafael Reisenhofer
%
% Part of SymFD Toolbox v 1.1
% Built on November 7, 2018
% Published under the MIT License