function V = hogDraw( H, w )
% Create visualization of hog template
%
% USAGE
%  V = hogDraw( H, [w] )
%
% INPUTS
%  H          - [m n 9] computed hog features
%  w          - [15] width for each glyph in the visualization
%
% OUTPUTS
%  V          - [m*w n*w] visualization of hog features
%
% EXAMPLE
%
% See also hog
%
% Piotr's Image&Video Toolbox      Version 2.41
% Copyright 2009 Piotr Dollar.  [pdollar-at-caltech.edu]
% Please email me if you find bugs, or have suggestions or questions!
% Licensed under the Lesser GPL [see external/lgpl.txt]

% construct a "glyph" for each orientaion
if(nargin<2 || isempty(w)), w=15; end
bar=zeros(w,w); bar(:,round(.45*w):round(.55*w))=1;
bars=zeros([size(bar) 9]);
for i=1:9, bars(:,:,i)=imrotate(bar,-(i-1)*180/9,'crop'); end

% make pictures of positive weights by adding up weighted glyphs
H(H<0)=0; V=zeros(w*[size(H, 1) size(H, 2)]);
for r=1:size(H, 1), rs=(1:w)+(r-1)*w;
  for c=1:size(H, 2), cs=(1:w)+(c-1)*w;
    for i=1:9, V(rs,cs)=V(rs,cs)+bars(:,:,i)*H(r,c,i); end
  end
end
