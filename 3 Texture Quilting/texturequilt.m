% This script implements a version of texture quilting based on the paper
%
% " Image Quilting for Texture Synthesis and Transfer", 
%  A. Efros, W. Freeman, SIGGRAPH 2001
%
%
% Given an input sample texture image, synthesize a new image 
% of a given dimensions by pasting down blocks of the original 
% input and then quilting together the edges to give a nice
% looking result.
%

% parameters of the algorithm
imagefile = 'rock_wall.jpg';
ntilesout = [5 10];   % how many tiles wide and tall the output should be
tilesize = 30;    % the size of the tiles we paste down (assumed square)
overlap = 5;      % how much overlap should there be between neighboring tiles
K = 5;            %number of top candidate matches we choose from
alltiles = true;  %use overlapping sample tiles, setting this to false 
                 % will generate fewer tiles in the databse

% load in our texture example image and resize it
sampleI = imresize(im2double(rgb2gray(imread(imagefile))),0.5);

% extract sample tiles from sampleI 
tile_vec = sampletiles(sampleI,tilesize,alltiles);
nsampletiles = size(tile_vec,2);
if (nsampletiles<K)
  error('sample tile database is not big enough!');
end

% define a mask for the right,left,top and bottom edges of a tile
% the mask should be 1 in the overlap zone and zero everywhere else
maskR = [zeros(tilesize,tilesize-overlap) ones(tilesize,overlap)];
maskL = [ones(tilesize,overlap) zeros(tilesize,tilesize-overlap)];
maskT = [ones(overlap,tilesize); zeros(tilesize-overlap,tilesize)];
maskB = [zeros(tilesize-overlap,tilesize); ones(overlap,tilesize)];

% get the indices of patch pixels that are in right,left,top and bottom 
indR = find(maskR);
indL = find(maskL);
indT = find(maskT);
indB = find(maskB);

% now loop over output tiles 
tindex = zeros(ntilesout);
for i = 1:ntilesout(1)
  for j = 1:ntilesout(2)
     % the first row and first column are a bit special because we don't have 
     % tiles to the left or above us at that point.
     if i==1 && j==1 %the first tile we just choose at random as in version 0
       matches = 1:nsampletiles;
     elseif i==1 % first row (but not the first tile), only consider the tile to our left
         lefttile = tile_vec(:,tindex(i,j-1));
         strip = lefttile(indR); %the right strip of that tile
         % compare to the left strip of all our candidates
         matches = topkmatch(strip,tile_vec(indL,:),K);
     elseif j==1 % first column (but not first row)
         toptile = tile_vec(:,tindex(i-1,j));
         strip = toptile(indB); %the bottom strip of that tile above us
         % compare to the top of all our candidates
         matches = topkmatch(strip,tile_vec(indT,:),K); 
     else % i>1 and j>1
         lefttile = tile_vec(:,tindex(i,j-1));
         stripR = lefttile(indR); %the right strip of that tile
         toptile = tile_vec(:,tindex(i-1,j));
         stripB = toptile(indB); %the bottom strip of that tile above us
         strip = [stripR;stripB];
         indLT = [indL;indT];
         % compare to the top of all our candidates
         matches = topkmatch(strip,tile_vec(indLT,:),K); 
     end
     % choose one of the top K matches at random
     tindex(i,j) = matches(randi(K));
  end
end

%synthesize output images based on the tile may stored in tindex
output_paste = synth_paste(tindex,tile_vec,tilesize,overlap);  %just paste down the tiles

output_quilt = synth_quilt(tindex,tile_vec,tilesize,overlap);  %quilt together the tiles... you should implement this function

%display the output images
figure(3); subplot(3,1,1); imshow(sampleI); axis image;  title('original sample');
figure(3); subplot(3,1,2); imshow(output_paste); axis image;  title('synthesized, pasted');
figure(3); subplot(3,1,3); imshow(output_quilt); axis image;  title('synthesized, quilted');
