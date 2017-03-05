% compute orientation histograms over 8x8 blocks of pixels
% orientations are binned into 9 possible bins
%
% I : grayscale image of dimension HxW
% ohist : orinetation histograms for each block. ohist is of dimension (H/8)x(W/8)x9
function ohist = hog(I)

% 1. set up size and bins
[h,w] = size(I); % size of the input
h2 = ceil(h/8);  % the size of the output
w2 = ceil(w/8);
nori = 9;        % number of orientation bins

% 2. calc gradient and magnitude
[mag,ori] = mygradient(I);
thresh = 0.1*max(mag(:));  % threshold for edges

% 3. separate out pixels into orientation channels
ohist = zeros(h2,w2,nori);
stepbase = -pi;
steplen = 2*pi/9;
for i = 1:nori
	% create a binary image containing 1's for the pixels that are edges at this orientation
    B = zeros(h,w);
    for k = 1:(h*w)
        if mag(k) > thresh && (ori(k) >= stepbase && ori(k) < (stepbase + steplen))
            B(k) = 1;
        else
            B(k) = 0;
        end
    end
    stepbase = stepbase + steplen;
    % sum up the values over 8x8 pixel blocks.
    chblock = im2col(B,[8 8],'distinct');  % sum over each block and store result in ohist
    ohist(:,:,i) = reshape(sum(chblock,1),h2,w2);                     
end

% 4. normalize the histogram so that sum over orientation bins is 1 for each block
% NOTE: Don't divide by 0! If there are no edges in a block (ie. this counts sums to 0 for the block) then just leave all the values 0. 
for i = 1:h2
    for j = 1:w2
        k = sum(ohist(i,j,:));
        if k ~= 0
            ohist(i,j,:) = ohist(i,j,:)/k;
        end
    end
end

end