f=imread('d1.jpg'); % Reading the number plate image.
%figure('name','Original Image');
%imshow(f);
f=imresize(f,[400 NaN]); % Resizing the image keeping aspect ratio same.
%figure('name','Resized Image');
%imshow(f);
imwrite(f, 'Resized.jpg','jpg');
g=rgb2gray(f); % Converting the RGB (color) image to gray (intensity).
%figure('name','Gray Image');
%imshow(g);
imwrite(g, 'GrayScale.jpg','jpg');
g=medfilt2(g,[3 3]); % Median filtering to remove noise.
%figure('name','Filtered Image');
%imshow(g);
imwrite(g, 'Filtered.jpg','jpg');
se=strel('disk',1); % Structural element (disk of radius 1) for morphological processing.
gi=imdilate(g,se); % Dilating the gray image with the structural element.
%figure('name', 'Dialated Image');
%imshow(gi);
ge=imerode(g,se); % Eroding the gray image with structural element.
%figure('name', 'Eroded Image');
%imshow(ge);
gdiff=imsubtract(gi,ge); % Morphological Gradient for edges enhancement.
%figure('name','Morphological Image');
%imshow(gdiff);
imwrite(gdiff, 'Morphedimage.jpg','jpg');
gdiff=mat2gray(gdiff); % Converting the class to double.
gdiff=conv2(gdiff,[1 1;1 1]); % Convolution of the double image for brightening the edges.
%figure('name','Convolutional Image');
%imshow(gdiff);
gdiff=imadjust(gdiff,[0.5 0.7],[0 1],0.1); % Intensity scaling between the range 0 to 1.
%figure('name','Intensity mapped Image');
%imshow(gdiff);
%imwrite(gdiff, 'IntensityMApped.jpg','jpg');
B=logical(gdiff);
%figure('name','Logical Image');
%imshow(B);% Conversion of the class from double to binary. 

er=imerode(B,strel('line',50,0));
%imshow(er);
out1=imsubtract(B,er);
%figure('name','Eroded Image');
%imshow(out1);
%imwrite(out1, 'eroded.jpg','jpg');
% Filling all the regions of the image.
F=imfill(out1,'holes');
% Thinning the image to ensure character isolation.
H=bwmorph(F,'thin',NaN);
figure('name','Morphed Image');
%imshow(H);
H=imerode(H,strel('line',3,90));
imshow(H);
% Selecting all the regions that are of pixel area more than 100.

final=bwareaopen(H,100);
%figure('name','Final Image');
imshow(final);
%imwrite(final, 'Final.jpg','jpg');
Iprops=regionprops(final,'BoundingBox','Image');
for i = 1:length(Iprops)
   s = 'segment';
    s1 = 'Images\';
    s = strcat(s, int2str(i));
    s1 = strcat(s1,s);
   %figure('name', s)
    s = strcat(s,'.jpg');
   % imshow(Iprops(i).Image)
    imwrite(Iprops(i).Image, s,'jpg');
end