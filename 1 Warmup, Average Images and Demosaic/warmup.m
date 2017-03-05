I = rgb2gray(imread('myfile.jpg'));
I = im2double(I);
A = I(31:130, 41:140);

%(a)
x = sort(reshape(A, 1, []));
plot(x);

%(b)
hist(A, 32);

%(c)
t = x(5000);
A_c = A >= t;
imshow(A_c);

%(d)
m = mean(x);
A_d = (A >= m).*(A-m);
imshow(A_d);

%(e)
y = [1:6];
z = reshape(y, 3, 2);

%(f)
x = min(A(:));
[r, c] = find(A==x);

%(g)
v = [1 8 8 2 1 3 9 8];
tol = size(unique(v), 2);