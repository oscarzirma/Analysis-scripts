function BehaviorPrelim()
%Takes in an image stream and gathers all the necessary information about
%it for full processing. This includes:
%1. Trim and import
%2. Pellet locations
%3. Background array
%4. Threshold array
%It will save the trimmed movie array and the pellet location array. it
%will save the background and threshold constants. THe program
%BehaviorProcess will go through all of the folders below the selected one
%and process the files.
%NOTE: I may switch it so that it only outputs background and threshold
%constatns rather than the entire array if it is too time consuming

cd(uigetdir('/Users/behavior2/Behavioral Analysis/'))
pwd%all of this mess is to load the files if they have already been produced
file2=dir();
if(sum([file2.isdir])>2)
d=pwd;
for(i=length(d):-1:1)
    if(d(i)=='/')
        break
    end
end

cd([d(i+1:length(d)) 'Data']);
if(isempty(dir('I.mat')))
    cd ..

end
end

if(isempty(dir('I.mat')))

file=dir('*.png');
n=length(file);


%1. Crop file.
size(file)
pwd
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
else    
fprintf('Loading image array...\n');
    load I.mat;
    n=size(I,3);
end

fprintf('Basic Movie Sample\r')
M=MakeMov(I(:,:,100:160),60);
movie(M);
close(gcf);
pause(.1);
clear M;

if(isempty(dir('pellet.mat')))

fprintf('Press any key to begin pellet locations.\n');pause();
pellet=zeros(n,2);
for(i=1:n)%playy through video 100 frames at a time prompting if there is a pellet.
    imshow(imresize(I(:,:,i),2));
    text(-15,-1,num2str(i),'Color',[0 0 0]);
    pause(.001)
    if((mod(i,100)==0)||(i==n))
        close(gcf)
        r=input('Was there a pellet(y/n)?\n','s');%prompt for pellet
        if(r=='y')%if yes, start playing backward for 40 frames

                tmp=i-99;
                if(tmp<=0)
                    tmp=1;
                end
                h = uicontrol(gcf,'Position',[1 330 80 30],...%this uicontrol stops the playback and brings up the ginput control
                'String','Pellet',...
                'Callback', 'setappdata(gcf, ''run'', 0)');
                flag = 1;
                setappdata(gcf, 'run', flag);
                h2=uicontrol(gcf,'Position',[1 290 80 30],...%this uicontrol reverses the playback by 1 frames
                 'String','Go Forward',...
                 'Callback','setappdata(gcf,''gb'',0)');
                flag2=1;
                setappdata(gcf, 'gf', flag2);
                h3=uicontrol(gcf,'Position',[1 250 80 30],...%this uicontrol forwards the playback by 1 frames
                 'String','Go Back',...
                 'Callback','setappdata(gcf,''gf'',0)');
                flag3=1;
                setappdata(gcf, 'pause', flag3);
                h4=uicontrol(gcf,'Position',[1 210 80 30],...%this uicontrol puases the playback by 1 frames
                 'String','Pause',...
                 'Callback','setappdata(gcf,''pause'',0)');
                flag4=1;
                setappdata(gcf, 'pause', flag4);                
                h4=uicontrol(gcf,'Position',[1 170 80 30],...%this uicontrol puases the playback by 1 frames
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
                    pause(.01)
            end
        end
    end
    
end
close(gcf)
clear flag flag1 flag2 flag3 flag4 flag5 tmp flip
save 'pellet' pellet;
else
    fprintf('Loading pellet locations...\n')
    load pellet.mat;
end

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
        ui1=input('Enter a new value for Tb (higher values dim the background more):');
        fprintf('\r');
        Tb=ui1;
    end
end
clear Mb Z background

%save 'J' J %save background-subtracted image array.

clear I;

%Test binary threshold.

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
