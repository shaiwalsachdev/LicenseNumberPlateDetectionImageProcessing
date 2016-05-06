srcFiles = dir('D:\Study\6th Sem\Image Processing\Project\Test\*.jpg');  % the folder in which ur images exists
for i = 1 : length(srcFiles)
    filename = strcat('D:\Study\6th Sem\Image Processing\Project\Test\',srcFiles(i).name);
    I= imread(filename);
    G = imresize(I, [480 640]);
    H = rgb2gray(G);
    %imshow(H);
    %[m n] = size(G);
    %H = zeros(m , n);
    %n = n / 3;
    %for i = 1:m
    %    for j = 1:n
    %        H(i,j) = 0.114 * G(i,j,1) + 0.587*G(i,j,2) + 0.299 * G(i,j,3);
    %    end
    %end
    %imshow(H);
    H1 = edge(H, 'canny');
    H1 = double(H1);
    H1 = conv2(H1, [1 1:1 1]);
    %% 
    %% 
    %figure
    %imshow(H1);
    se1 = strel('line',1, 0);
    sr2 = strel('line',1,90);
    H2 = imdilate(H1, sr2);
    H2 = imdilate(H2, se1);
    H2 = imfill(H2, 'holes');
    H2 = bwareaopen(H2, 100);
    H2 = imclearborder(H2, 8);
    se = strel('disk',1);
    H3 = imerode(H2, se);
    H4 = imerode(H3, se);
    %size(H)
    %size(H4)
    H4 = H4(:,2:641);
    H4 = medfilt2(H4);
    %figure
    %imshow(H4);
    H4 = immultiply(H4, H);
    figure
    imshow(H4);
    level = graythresh(H4);
    H4 = im2bw(H4, level);
    H4 = bwareaopen(H4, 100);
    H4 = ~H4;
    %imshow(H4);
    H4 = bwareaopen(H4, 100);
    %figure
    %imshow(H4);
    I2=regionprops(H4,'BoundingBox','Image');
    for j = 1:length(I2)
       s = 'segment';
     %   s1 = 'Images\';
        s = strcat(s, int2str(j));
        %s1 = strcat(s1,s);
       % figure('name', s)
        s = strcat(s,'.jpg');
        %imshow(I2(i).Image)
        %imwrite(Iprops(i).Image, s,'jpg');
    end
end