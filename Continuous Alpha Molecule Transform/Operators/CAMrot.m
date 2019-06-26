classdef CAMrot < CAMorientationOperator
%CAMrot Implementation of the 2D rotation operator.
   
    methods
        function  [Xnew,Ynew] = evaluate(obj,angle,X,Y,generator)
            cosa = cos(angle);
            sina = sin(angle);

            Xnew = cosa*X - sina*Y;
            Ynew = sina*X + cosa*Y;
        end
    end 
end

% Written by Rafael Reisenhofer
%
% Part of SymFD Toolbox v 1.1
% Built on November 7, 2018
% Published under the MIT License
