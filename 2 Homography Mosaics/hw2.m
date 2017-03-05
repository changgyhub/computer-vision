% HW2: Homography mosaics
% Author: Gao Chang

%--------------------------- main ---------------------------

% 1. Load in images and preprocessing
imnames = {'test/001.JPG','test/002.JPG','test/003.JPG'};
nimages = length(imnames);
baseim = 1; %index of the central "base" image

for i = 1:nimages
    ims{i} = im2double(imread(imnames{i}));
    ims_gray{i} = rgb2gray(ims{i});
    [h(i),w(i),~] = size(ims{i});
end


% 2. get corresponding points between each image and the central base image
for i = 1:nimages
    if (i ~= baseim)
    % run interactive select tool to click corresponding points on base and non-base image
    [movingPoints{i},fixedPoints{i}] = cpselect(ims{i},ims{baseim},'Wait',true);
    % refine the user clicks using cpcorr
    movingPoints{i} = cpcorr(movingPoints{i},fixedPoints{i},ims_gray{i},ims_gray{baseim});
     
    % verify that the points are good!
    x1{i} = movingPoints{i}(:,1);
    y1{i} = movingPoints{i}(:,2);
    x2{i} = fixedPoints{i}(:,1);
    y2{i} = fixedPoints{i}(:,2);
        
    subplot(2,1,1); 
    imagesc(ims{baseim});
    hold on;
    plot(x2{i}(1),y2{i}(1),'r*',x2{i}(2),y2{i}(2),'b*',x2{i}(3),y2{i}(3),'g*',x2{i}(4),y2{i}(4),'y*');
    subplot(2,1,2);
    imshow(ims{i});
    hold on;
    plot(x1{i}(1),y1{i}(1),'r*',x1{i}(2),y1{i}(2),'b*',x1{i}(3),y1{i}(3),'g*',x1{i}(4),y1{i}(4),'y*');
    end
end

% save control points
save test.mat x1 y1 x2 y2
% load control points
load test.mat


% 3. estimate homography for each image
for i = 1:nimages
    if (i ~= baseim)
        H{i} = computeHomography(x1{i},y1{i},x2{i},y2{i});
    else
        H{i} = eye(3); %homography for base image is just the identity matrix
    end
end


% 4. compute where corners of each warped image end up
for i = 1:nimages
    cx = [1;1;w(i);w(i)];  %corner coordinates based on h,w for each image
    cy = [1;h(i);1;h(i)];
    [cx_warped{i},cy_warped{i}] = applyHomography(H{i},cx,cy);
end


% 5. find corners of a rectangle that contains all the warped images
minX = w(baseim);
maxX = -w(baseim);
minY = h(baseim);
maxY = -h(baseim); 
for i = 1:nimages
    if min(cx_warped{i}) < minX 
        minX = min(cx_warped{i});
    end
    if max(cx_warped{i}) > maxX 
        maxX = max(cx_warped{i});
    end
    if min(cy_warped{i}) < minY 
        minY = min(cy_warped{i});
    end
    if max(cy_warped{i}) > maxY 
        maxY = max(cy_warped{i});
    end
end

% 6. Use H and interp2 to perform inverse-warping of the
%    source image to align it with the base image

% range of meshgrid should be the containing rectangle
[xx,yy] = meshgrid(minX:maxX,minY:maxY); 
[ww,hh] = size(xx);
for i = 1:nimages
    [newX, newY] = applyHomography(inv(H{i}),xx(:),yy(:));
    xI = reshape(newX,ww,hh)'; 
    yI = reshape(newY,ww,hh)';  
    R = interp2(ims{i}(:,:,1), xI, yI, '*bilinear')'; % red 
    G = interp2(ims{i}(:,:,2), xI, yI, '*bilinear')'; % green 
    B = interp2(ims{i}(:,:,3), xI, yI, '*bilinear')'; % blue 
    J{i} = cat(3,R,G,B);
    
    % interp2 puts NaNs outside the support of the warped image
    mask{i} = 1-isnan(J{i});
    J{i}(isnan(J{i})) = 0;
    
    % blur and clip mask to get an alpha map
    alpha{i} = imfilter(mask{i}, fspecial('gaussian', 50, 0.5), 'replicate');
end


% 7. scale alpha maps to sum to 1 at every pixel location
sum = zeros(size(J{1}));
for i = 1:nimages
    sum = sum + alpha{i};
end
for i = 1:nimages
    alpha{i} = alpha{i}./sum;
end


% 8. blend together the resulting images into the final mosaic
K = zeros(size(J{1}));
for i = 1:nimages
    K  = K + J{i}.*alpha{i};
end


% 9. display and save the result
figure(1);
imagesc(K); axis image;
for i = 1:nimages
    imwrite(J{i}, strcat('component', num2str(i), '.jpg'));
end
imwrite(K,'final.jpg');


%--------------------------- functions ---------------------------

% solve out the homography matrix from m1 to m2
function [H] = computeHomography(x1,y1,x2,y2)
    % Method 1
    % we suppose h33 = 1 and then do pseudo-inverse to get h
    A = zeros(8,8);
    b = reshape([x2,y2].',[],1);
    for i = 1:4
        A((2*i-1):2*i,:) = [x1(i),y1(i),1,0,0,0,-x1(i)*x2(i),-y1(i)*x2(i);
                            0,0,0,x1(i),y1(i),1,-x1(i)*y2(i),-y1(i)*y2(i)];
    end
    [H] = reshape([A\b; 1], 3, []).';
    % Method 2
    % use full matrix A (8-by-9)
    % then use svd to get the last eigenvector of ATA (the last col of V)
    % which is exactly the answer h
%     A = zeros(8,9);
%     for i = 1:4
%         A((2*i-1):2*i,:) = [-x1(i),-y1(i),-1,0,0,0,x1(i)*x2(i),y1(i)*x2(i),x2(i);
%                             0,0,0,-x1(i),-y1(i),-1,x1(i)*y2(i),y1(i)*y2(i),y2(i)];
%     end
%     [~,~,V] = svd(A);
%     H = reshape(V(:,9),[3,3])';

end

% apply homography matrix from (x1, y1) to (x2, y2)
function [x2,y2] = applyHomography(H,x1,y1)
    homovec = H*[x1'; y1'; ones(1,size(x1,1))];
    % make the third entry 1
    for i = 1:size(x1,1)
        homovec(:,i) = homovec(:,i)/homovec(3,i);
    end
    x2 = homovec(1,:)';
    y2 = homovec(2,:)';
end