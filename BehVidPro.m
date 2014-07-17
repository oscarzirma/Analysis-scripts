function BehVidPro()
%Control program to run the behavioral analysis from videos. Does the
%following:
%1. Crops the image.
%2. Outputs default background and binary thresholds and asks if they are
%acceptable. If unacceptable will ask for adjustment to the values and
%display the effect of the adjustment.
%3. Plays through the basic video allowing for user control. Space will
%pause the video. One paused, video can be rolled back with the left arrow
%and pushed forward with the right arrow. When there is a pellet, the user
%presses 'p' and a cursor will come up allowing the user to click on the
%pellet position. The video will then continue.
%4. The program then will save three image arrays: I (basic images), J
%(backgrounded images), K (thresholded images), and L (images with fish
%positions, orientation, and trajectories as well as pellet positions
%calculated). The program also saves the pellet positions and fish
%positions. It will save and output arrays with distance and angle relative
%to the pellet over time over 1 second and over 4 seconds.

%cd(uigetdir('/Users/jasonschwarz/Documents/Experiments/2009/Behavior/'))

file=dir('*.png');
n=length(file);


%1. Crop file.
x=imread(file(10).name);
[tmp c]=imcrop(x);

close gcf;
pause(.1)


fprintf('Loading file...')
h = waitbar(0,'Loading file...');

I=zeros(size(tmp,1),size(tmp,2),n,'uint8');

for(i=1:n)
    x=imread(file(i).name);%read in image
    y=imcrop(x,c);%crop
    z=imadjust(rgb2gray(y));%convert to grayscale and enhance contrst
    I(:,:,i)=z;%assign to output matrix 
    if(mod(i,50)==0)
        waitbar(i/size(I,3),h,'Loading file...')
    end
end
close(h);
save 'I' I

fprintf('Done.\r')


fprintf('Basic Movie Sample\r')
M=MakeMov(I(:,:,100:160),60);
%movie(M);
close(gcf);
pause(.1);
clear M;

%2. Check threshold. Background first.
Tb=1;
J=zeros(size(I),'uint8');
while(1)
    fprintf('Testing background threshold Tb=');
    fprintf(num2str(Tb));
    fprintf('...\r');
    
    background=median(I,3);%generate background image
    Z=uint8(ones(size(background))).*255;
    background=Z-background;%make negative of background image
    background=repmat(background,[1 1 i]);%build background image array of depth I
    J=I+(Tb.*background);%subtract background from image
    
    Mb=MakeMov(J(:,:,100:160),60);
    movie(Mb)
    close(gcf)
    pause(.1);
    
    ui1=input('Is the background subtraction satisfactory (y/n)?','s');
    fprintf('\r')
    if(ui1=='y')
        break
    else
        ui1=input('Is the background still too strong or is the fish too weak (s/w)?','s');
        fprintf('\r');
        if(ui1=='s')
            Tb=Tb*1.1;
        else
            Tb=Tb*0.9;
        end
    end
end
clear Mb Z background

save 'J' J %save background-subtracted image array.

%Test binary threshold.

Tp=1;
while(1)
    fprintf('Testing binary threshold Tp=');
    fprintf(num2str(Tp));
    fprintf('...\r');

    for(i=100:160)
        x=J(:,:,i);
        x=imadjust(x);
        thresh=graythresh(x);%find threshold
        x=(x<=Tp*thresh*255);%assign thresholded diff image
        x=uint8(x);
        x=x.*(255/max(max(x)));
        K(:,:,i)=x;
        %y=gray2ind(x,60);%convert to index image
        %Mp(i)=im2frame(y,hot);
    end

    Mp=MakeMov(K,60);
    movie(Mp)
    close(gcf)
    pause(.1);

    ui1=input('Is the binary thresholding satisfactory (y/n)?','s');
    fprintf('\r')
    if(ui1=='y')
        break
    else
        ui1=input('Is the thresholding too stringent or too weak (s/w)?','s');
        fprintf('\r');
        if(ui1=='s')
            Tp=Tp*.9;
        else
            Tp=Tp*1.1;
        end
    end
end

clear Mp K

fprintf('Producing thresholded image array...')

K=zeros(size(J));

h = waitbar(0,'Producing thresholded image array...');

for(i=1:length(file))
    x=J(:,:,i);
    x=imadjust(x);
    thresh=graythresh(x);%find threshold
    x=(x<=Tp*thresh*255);%assign thresholded diff image
    x=uint8(x);
    x=x.*(255/max(max(x)));
    K(:,:,i)=x;
    if(mod(i,50)==0)
        waitbar(i/size(I,3),h,'Producing thresholded image array...')
    end
end
close(h);
save 'K' K;
clear J;

for(i=1:n)
    imshow(I(:,:,i));
    
    t=getkeywait(.1);
    
    if(t==112)
        if(i<20)
            tmp=0;
        else
            tmp=i-20;
        end
        for(j=tmp:i)
            imshow(I(:,:,j))
            r=getkeywait(.5);
            if(r==112);
                [xC,yC,button]=ginput(1);
                pellet(i,:)=[xC yC];
                break;
            end
        end
    end
    
end



return