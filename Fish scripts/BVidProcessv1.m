function [I,M,D,N]=BVidProcessv1(extension,Crop,threshold1,threshold2)
%Goes through current directory, importing each image of extension, converting to
%grayscale, and cropping according to Crop [xmin ymin width height].
%Outputs images to I. v1.1: commented rotation and cropping. crop outside
%of loop. image to frame conversions in separate loop. Threshold changes
%thresholding of difference image.

file=dir(extension);
h = waitbar(0,'Please wait...');

for(i=1:length(file))
    x=imread(file(i).name);%read in image
    y=imcrop(x,Crop);%crop
    z=rgb2gray(y);%convert to grayscale
    I(:,:,i)=z;%assign to output matrix 
    if(mod(i,10)==0)
        waitbar(i/length(file),h,i)
    end
end



T=I;
T(:,:,1)=[];
T(:,:,size(T,3)+1)=zeros(size(T(:,:,1)));%produce a new image matrix for finding difference.
D=imabsdiff(I,T);%find difference matrix
D(:,:,size(D,3))=[];

for(i=1:size(I,3))%make movies
    x=I(:,:,i);
    x=histeq(x);%normalize intensities
    thresh=graythresh(x);%find threshold
    x=(x<=threshold1*thresh*255);%assign thresholded diff image
    x=gray2ind(x,50);%convert to index image
    M(i)=im2frame(x,gray);%convert image to frame
    
    if(i>1)%make difference movie
        x=D(:,:,i-1);
        thresh=graythresh(x);%find threshold
        x=(x>=threshold2*thresh*255);%assign thresholded diff image
        N(i-1)=im2frame(gray2ind(x,50),gray);
    end
    if(mod(i,10)==0)
        waitbar(i/length(file),h,i)
    end
end    


close(h)
return