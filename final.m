clear all; clc; clear all;
vidObj=VideoReader('./Type 1/N307696_0_left.avi');
numFrames=get(vidObj,'NumberOfFrames');
im=read(vidObj,1);
[h,w,~]=size(im);
hh=floor(h/5); ww=floor(w/6);
fin=zeros([h w 3 numFrames],class(im));
for k=1:numFrames
    im=read(vidObj,k);
    
    fin(:,:,:,k)=im;
end

frameRate=get(vidObj,'FrameRate');
implay(fin,frameRate);