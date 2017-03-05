function [path] = shortest_path(costs)

%
% given a 2D array of costs, compute the minimum cost vertical path
% from top to bottom which, at each step, either goes straight or
% one pixel to the left or right.
%
% costs:  a HxW array of costs
%
% path: a Hx1 vector containing the indices (values in 1...W) for 
%       each step along the path
%

% 1. find minimum cost by dynamic programming
dpCost = zeros(size(costs));
dpCost(1,:) = costs(1,:);
for i=2:size(dpCost,1)
     dpCost(i,1) = costs(i,1) + min(dpCost(i-1,1), dpCost(i-1,2)); %left most path
     for j=2:size(dpCost,2)-1
         dpCost(i,j) = costs(i,j) + min([dpCost(i-1,j-1), dpCost(i-1,j), dpCost(i-1,j+1)]);
     end
     dpCost(i,end) = costs(i,end) + min(dpCost(i-1,end-1), dpCost(i-1,end)); %right most path
end

%2. get path by backtracking
path = zeros(size(dpCost,1),1);
[~, minpos] = min(dpCost(end, 1:end));
path(end,1) = minpos;
for i=size(dpCost,1)-1:-1:1
    for j=1:size(dpCost,2)
        if minpos > 1 && dpCost(i,minpos-1) == min(dpCost(i,minpos-1:min(minpos+1,size(dpCost,2))))
            minpos = minpos-1;
        elseif minpos < size(dpCost,2) && (dpCost(i,minpos+1) == min(dpCost(i,max(minpos-1,1):minpos+1)))
            minpos = minpos+1;
        end  
        path(i,1) = minpos;       
    end
end
    
end
