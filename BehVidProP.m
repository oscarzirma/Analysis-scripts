function BehVidProP(loadI,loadJ,loadK,loadpellet,loadL)
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
%to the pellet over time over 1 second and over 4 seconds. If load
%parameters are on the program will load that image array from the disk.

[loadI,loadJ,loadK,loadpellet,loadL]=RunTest(loadI,loadJ,loadK,loadpellet,loadL);

if(loadI)
cd(uigetdir('/Users/jasonschwarz/Documents/Experiments/2009/Behavior/'))

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
movie(M);
close(gcf);
pause(.1);
clear M;
else
    fprintf('Loading image array...\n');
    load I.mat;
    n=size(I,3);
end

%2. Check threshold. Background first.
if(loadJ)
Tb=2;
J=zeros(size(I),'uint8');
while(1)
    fprintf('Testing background threshold Tb=');
    fprintf(num2str(Tb));
    fprintf('...\r');
    
    background=median(I,3);%generate background image
    Z=uint8(ones(size(background))).*255;
    background=Z-background;%make negative of background image
    background=repmat(background,[1 1 n]);%build background image array of depth I
    J=I+(Tb.*background);%subtract background from image
    
    Mb=MakeMov(J(:,:,100:160),60);
    movie(Mb)
    close(gcf)
    pause(.1);
    
    ui1=input('Is the background subtraction satisfactory?(y/n)','s');
    fprintf('\r')
    if(ui1=='y')
        break
    else
        ui1=input('Enter a new value for Tb:');
        fprintf('\r');
        Tb=ui1;
    end
end
clear Mb Z background

save 'J' J %save background-subtracted image array.

else
    fprintf('Loading backgrounded image array...\n');
    load J.mat;
end

clear I;

%Test binary threshold.
if(loadK)
Tp=1.2;
while(1)
    fprintf('Testing binary threshold Tp=');
    fprintf(num2str(Tp));
    fprintf('...\r');
    
    for(i=100:150)
        x=J(:,:,i);
        x=imadjust(x);
        thresh=graythresh(x);%find threshold
        x=(x<=(Tp*thresh*255));%assign thresholded diff image
        x=uint8(x);
        %x=x.*(255/max(max(x)));
        imagesc(x),axis image
        pause(.1)
        %y=gray2ind(x,60);%convert to index image
        %Mp(i)=im2frame(y,hot);
    end
    close(gcf)
    pause(.1);

    ui1=input('Is the binary thresholding satisfactory (y/n)?','s');
    fprintf('\r')
    if(ui1=='y')
        break
    else
        ui1=input('What threshold would you like (lower values are more stringent)?');
        fprintf('\r');
        Tp=ui1;
    end
end

fprintf('Producing thresholded image array...')

%K=zeros(size(J));

h = waitbar(0,'Producing thresholded image array...');

for(i=1:n)
    x=J(:,:,i);
    x=imadjust(x);
    thresh=graythresh(x);%find threshold
    x=(x<=Tp*thresh*255);%assign thresholded diff image
    K(:,:,i)=x;
    if(mod(i,50)==0)
        waitbar(i/n,h,'Producing thresholded image array...')
    end
end
close(h);
save 'K' K;
else
    fprintf('Loading binary image array...\n');
load K.mat
end
clear J;

