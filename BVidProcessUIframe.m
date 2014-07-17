function [M,Mp,P,pellet]=BVidProcessUIframeI(I,extension,Crop,threshold1,backgroundS,Frames)
%Goes through current directory, importing each image of extension, converting to
%grayscale, and cropping according to Crop [xmin ymin width height].
%Outputs images to I. v1.1: commented rotation and cropping. crop outside
%of loop. image to frame conversions in separate loop. Threshold2 changes
%thresholding of difference image.v2:added removal of background image from
%the image array I. BackgroundS defines strength of background. V3 outputs
%only the processed movie and a binary movie with the head position and angle marked as
%well as an array of all head positions and orientations [x y angle].
%UI version plots each frame and waits for user input on pellet position.
%If there is a new pellet, mark it and press '1'. if it is the same pellet,
%press '2'. if there is no pellet, mark '3'. If there is no fish mark '4'.
%UIFrame shows only those frames specified in the input vector Frames
%(Frames must be sorted in increasing order. Press 1 to mark pellet
%location. pressing anything else wil end the program. I version takes in
%the image array I.

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

background=max(I,[],3);%generate background image
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

pellet=zeros(size(I,3),2);
j=1;
for(i=1:size(I,3))%make movies
    x=I(:,:,i);
    %x=histeq(x);%normalize intensities
    %thresh=graythresh(x);%find threshold
    %x=(x<=threshold1*thresh*255);%assign thresholded diff image
    y=gray2ind(x,60);%convert to index image
    M(i)=im2frame(y,gray);%convert image to frame
    button=50;
    if(i==Frames(j))
    imagesc(y);axis off;axis image;colormap(gray);
    set(gcf,'MenuBar','none');
    text(0,0,1.2,num2str(i));
    [xC,yC,button]=ginput(1);
    if(button==49)
        pellet(i,:)=[xC yC];
    else
        close(gcf)
        close(h)
        error('Not valid entry');
    end
    if(j<length(Frames))
    j=j+1;
    end
    end
    
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


movie2avi(M,'MII.avi');

movie2avi(M2,'M2II.avi');

close(h)
return