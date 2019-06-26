function imgRgb = SFDhsl2rgb( imgHsl )
%SFDHSL2RGB Summary of this function goes here
%   Detailed explanation goes here
    helpZero = zeros(size(imgHsl,1),size(imgHsl,2));
    imgRgb = zeros(size(imgHsl));

    C = (1 - abs(2*imgHsl(:,:,3) - 1)).*imgHsl(:,:,2);
    H = imgHsl(:,:,1)/60;
    X = C.*(1 - abs(mod(H,2) - 1));
    
    H = uint8(floor(H));
    
    m = imgHsl(:,:,3); - C/2;
    
    imgRgb(:,:,1) = helpZero.*(ismember(H,[2,3])) + C.*(ismember(H,[0,5])) + X.*(ismember(H,[1,4])) + m;
    imgRgb(:,:,2) = helpZero.*(ismember(H,[4,5])) + C.*(ismember(H,[1,2])) + X.*(ismember(H,[0,3])) + m;
    imgRgb(:,:,3) = helpZero.*(ismember(H,[0,1])) + C.*(ismember(H,[3,4])) + X.*(ismember(H,[2,5])) + m;
end

