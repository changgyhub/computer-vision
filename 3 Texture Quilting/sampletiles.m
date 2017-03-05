function tile_vec = sampletiles(sampleI,tilesize,overlap)


%
%  sample tiles of a given size from a sample image
%
% INPUTS:
%  sampleI: grayscale image to sample from 
%  tilesize: the size of the tiles, assumed square
%  overlap: set to "true" to extract overlapping tiles
%           "false" to extract non-overlapping tiles
%           setting to "false" will produce many more
%           tiles.
%
%  OUTPUTS:
%   tile_vec:  a 2D array of size:  tilesize^2  by  numtiles
%              each column of the matrix contains the grayscale
%              values of a tile reshaped into a vector
%
%
% It is generally better to use overlapping tiles in order
% to have a bigger database.  If you are running out of memory
% or testing your code, you may set overlap=false in order to
% test with a much smaller set of sample tiles
%

% extract a bunch of tiles from the image
if (~overlap)
  fprintf('sampling non-overlapping tiles\n');
  %crop our sample texture to be a multiple of tilesize
  croppedsize = floor(size(sampleI)/tilesize)*tilesize;
  sampleI = sampleI(1:croppedsize(1),1:croppedsize(2));
  %grab distinct (non-overlapping) tiles from the sample image
  tile_vec = im2col(sampleI,[tilesize tilesize],'distinct');  
else
  fprintf('sampling overlapping tiles\n');
  %extract all tilesize by tilesize sub regions of an image
  tile_vec = im2col(sampleI,[tilesize tilesize],'sliding'); 
end
nsampletiles = size(tile_vec,2);
fprintf('%d tiles found\n',nsampletiles);

%randomize the order of the tiles in our database
% in case we later want to shrink the database 
% first generate a random permultation of the numbers 1:nsampletiles
perm = randperm(nsampletiles);   
%reorder the entries in tile vec using this permutation
tile_vec = tile_vec(:,perm);


