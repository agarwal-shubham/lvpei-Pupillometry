clear; clc; close all;
im = imread('./t3.png');
[h,w,~] = size(im);
gray = rgb2gray(im);
e = edge(gray,'canny',0.1);
[y,x] = find(e==1);
% imshow(e)
avg = mean(im(:));
% 123 142
if avg <=131
    numOcclusion = 6;
else
    numOcclusion = 2;
end
imshow(e)

[centersDark, radiiDark] = imfindcircles(e, [30 80], 'ObjectPolarity', 'dark', 'Sensitivity', 1);
pupil_center = [centersDark(1,1), centersDark(1,2)];
pupil_rad = radiiDark(1);
offset = 10;

% mask = false(size(gray));
% mask(pupil_center(2)-pupil_rad-offset:pupil_center(2)+pupil_rad+offset, pupil_center(1)-pupil_rad-offset:pupil_center(1)+pupil_rad+offset) = true;
% bw = activecontour(gray, mask, 200, 'edge');
% imshow(bw)

for i = 1:size(y,1)
    dst = ( (pupil_center(1)-x(i))^2 ) + ( (pupil_center(2)-y(i))^2 );% - (pupil_rad^2);
    d = abs(sqrt(dst)-pupil_rad);
    if d <= offset
        for j = 1:3
            im(y(i),x(i),j) = 255;
        end
    end
end

occlusionMask = [];
for i=pupil_center(2)-pupil_rad-15:pupil_center(2)+pupil_rad+15
    for j=pupil_center(1)-pupil_rad-offset:pupil_center(1)+pupil_rad+offset
        if gray(floor(i),floor(j)) >= 170
            occlusionMask = [occlusionMask; floor(i) floor(j)];
        end
    end
end
for i=1:size(occlusionMask,1)
        im(occlusionMask(i,1),occlusionMask(i,2),1) = 255;%im(pupil_center(2),pupil_center(1),1);
        im(occlusionMask(i,1),occlusionMask(i,2),2) = 0;%im(pupil_center(2),pupil_center(1),2);
        im(occlusionMask(i,1),occlusionMask(i,2),3) = 0;%im(pupil_center(2),pupil_center(1),3);
end
figure, 
imshow(im)