load I.mat;
%Find pellet locations
if(loadpellet)
fprintf('Press any key to begin pellet locations.\n');pause();
for(i=1:n)%playy through video 40 frames at a time prompting if there is a pellet.
    imshow(I(:,:,i));
    text(-15,-10,num2str(i),'Color',[0 0 0]);
    pause(.05)
    if((mod(i,40)==0)||(i==n))
        close(gcf)
        r=input('Was there a pellet(y/n)?\n','s');%prompt for pellet
        if(r=='y')%if yes, start playing backward for 40 frames

                tmp=i-39;
                if(tmp<=0)
                    tmp=1;
                end
                h = uicontrol(gcf,'Position',[100 330 60 30],...%this uicontrol stops the playback and brings up the ginput control
                'String','Pellet',...
                'Callback', 'setappdata(gcf, ''run'', 0)');
                flag = 1;
                setappdata(gcf, 'run', flag);
                h2=uicontrol(gcf,'Position',[100 290 60 30],...%this uicontrol reverses the playback by 1 frames
                 'String','Go Forward',...
                 'Callback','setappdata(gcf,''gb'',0)');
                flag2=1;
                setappdata(gcf, 'gf', flag2);
                h3=uicontrol(gcf,'Position',[100 250 60 30],...%this uicontrol forwards the playback by 1 frames
                 'String','Go Back',...
                 'Callback','setappdata(gcf,''gf'',0)');
                flag3=1;
                setappdata(gcf, 'pause', flag3);
                h4=uicontrol(gcf,'Position',[100 210 60 30],...%this uicontrol puases the playback by 1 frames
                 'String','Pause',...
                 'Callback','setappdata(gcf,''pause'',0)');
                flag4=1;
                setappdata(gcf, 'pause', flag4);                
                h4=uicontrol(gcf,'Position',[100 170 60 30],...%this uicontrol puases the playback by 1 frames
                 'String','Cancel',...
                 'Callback','setappdata(gcf,''cancel'',0)');
                flag5=1;
                setappdata(gcf, 'cancel', flag5); 
                
                j=i;flip=1;%initialize indices
                while(1)%j will increment downward until a button is pressed. then it will be user controlled.
                
                
                    flag = getappdata(gcf, 'run');%update flag variables from buttons
                    flag2=getappdata(gcf,'gb');
                    flag3=getappdata(gcf,'gf');
                    flag4=getappdata(gcf,'pause');
                    flag5=getappdata(gcf,'cancel');
                
                drawnow
                if(flag5==0)
                    break
                elseif(flag2==0)
                    flip=-1;
                    setappdata(gcf,'gb',1);
                    if(flag4==0)
                        j=j+1;
                    end
                elseif(flag3==0)
                    flip=1;
                    setappdata(gcf,'gf',1);
                    if(flag4==0)
                        j=j-1;
                    end
                end 
                if(flag4==0)
                    uiwait(gcf,.1);
                else
                j=j-(1*flip);
                end

                if(j==tmp)
                    flip=-flip;
                elseif(j==i)
                    flip=-flip;
                    j=i-1;
                end
                flag = getappdata(gcf, 'run');%update flag variables from buttons
                if(flag==0)%if the pellet button has been pressed, bring up ginput
                    [xC,yC,button]=ginput(1);
                    pellet(j,:)=[xC yC];
                    break;
                end
                    imshow(I(:,:,j))
                    text(-15,-10,num2str(j),'Color',[0 0 0]);
                    pause(.15)
            end
        end
    end
    
end
close(gcf)
clear flag flag1 flag2 flag3 flag4 flag5 tmp flip
save 'pellet' pellet;
else
    fprintf('Loading pellet.mat...\n');
    load pellet.mat;
end

clear I

if(loadL)
fprintf('Finding fish positions...\n')
h = waitbar(0,'Finding fish positions...');
%L=zeros(size(K));

for(i=1:n)
    tic
    x=K(:,:,i);
    [P3 O c]=PosOrient(x,0);
    P(i,:)=[P3 O];  
    P3=round(P3);
    c=round(c);
    x=uint8(x);
    x(P3(2)-2:P3(2)+2,P3(1)-2:P3(1)+2)=ones(5).*3;
    [ind label]=drawline([P3(2) P3(1)],[c(2) c(1)],size(x));
    x(ind)=label.*3;
    L(:,:,i)=x;
    if(mod(i,50)==0)
        waitbar(i/n,h,'Finding fish positions...')
    end
    toc
end

save 'L' L;
save 'positions' P;
else
    fprintf('Loading fish positions...\n');
    load L.mat
    load positions.mat
end
clear K;
%look at responses after 1 second
[mPosition,Speed,AngVel,RelPos,PelletIndices,RelDis,RelAng]=FishBehavior(P,pellet,size(L(:,:,1),2),14,8,8);

save 'RelDis1s' RelDis;
save 'RelAng1s' RelAng;
%look at responses after 4 seconds
[mPosition,Speed,AngVel,RelPos,PelletIndices,RelDis,RelAng]=FishBehavior(P,pellet,size(L(:,:,1),2),14,8,32);

save 'RelDis4s' RelDis;
save 'RelAng4s' RelAng;

fprintf('Building final movies...\n');

M=zeros(size(L,1),size(L,2),40*nnz(pellet)/2);%produce an error check movie with each trial
index=1;
pell=ones(3).*3;

for(i=1:size(pellet,1))
    if(pellet(i,1)~=0)
        d=i-16;
        if(i<17)
            d=1;
        end
        e=i+48;
        if(e>n)
            e=n;
        end
        
        for(j=d:e)
            x=L(:,:,j);
            row=round(pellet(i,2));
            col=round(pellet(i,1));
            x(row-1:row+1,col-1:col+1)=pell;
            imagesc(x),axis image
            M(:,:,index)=x;
            pause(.01)
            index=index+1;
        end
        pause()
    end
    
end
close(gcf)
fprintf('Saving M file...\n');    
save 'M.mat' M
    
return
 %------------------------------------------------
function [loadI,loadJ,loadK,loadpellet,loadL]=RunTest(loadI,loadJ,loadK,loadpellet,loadL)

if(strcmp(loadI,'LoadIOn'))
    loadI=0;
else 
    loadI=1;
end
if(strcmp(loadJ,'LoadJOn'))
    loadJ=0;
else
    loadJ=1;
end
if(strcmp(loadK,'LoadKOn'))
    loadK=0;
else
    loadK=1;
end
if(strcmp(loadpellet,'LoadPelletOn'))
    loadpellet=0;
else
    loadpellet=1;
end
if(strcmp(loadL,'LoadLOn'))
    loadL=0;
else
    loadL=1;
end
return



