function [J] = mydemosaic(I)
%mydemosaic - demosaic a Bayer RG/GB image to an RGB image
%
% I: RG/GB mosaic image  of size  HxW
% J: RGB image           of size  HxWx3
    H = size(I, 1);
    W = size(I, 2);
    R = zeros(H, W);
    G = zeros(H, W);
    B = zeros(H, W);
    h = ones(3, 3);
    
    R(1:2:end,1:2:end) = I(1:2:end,1:2:end); % original
    Rfilt = imfilter(R, h);
    R(1:2:end,2:2:end) = Rfilt(1:2:end,2:2:end)./2;
    R(2:2:end,1:2:end) = Rfilt(2:2:end,1:2:end)./2;
    R(2:2:end,2:2:end) = Rfilt(2:2:end,2:2:end)./4;
    
    G(1:2:end,2:2:end) = I(1:2:end,2:2:end); % original
    G(2:2:end,1:2:end) = I(2:2:end,1:2:end); % original
    Gfilt = imfilter(G, h);
    G(1:2:end,1:2:end) = Gfilt(1:2:end,1:2:end)./4;
    G(2:2:end,2:2:end) = Gfilt(2:2:end,2:2:end)./4;
    
    B(2:2:end,2:2:end) = I(2:2:end,2:2:end); % original
    Bfilt = imfilter(B, h);
    B(1:2:end,1:2:end) = Bfilt(1:2:end,1:2:end)./4;
    B(1:2:end,2:2:end) = Bfilt(1:2:end,2:2:end)./2;
    B(2:2:end,1:2:end) = Bfilt(2:2:end,1:2:end)./2;
    
    [J] = reshape([R, G, B], H, W, 3); 
    
end