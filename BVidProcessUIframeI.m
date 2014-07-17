function [M,Mp,P,pellet]=BVidProcessUIframeI(I,threshold1,Frames)
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

h = waitbar(0,'Please wait...');

pellet=zeros(size(I,3),2);
j=1;
for(i=1:size(I,3))%make movies
    x=I(:,:,i);
    y=gray2ind(x,60);%convert to index image
    M(i)=im2frame(y,gray);%convert image to frame
    button=50;
    if(i==Frames(j))
        imagesc(I(:,:,i-1));axis off;axis image;colormap(gray);
        set(gcf,'MenuBar','none');
        text(0,0,1.2,num2str(i-1));
        figure,imagesc(I(:,:,i+1));axis off;axis image;colormap(gray);
        set(gcf,'MenuBar','none');
        text(0,0,1.2,num2str(i+1));
        pause()
        figure,imagesc(y);axis off;axis image;colormap(gray);
        set(gcf,'MenuBar','none');
        text(0,0,1.2,num2str(i));
        [xC,yC,button]=ginput(1);
        close,close,close
        if(button==49)
            pellet(i,:)=[xC yC];
        else
            close(all)
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
        waitbar(i/size(I,3),h,i)
    end
end    

close(h)
return