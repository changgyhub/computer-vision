function output = synth_quilt(tindex,tile_vec,tilesize,overlap)
%
% synthesize an output image given a set of tile indices
% where the tiles overlap, stitch the images together
% by finding an optimal seam between them
%
%  tindex : array containing the tile indices to use
%  tile_vec : array containing the tiles
%  tilesize : the size of the tiles  (should be sqrt of the size of the tile vectors)
%  overlap : overlap amount between tiles
%
%  output : the output image

if (tilesize ~= sqrt(size(tile_vec,1)))
  error('tilesize does not match the size of vectors in tile_vec');
end

% 1. set up size
tilewidth = tilesize-overlap;  
outputsize = size(tindex)*tilewidth+overlap;

% 2. stitch each row into a separate image by repeatedly calling stitch()
RowI = zeros(tilesize,outputsize(2),outputsize(1));
for i = 1:size(tindex,1)
  % reshape the first tile in the row from a vector to a square
  row_image = reshape(tile_vec(:,tindex(i,1)),tilesize,tilesize);
  for j = 2:size(tindex,2)
     % reshape the other tiles in this row from a vector to a square
     tile_image = reshape(tile_vec(:,tindex(i,j)),tilesize,tilesize);
     row_image = stitch(row_image, tile_image, overlap);
  end;
  RowI(:,:,i) = row_image;
end;

% 3. stitch the rows together into the final result
% (calling stitch function on transposed row images and then transpose the result back)
output = transpose(RowI(:,:,1));
for i = 2:size(tindex,1)
    output = stitch(output,transpose(RowI(:,:,i)),overlap);
end
output = transpose(output);


