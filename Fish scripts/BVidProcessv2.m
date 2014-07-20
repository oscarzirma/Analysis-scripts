function [I,It,M,Mt,D,N]=BVidProcessv2(extension,Crop,threshold1,threshold2,backgroundS)
%Goes through current directory, importing each image of extension, converting to
%grayscale, and cropping according to Crop [xmin ymin width height].
%Outputs images to I. v1.1: commented rotation and cropping. crop outside
%of loop. image to frame conversions in separate loop. Threshold2 changes
%thresholding of difference image.v2:added removal of background image from
%the image array I. BackgroundS defines strength of background.

file=dir(extension);
h = waitbar(0,'Please wait...');

for(i=1:length(file))
    x=imread(file(i).name);%read in image
    y=imcrop(x,Crop);%crop
    z=imadjust(rgb2gray(y));%convert to grayscale and enhance contrst
    I(:,:,i)=z;%assign to output matrix 
    if(mod(i,10)==0)
        waitbar(i/length(file),h,i)
    end
end
close(h)

clear x y z;

background=max(I,[],3);%generate background image
Z=uint8(ones(size(background))).*255;
background=Z-background;%make negative of background image
background=repmat(background,[1 1 i]);%build background image array of depth I
I=I+(backgroundS.*background);%subtract background from image

T=I;
T(:,:,1)=[];
T(:,:,size(T,3)+1)=zeros(size(T(:,:,1)));%produce a new image matrix for finding difference.
D=imabsdiff(I,T);%find difference matrix
D(:,:,size(D,3))=[];

h = waitbar(0,'Please wait...');

for(i=1:size(I,3))%make movies
    x=I(:,:,i);
    %x=histeq(x);%normalize intensities
    %thresh=graythresh(x);%find threshold
    %x=(x<=threshold1*thresh*255);%assign thresholded diff image
    y=gray2ind(x,50);%convert to index image
    M(i)=im2frame(y,gray);%convert image to frame
    
    thresh=graythresh(x);%find threshold
    x=(x<=threshold1*thresh*255);%assign thresholded diff image
    It(:,:,i)=x;
    y=gray2ind(x,50);%convert to index image
    Mt(i)=im2frame(y,gray);
    
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