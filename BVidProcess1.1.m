function [I,M,D,N]=BVidProcess1_1(extension,Crop,rotation)
%Goes through current directory, importing each image of extension, converting to
%grayscale, and cropping according to Crop [xmin ymin width height].
%Outputs images to I. v1.1: commented rotation and cropping. crop outside
%of loop. image to frame conversions in separate loop.

file=dir(extension);
h = waitbar(0,'Please wait...');

for(i=1:length(file))
    tic
    w=imread(file(i).name);%read in image
    %x=imrotate(w,rotation,'bilinear');%rotate
    x=w;
    %y=imcrop(x,Crop);%crop
    z=rgb2gray(y);%convert to grayscale
    I(:,:,i)=z;%assign to output matrix
    %E(:,:,i)=edge(z);%assign edge image to output edge matrix
    if(i>1)
        x=imabsdiff(I(:,:,i),I(:,:,i-1));%find difference image
        thresh=graythresh(x);%find threshold
        x=(x>=5*thresh*255);%assign thresholded diff image
    end
    waitbar(i/length(file),h,i)
    toc
end
        %x=gray2ind(x,10);
        %N(i-1)=im2frame(x,gray);
        %D(:,:,i-1)=x;

close(h)
return