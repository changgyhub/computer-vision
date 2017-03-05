setsum1 = zeros(215, 300, 3, 'double');
filelist = dir('set1/*.jpg');
for i=1:length(filelist)
	imname = ['set1/' filelist(i).name];
	nextim = imread(imname);
	setsum1 = setsum1 + im2double(nextim);
end
setsum1 = setsum1./length(filelist);
imshow(setsum1);

setsum2 = zeros(164, 398, 3, 'double');
filelist = dir('set2/*.jpg');
for i=1:length(filelist)
	imname = ['set2/' filelist(i).name];
	nextim = imread(imname);
	setsum2 = setsum2 + im2double(nextim);
end
setsum2 = setsum2./length(filelist);
imshow(setsum2);

subplot(1,2,1), imshow(setsum1);
subplot(1,2,2), imshow(setsum2);