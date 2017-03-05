%
% synthesize an output image given a set of tile indices
% by simply pasting the tiles into the output array (no blending)
%
%  tindex : array containing the tile indices to use
%  tile_vec : array containing the tiles
%  tilesize : the size of the tiles  (should be sqrt of the size of the tile vectors)
%  overlap : overlap amount between tiles
%
function output = synth_paste(tindex,tile_vec,tilesize,overlap)

if (tilesize ~= sqrt(size(tile_vec,1)))
  error('tilesize does not match the size of vectors in tile_vec');
end

% compute size of output image, it will be square
% each tile contributes this much to the final output image width.
tilewidth = tilesize-overlap;  
outputsize = size(tindex)*tilewidth+overlap;

output = zeros(outputsize(1),outputsize(2));
for i = 1:size(tindex,1)
  for j = 1:size(tindex,2)
     ioffset = (i-1)*tilewidth;
     joffset = (j-1)*tilewidth;

     %grab the selected tile
     tile_image = tile_vec(:,tindex(i,j));

     %reshape it from a vector to a square
     tile_image = reshape(tile_image,tilesize,tilesize);

     %paste it down into the output image
     output((1:tilesize)+ioffset,(1:tilesize)+joffset) = tile_image;
  end
end


