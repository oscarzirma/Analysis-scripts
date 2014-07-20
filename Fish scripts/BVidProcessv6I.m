function [M,Mp K D]=BVidProcessv6I(I,threshold1)
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

h = waitbar(0,'Please wait...');

M=[];Mp=M;

x=I(:,:,1);
[m,n]=size(x);
fpos=[80 50 n m];

fig1=figure(1);
axis off;axis image;colormap(gray);
set(gcf,'MenuBar','none','Position',fpos,'Color','k');
set(fig1,'NextPlot','replacechildren')
pause(.1)

for(i=1:size(I,3))%make movies
    x=I(:,:,i);
    %x=imadjust(x);
    %y=gray2ind(x,50);%convert to index image
    %imagesc(y);
    %text(0,-10,1.2,num2str(i),'Color',[1 1 1]);
    %pause(.01)
    %M(i)=getframe(gcf);%convert image to frame
    
    T=I;%difference image production
    T(:,:,1)=[];
    T(:,:,size(T,3)+1)=zeros(size(T(:,:,1)));%produce a new image matrix for finding difference.
    D=imabsdiff(I,T);%find difference matrix
    D(:,:,size(D,3))=[];
    
    thresh=graythresh(x);%find threshold
    x=(x<=threshold1*thresh*255);%assign thresholded diff image
    
    x=uint8(x);
    x=x.*(255/max(max(x)));
    K(:,:,i)=x;
    %y=gray2ind(x,60);%convert to index image
    %Mp(i)=im2frame(y,hot);

    if(mod(i,50)==0)
        waitbar(i/size(I,3),h,i)
    end
end    

close(h)
close(gcf)
return