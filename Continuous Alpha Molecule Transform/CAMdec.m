function coeffs = CAMdec(X,moleculeSystem)
%CAMorientationOperator Computes the decomposition (analysis operator) of an input image with
%respect to a given system of alpha molecules.

    X = fftshift(fft2(ifftshift(X)));
    coeffs = zeros(moleculeSystem.size(1),moleculeSystem.size(2),moleculeSystem.nMolecules);

    for k = 1:moleculeSystem.nMolecules
        coeffs(:,:,k) = fftshift(ifft2(ifftshift(X.*conj(moleculeSystem.molecules(:,:,k)))));
    end
end

% Written by Rafael Reisenhofer
%
% Part of SymFD Toolbox v 1.1
% Built on November 7, 2018
% Published under the MIT License