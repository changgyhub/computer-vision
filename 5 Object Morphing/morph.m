%
% morphing script
%

% load in two images...
I1 = im2double(imread('3.jpg'));
I2 = im2double(imread('4.jpg'));

% get user clicks on keypoints using either ginput or cpselect tool
imshow(I1);
[x1,y1] = getpts;
imshow(I2);
[x2,y2] = getpts;

% the more pairs of corresponding points the better... ideally for 
% faces ~20 point pairs is good include several points around the
% outside contour of the head and hair.

% you may want to save pts_img1 and pts_img2 out to a .mat file at
% this point so you can easily reload it without having to click
% again. 

save test.mat x1 y1 x2 y2
% load test.mat

pts_img1(1,:) = transpose(x1);
pts_img1(2,:) = transpose(y1);
pts_img2(1,:) = transpose(x2);
pts_img2(2,:) = transpose(y2);

% generate triangulation 
tri1 = delaunay(x1,y1);
tri2 = delaunay(x2,y2);

% now produce the frames of the morph sequence
frame = 20;
for fnum = 1:frame+1
    t = (fnum-1)/frame;

    % intermediate key-point locations
    pts_target = (1-t)*pts_img1 + t*pts_img2;                

    %warp both images towards target
    I1_warp = warp(I1,pts_img1,pts_target,tri1);
    I2_warp = warp(I2,pts_img2,pts_target,tri2);

    % blend the two warped images
    Iresult = (1-t)*I1_warp + t*I2_warp;                     

    % display frames
    figure(1); clf; imagesc(Iresult); axis image; drawnow;   

    % alternately save them to a file to put in your writeup
    % imwrite(Iresult,sprintf('object_%2.2d.jpg',fnum),'jpg');   
end
