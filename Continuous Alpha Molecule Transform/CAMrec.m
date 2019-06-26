function X = CAMrec(coeffs,moleculeSystem)
%CAMorientationOperator Implements the reconstruction based on a set of coefficients with
%respect to a given system of alpha molecules.
    
    X = zeros(moleculeSystem.size(1),moleculeSystem.size(2));
    
    for j = 1:moleculeSystem.nMolecules
        X = X+fftshift(fft2(ifftshift(coeffs(:,:,j)))).*moleculeSystem.molecules(:,:,j);
    end
    X = fftshift(ifft2(ifftshift((1./moleculeSystem.dualFrameWeights).*X)));
    
end

% Written by Rafael Reisenhofer
%
% Part of SymFD Toolbox v 1.1
% Built on November 7, 2018
% Published under the MIT License