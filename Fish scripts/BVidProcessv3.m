function [M,Mp,P]=BVidProcessv3(extension,Crop,threshold1,backgroundS)
%Goes through current directory, importing each image of extension, converting to
%grayscale, and cropping according to Crop [xmin ymin width height].
%Outputs images to I. v1.1: commented rotation and cropping. crop outside
%of loop. image to frame conversions in separate loop. Threshold2 changes
%thresholding of difference image.v2:added removal of background image from
%the image array I. BackgroundS defines strength of background. V3 outputs
%only the processed movie and a binary movie with the head position and angle marked as
%well as an array of all head positions and orientations [x y angle].

file=dir(extension);
file(1).name
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

background=min(I,[],3);%generate background image
Z=uint8(ones(size(background))).*255;
background=Z-background;%make negative of background image
background=repmat(background,[1 1 i]);%build background image array of depth I
I=I+(backgroundS.*background);%subtract background from image

%T=I;difference image production
%T(:,:,1)=[];
%T(:,:,size(T,3)+1)=zeros(size(T(:,:,1)));%produce a new image matrix for finding difference.
%D=imabsdiff(I,T);%find difference matrix
%D(:,:,size(D,3))=[];

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
    [P3 O c]=PosOrient(x,0);
    P(i,:)=[P3 O];
    P3=round(P3);
    c=round(c);
    x=uint8(x);
    x(P3(2)-2:P3(2)+2,P3(1)-2:P3(1)+2)=ones(5).*3;
    [ind label]=drawline([P3(2) P3(1)],[c(2) c(1)],size(x));
    x(ind)=label.*3;
    x=x.*(255/max(max(x)));
    y=gray2ind(x,60);%convert to index image
    Mp(i)=im2frame(y,hot);
    
    %if(i>1)%make difference movie
    %    x=D(:,:,i-1);
    %    thresh=graythresh(x);%find threshold
    %    x=(x>=threshold2*thresh*255);%assign thresholded diff image
    %    N(i-1)=im2frame(gray2ind(x,50),gray);
    %end
    if(mod(i,10)==0)
        waitbar(i/length(file),h,i)
    end
end    


close(h)
return