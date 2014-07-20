function BehVidProPv2(loadI,loadpellet,loadIp,loadJ,loadK,loadL)
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
%
%Version 2 loads the files and immediately asks for pellet locations. It
%then produces a reduced image array Ip that contains only frames that fall
%witin 16 frames before a pellet or 56 frames after a pellet. The rest of
%the analysis uses that image dataset. The binary thresholding has also
%been vectorized. Also fixed pellet input so that if 'Pellet' is hit
%accidentally you can press the right mouse button to cancel the input. You
%can then move through the movie one frame at a time using the go forward
%and go back buttons.

[loadI,loadpellet,loadIp,loadJ,loadK,loadL]=RunTest(loadI,loadpellet,loadIp,loadJ,loadK,loadL);

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
close(h)
d=pwd;
for(i=length(d):-1:1)
    if(d(i)=='/')
        break
    end
end
mkdir([d(i+1:length(d)) 'Data']);
cd([d(i+1:length(d)) 'Data']);

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


%Find pellet locations
if(loadpellet)
fprintf('Press any key to begin pellet locations.\n');pause();
pellet=zeros(n,2);
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
                h = uicontrol(gcf,'Position',[70 330 100 30],...%this uicontrol stops the playback and brings up the ginput control
                'String','Pellet',...
                'Callback', 'setappdata(gcf, ''run'', 0)');
                flag = 1;
                setappdata(gcf, 'run', flag);
                h2=uicontrol(gcf,'Position',[70 290 100 30],...%this uicontrol reverses the playback by 1 frames
                 'String','Go Forward',...
                 'Callback','setappdata(gcf,''gb'',0)');
                flag2=1;
                setappdata(gcf, 'gf', flag2);
                h3=uicontrol(gcf,'Position',[70 250 100 30],...%this uicontrol forwards the playback by 1 frames
                 'String','Go Back',...
                 'Callback','setappdata(gcf,''gf'',0)');
                flag3=1;
                setappdata(gcf, 'pause', flag3);
                h4=uicontrol(gcf,'Position',[70 210 100 30],...%this uicontrol puases the playback by 1 frames
                 'String','Pause',...
                 'Callback','setappdata(gcf,''pause'',0)');
                flag4=1;
                setappdata(gcf, 'pause', flag4);                
                h4=uicontrol(gcf,'Position',[70 170 100 30],...%this uicontrol puases the playback by 1 frames
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
                    imshow(zeros(size(I(:,:,1))));
                    pause(.6)
                    close(gcf)
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
                    if(button==1)
                        pellet(j,:)=[xC yC];
                        close(gcf);
                        break;
                    else
                        setappdata(gcf,'run',1)
                    end
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

if(loadIp)
    fprintf('Generating reduced image array...\n');
h = waitbar(0,'Generating reduced image array...');
%Generate reduced image array
pellRed=zeros(size(pellet,1),1);
shif=ones(72,1);
iPellet=find(pellet(:,1));

for(j=1:length(iPellet))
    i=iPellet(j);
    if((pellet(i,1)+pellet(i,2))~=0)
        if(i<16)
            72-(16-i)
            shif1=ones(72-(16-i),1);
            pellRed(1:72-(16-i))=shif1;
        elseif(i+56>n)
            16+(n-i)
            size(pellRed)
            shif1=ones(16+(n-i),1);
            pellRed(i-15:end)=shif1;            
        else
            pellRed(i-15:i+56)=shif;
        end
    end
end

I2=zeros(size(I,1),size(I,2),sum(pellRed));
pellet2=zeros(sum(pellRed),2);
index=1;

for(i=1:length(pellRed))

    if(pellRed(i)==1)
        pellet2(index,:)=pellet(i,:);
        I2(:,:,index)=I(:,:,i);
        index=index+1;
    end
    if(mod(i,50)==0)
        waitbar(i/size(I,3),h,'Generating reduced image array...')
    end
end

%close h

I=uint8(I2);

fprintf('Image array size went from ');
disp(n);
n=size(I,3);
fprintf(' to ');
disp(n);
save 'Ip.mat' I;
save 'pellet2.mat' pellet2;
else
    fprintf('Loading Ip...\n');
    load pellet2.mat;
    load Ip.mat;
    n=size(I,3);
end


%2. Check threshold. Background first.
if(loadJ)
Tb=1;
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
    
    index=round(.05*n);
    Mb=MakeMov(J(:,:,index:index+60),60);
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
Tp=1.2;index=round(.05*n);
while(1)
    fprintf('Testing binary threshold Tp=');
    fprintf(num2str(Tp));
    fprintf('...\r');

    thresh=graythresh(J);
    K=(J<=(Tp*thresh*255));
    K=uint8(K);
    for(i=index:index+50)
        imagesc(K(:,:,i)),axis image
        pause(.05)
    end
    close(gcf)

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

save 'K' K;

else
    fprintf('Loading binary image array...\n');
load K.mat
end
clear J;

clear I

if(loadL)
fprintf('Finding fish positions...\n')
h = waitbar(0,'Finding fish positions...');

for(i=1:n)
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
end
close(h);
save 'L' L;
save 'positions' P;
else
    fprintf('Loading fish positions...\n');
    load L.mat
    load positions.mat
end

clear K;
%look at responses after 1 second
[mPosition,Speed,AngVel,RelPos,PelletIndices,RelDis,RelAng]=FishBehaviorv2(P,pellet2,size(L(:,:,1),2),14,30,30);

save 'RelDis1s' RelDis;
save 'RelAng1s' RelAng;
%look at responses after 4 seconds
[mPosition,Speed,AngVel,RelPos,PelletIndices,RelDis,RelAng]=FishBehaviorv2(P,pellet2,size(L(:,:,1),2),14,30,120);

save 'RelDis4s' RelDis;
save 'RelAng4s' RelAng;

fprintf('Press any key to view final movies...\n');
pause();

M=L;%produce pellet indicators
clear L

iPell=find(pellet2(:,1));%add pellet indicator and trajectory
pell=ones(3).*3;

for(i=1:length(iPell));
    traj=zeros(size(M,1),size(M,2));
    if(i==length(iPell))
        e=n;
    else
        e=iPell(i+1);
    end
	for(j=iPell(i):e)
        x=M(:,:,j);
        row=round(pellet2(iPell(i),2));%add pellet
        col=round(pellet2(iPell(i),1)); 
        
        if((j-iPell(i))<56)

            x(row-1:row+1,col-1:col+1)=pell;
            
            [ind label]=drawline([P(j,2) P(j,1)],[P(j-1,2) P(j-1,1)],size(x));%add trajectory
            traj(ind)=label.*2;
            traj=uint8(traj);
            M(:,:,j)=x+traj;
            imagesc(M(:,:,j)),axis image
            pause(.05)
        end
    end
end
close(gcf)
fprintf('Saving M file...\n');    
save 'M' M;


return
 %------------------------------------------------
function [loadI,loadpellet,loadIp,loadJ,loadK,loadL]=RunTest(loadI,loadpellet,loadIp,loadJ,loadK,loadL)

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
if(strcmp(loadIp,'LoadIpOn'))
    loadIp=0;
else 
    loadIp=1;
end
return



