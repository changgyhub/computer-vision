% compute image gradient magnitude and orientation at each pixel
% aka Sobel operator
function [mag,ori] = mygradient(I)

% test mygradient
% I = im2double(rgb2gray(imread('test0.jpg')));

Sobel = [-1,0,1;-2,0,2;-1,0,1];

dx = imfilter(I,Sobel,'replicate');
dy = imfilter(I,Sobel.','replicate');

mag = sqrt(dx.^2 + dy.^2);
ori = atan2(dy,dx); % ".*180/pi" to show actual degree

% test mygradient
% subplot(2,1,1);
% imagesc(mag);
% colorbar;
% colormap jet;
% title('Magnitude');
% subplot(2,1,2);
% imagesc(ori.*180/pi);
% colorbar;
% colormap jet;
% title('Orientation');
end

