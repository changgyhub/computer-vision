function T = ttform(tri1,tri2)

% compute the affine transformation T that maps points
% of triangle1 to triangle2 
%
%  tri1 : 2x3 matrix containing coordinates of corners of triangle 1
%  tri2 : 2x3 matrix containing coordinates of corners of triangle 2
%
%  T : the resulting transformation, should be a 3x3
%      matrix which operates on points described in 
%      homogeneous coordinates 
%
 
A = [tri1(3)-tri1(1),tri1(5)-tri1(1),tri1(1);
     tri1(4)-tri1(2),tri1(6)-tri1(2),tri1(2);
     0,0,1];
B = [tri2(3)-tri2(1),tri2(5)-tri2(1),tri2(1);
     tri2(4)-tri2(2),tri2(6)-tri2(2),tri2(2);
     0,0,1];
T = B/A;

%
% test code to make sure we have done the right thing
% if we apply the transformation T to tri1, we should
% get exactly tri2.
%

% apply mapping to corners of tri1 and 
% make sure the result is close to tri2
err1 = sum((T*[tri1(:,1);1] - [tri2(:,1);1]).^2);
assert(err1 < eps)

err2 = sum((T*[tri1(:,2);1] - [tri2(:,2);1]).^2);
assert(err2 < eps)

err3 = sum((T*[tri1(:,3);1] - [tri2(:,3);1]).^2);
assert(err3 < eps)

