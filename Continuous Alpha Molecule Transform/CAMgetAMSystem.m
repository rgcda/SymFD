function AMSystem = CAMgetAMSystem(rows,cols,alpha,paramSet,generators,orientationOperator)
% CAMgetAMSystem Returns a system of digital alpha molecule filters based
% on the specified parameters.
% 
% Usage (optional parameters are enclosed in angle brackets):
% 
%  AMSystem = CAMgetAMSystem(rows,cols,alpha,paramSet,generators,orientationOperator)


    nMolecules = size(paramSet.generators,1);
    molecules = zeros(rows,cols,nMolecules);
    
    for k = 1:nMolecules
        molecules(:,:,k) = CAMgetMolecule(rows,cols,alpha,paramSet.scaleFactors(k,:),paramSet.orientations(k,:),generators{paramSet.generators(k)},orientationOperator);
    end
    dualFrameWeights = sum(abs(molecules).^2,3);
    AMSystem = struct('molecules',molecules,'size',[rows,cols],'paramSet',paramSet,'nMolecules',nMolecules,'dualFrameWeights',dualFrameWeights);
    AMSystem.generators = generators;
    AMSystem.alpha = alpha;
end

% Written by Rafael Reisenhofer
%
% Part of SymFD Toolbox v 1.1
% Built on November 7, 2018
% Published under the MIT License
