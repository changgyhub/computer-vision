function [toplist] = topkmatch(x,xlist,k)

%
% compute the top k matches in our list of tiles by 
% computing the squared distance between x and all
% the vectors stored in xlist, sorting the distances
% and returning the k smallest
%
% x     : Dx1 vector to match
% xlist : DxN set of vectors to compare to
% k     : number of nearest neigbhors to return
%
% toplist : indices into xlist of the closest matches to x
%

dist2 = sum((xlist-repmat(x,1,size(xlist,2))).^2,1); %compute squared distance
[sl,ind] = sort(dist2);

toplist = ind(1:k); %grab the indices of the top k matches
