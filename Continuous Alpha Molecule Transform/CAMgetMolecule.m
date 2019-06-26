function molecule = CAMgetMolecule(rows,cols,alpha,scaleFactor,orientation,generator,orientationOperator)
%CAMorientationOperator Returns a single digital alpha molecule filter.

    Xs = linspace(-pi,pi,rows + 1);
    Ys = linspace(-pi,pi,cols + 1);
    Xs = Xs(1:(end-1));
    Ys = Ys(1:(end-1));
    
    [X,Y] = meshgrid(Ys,Xs);
    %%orientation
    if generator.domain == CAMConstants.FREQUENCY
        orientation = -orientation;
    end
    [X,Y] = orientationOperator.evaluate(orientation,X,Y,generator);
    
    %%scale    
    if generator.domain == CAMConstants.FREQUENCY
        scaleFactor = 1/scaleFactor;
    end
    if generator.frequencyCone == 1
        X = scaleFactor*X;
        Y = scaleFactor^alpha*Y;
    else
        X = scaleFactor^alpha*X;
        Y = scaleFactor*Y;
    end
        
    %%evaluate generator
    molecule = generator.evaluate(X,Y);
        
end

% Written by Rafael Reisenhofer
%
% Part of SymFD Toolbox v 1.1
% Built on November 7, 2018
% Published under the MIT License
