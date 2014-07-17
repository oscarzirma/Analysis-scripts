function [I J]=BVidProcessImageExtract(extension,Crop,backgroundS)
%Goes through current directory, importing each image of extension, converting to
%grayscale, and cropping according to Crop [xmin ymin width height].
%Outputs images to I. v1.1: commented rotation and cropping. crop outside
%of loop. image to frame conversions in separate loop. Threshold2 changes
%thresholding of difference image.v2:added removal of background image from
%the image array I. BackgroundS defines strength of background. V3 outputs
%only the processed movie and a binary movie with the head position and angle marked as
%well as an array of all head positions and orientations [x y angle].V5
%merely produces the movies, printing the frame of each movie as well. It
%does not calculate position etc.

file=dir(extension);
h = waitbar(0,'Please wait...');

for(i=1:length(file))
        if(mod(i,10)==0)
        waitbar(i/length(file),h,i)
    end
    x=imread(file(i).name);%read in image
    y=imcrop(x,Crop);%crop
    z=imadjust(rgb2gray(y));%convert to grayscale and enhance contrst
    I(:,:,i)=z;%assign to output matrix 
end
close(h)

clear x y z;

background=median(I,3);%generate background image
Z=uint8(ones(size(background))).*255;
background=Z-background;%make negative of background image
background=repmat(background,[1 1 i]);%build background image array of depth I
J=I+(backgroundS.*background);%subtract background from image

return