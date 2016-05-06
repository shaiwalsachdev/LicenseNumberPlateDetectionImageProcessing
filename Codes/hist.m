clc;
clear all;
close all;
imtool close all;
workspace;
I = imread('D:\Study\6th Sem\Image Processing\Project\Test\DSCN0410.jpg');
figure
imshow(I);
%I = imresize(I,[680 480]);
Igray = rgb2gray(I);
Igray = medfilt2(Igray);
[r,c] = size(Igray);
Idilate = Igray;
for i = 1:r
    for j = 2:c-1
        tmp = max(Igray(i,j-1),Igray(i,j));
        Idilate(i,j) = max(tmp,Igray(i,j+1));
    end
end
I = Idilate;
figure('name','Gray');
imshow(Igray);
figure('name','DilatedImage');
imshow(Idilate);
figure
imshow(I)
diff = 0;
sum = 0;
tot_sum = 0;
diff = uint32(diff);
%Horizontal Edge Processing
max_horz = 0;
maximum = 0;
for i = 2:c
    sum = 0;
    for j = 2:r
        if (I(j,i)>I(j-1,i))
            diff = uint32(I(j,i)-I(j-1,i));
        else
            diff = uint32(I(j-1,i)-I(j,i));
        end
        if (diff > 20)
            sum = sum + diff;
        end
    end
    horz1(i) = sum;
    if (sum > maximum) 
        max_horz = i;
        maximum = sum;
    end
    tot_sum  = tot_sum + sum;
end
average = tot_sum / c;

figure
subplot(3,1,1);
plot(horz1);
title('Horizontal Edge Processing');
xlabel('Column Number');
ylabel('Difference');
%Smoothing horizonatal by low pass filter
sum = 0;
horz = horz1;
for i = 21:(c-21)
    sum = 0;
    for j = (i-20):(i+20)
        sum = sum + horz1(j);
    end
    horz(i) = sum / 41;
end
subplot(3,1,2);
plot(horz);
title('Histogram after low pass filter');
xlabel('Col Number');
ylabel('Difference');
%Filtering Horizontal Histogram
 for i = 1:c
     if (horz(i) < average)
         horz(i) = 0;
         for j = 1:r
             I(j,i) = 0;
         end
     end
 end
 subplot(3,1,3);
 plot(horz);
 title('Filtered Histogram');
 xlabel('Col Num');
 ylabel('Difference');
 %Vertical Edge processing
 diff = 0;
 tot_sum = 0;
 diff = uint32(diff);
 maximum = 0;
 max_vert = 0;
 for i = 2:r
     sum = 0;
     for j = 2:c
         if (I(i,j)>I(i,j-1))
             diff = uint32(I(i,j)-I(i,j-1));
         end
         if (I(i,j)<=I(i,j-1))
             diff = uint32(I(i,j-1)-I(i,j));
         end
         if (diff > 20)
             sum = sum + diff;
         end
     end
     vert1(i) = sum;
     if (sum > maximum) 
         max_vert = i;
         maximum = sum;
     end
     tot_sum = tot_sum + sum;
 end
 average = tot_sum / r;
 
 figure
 subplot(3,1,1);
 plot(vert1);
 title('Vertical Edge processing');
 xlabel('Row');
 ylabel('Difference');
 
 %Smoothing Vertical Histogram
 sum = 0;
 vert = vert1;
 for i = 21:(r-21)
     sum = 0;
     for j = (i-20):(i+20)
         sum = sum + vert1(j);
     end
     vert(i) = sum / 41;
 end
 subplot(3,1,2);
 plot(vert);
 title('Vertical Edge after Low Pass filter');
 xlabel('Rows');
 ylabel('diff');
 %Dyanamic Threshold
 for i = 1:r
     if (vert(i) < average)
         vert(i) = 0;
         for j = 1:c
             I(i,j) = 0;
         end
     end
 end
 subplot(3,1,3)
 plot(vert);
 title('Histogram after filtering');
 xlabel('Rows');
 ylabel('Diff');
 figure
 imshow(I);
 %Probable candidates for the LP
 j = 1;
 for i = 2:c-2
     if (horz(i)~=0&&horz(i-1)==0&&horz(i+1)==0)
         column(j) = i;
         column(j+1)=i;
         j = j + 2;
     elseif((horz(i)~=0&&horz(i-1)==0)||(horz(i)~=0&&horz(i+1)==0))
         column(j)=i;
         j = j + 1;
     end
 end
 
 j = 1;
 for i = 2:r-2
     if(vert(i)~=0&&vert(i-1)==0&&vert(i+1)==0)
         row(j) = i;
         row(j+1) = i;
         j = j + 2;
     elseif((vert(i)~=0&&vert(i-1)==0)||(vert(i)~=0&&vert(i+1)==0))
         row(j) = i;
         j = j + 1;
     end
 end
 
 [temp,col_size] = size(column);
 if(mod(col_size,2))
     column(col_size+1) = c;
 end
 
 [tmp,row_size] = size(row);
 if(mod(row_size,2))
     row(row_size+1) = r;
 end
 %Region of interset
 for i = 1:2:row_size
     for j = 1:2:col_size
         if (~((max_horz>=column(j)&&max_horz<=column(j+1))&&(max_vert>=row(i)&&max_vert<=row(i+1))))
             for m = row(i):row(i+1)
                 for n = column(j):column(j+1)
                     I(m,n) = 0;
                 end
             end
         end
     end
 end
 
 figure
 imshow(I);