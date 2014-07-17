function [M,Mb,Mt]=BehThresholdTest(extension,Crop,threshold1,backgroundS)
%Input the first 200 images in the current directory and output raw Movie 
%background subracted movie, and thresholded movie.

file=dir(extension);

for(i=1:200)
    x=imread(file(i).name);%read in image
    y=imcrop(x,Crop);%crop
    z=imadjust(rgb2gray(y));%convert to grayscale and enhance contrst
    I(:,:,i)=z;%assign to output matrix 
end

clear x y z;

background=median(I,3);%generate background image
Z=uint8(ones(size(background))).*255;
background=Z-background;%make negative of background image
background=repmat(background,[1 1 i]);%build background image array of depth I
J=I+(backgroundS.*background);%subtract background from image

%T=I;difference image production
%T(:,:,1)=[];
%T(:,:,size(T,3)+1)=zeros(size(T(:,:,1)));%produce a new image matrix for finding difference.
%D=imabsdiff(I,T);%find difference matrix
%D(:,:,size(D,3))=[];

for(i=1:size(I,3))%make movies
    x=I(:,:,i);
    y=gray2ind(x,50);%convert to index image
    M(i)=im2frame(y,gray);%convert image to frame
    x=J(:,:,i);
     y=gray2ind(x,50);%convert to index image
    Mb(i)=im2frame(y,gray);%convert image to frame
    
    thresh=graythresh(x);%find threshold
    x=(x<=threshold1*thresh*255);%assign thresholded diff image
    x=uint8(x);
    x=x.*(255/max(max(x)));
    y=gray2ind(x,60);%convert to index image
    Mt(i)=im2frame(y,hot);
end    

return