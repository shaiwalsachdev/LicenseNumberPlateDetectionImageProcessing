I = imread('d1.jpg');
G = imresize(I, [480 640]);
H = rgb2gray(G);
H = medfilt2(H);
[m ,n] = size(H);
g = zeros(m,n);
for i=1:m
    for j=1:n-1
        g(i,j) = abs(H(i,j+1)-H(i,j));
    end
end
figure
imshow(g);

se = strel('disk',1);

H11 = imerode(H,se);
H12 = imdilate(H11, se);
H13 = imsubtract(H,H12);
figure
imshow(H13);

H1 = imerode(g,se);
H2 = imdilate(H1, se);
H3 = imsubtract(g,H2);%hat
T = zeros(m);
for i = 1:m
    sum = 0;
    for j = 1:n
        sum = sum + H3(i,j);
    end
    T(i,i) = sum;
end
T = diag(T);
figure
%plot(T);
imshow(H3);
w = 8;
sig = 0.05;
h = zeros(w);
for i = 1:w
    h(i,i) = exp(-((i * sig) ^2) / 2);
end
h = diag(h);
k = 0;
sum = 0;
for i = 1:w
    sum = sum + h(i,1);
end
k = 2 * sum + 1;
Th = zeros(m);
for i = 1:m
    sum = 0;
    for j = 1:w
        if (i - j > 0) && (i + j < m)
            sum  = sum + T(i-j,1) * h(j,1) + T(i+j,1) * h(j,1);
        end
        sum  = sum + T(i,1);
        Th(i,i) = sum / k;
    end
end
Th = diag(Th);
%figure
%plot(Th);
t = 3.5;
avg = 0;
[x y] = size(Th);
for i = 1:x
    avg = avg + Th(i,1);
end
avg = avg / x;
T1 = t * avg;
stack = zeros(1,x);
for i = 1:x
    if Th(i,1) >= T1
        stack(1,i) = 1;
    end
end
fst = 0;
snd = 0;
%figure
%plot(stack);
flg = 0;
i = 1;
while i <= x 
    flg = 0;
    for j = i:i+100
        if j <= x
            if stack(1,i) ~= 1
                flg = 1;
            end
        end
        if flg == 1
            break;
        end
    end
    if ((j == i+100) && (flg == 0))
        fst = i;
        snd = j;
        figure
        imshow(H(i:j,:));
        imwrite(H(i:j,:),'f1.jpg','jpg');
        i = i + 50;
    end
    i = i + 1;
end

img = imread('f1.jpg');
level = graythresh(img);
img = im2bw(img,level);
%imshow(img);
img = ~img;
%imshow(img);
img = bwareaopen(img,100);
I2=regionprops(img,'BoundingBox','Image');
for i = 1:length(I2)
   s = 'segment';
 %   s1 = 'Images\';
    s = strcat(s, int2str(i));
    %s1 = strcat(s1,s);
%    figure('name', s)
    s = strcat(s,'.jpg');
%    imshow(I2(i).Image)
    %imwrite(Iprops(i).Image, s,'jpg');
end
%[LL,LH,HL,HH] = dwt2(img,'db2');
%LL = double(LL);
%LH = double(LH);
%HL = double(HL);
%HH = double(HH);
%LL = imresize(LL, [480 640]);
%LH = imresize(LH, [480 640]);
%HL = imresize(HL, [480 640]);
%HH = imresize(HH, [480 640]);
%[M,N] = size(LL);
%Dif = zeros(M,N);
%for i = 1:M
%    for j= 1:N-1
%        Dif(i,j) = abs(LH(i,j+1)-LH(i,j)) + abs(HL(i,j+1)-HL(i,j)) + abs(HH(i,j+1)-HH(i,j));
%    end
%end
%imshow(Dif);