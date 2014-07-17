function BehaviorProcess()
%Asks for a directory and will look in all the of the subdirectories of
%that directory for K.mat and pellet.mat. It will then produce a reduced
%array, find the fish positions, and produce an output image array and the
%fish orientation array.
%v2 attempts to fix angle problem by filtering out angles more than 40 degrees
%different from the previous angle and replacing them with the mean of the previous
%and following angles.

directory=uigetdir('/Users/behavior/Desktop/Behavior/')
cd(directory)
file=dir();

for(i=3:length(file))
    tic
    cd(directory)
    if(file(i).isdir)

        cd(file(i).name)  
        d=pwd
        file2=dir();
        if(sum([file2.isdir])>2)
        for(i=length(d):-1:1)
            if(d(i)=='/')
                break
            end
        end
		d
        cd([d(i+1:length(d)) 'Data']);

        dir
        if(isempty(dir('Ip.mat')))
            load 'K.mat'
            load 'pellet.mat'

            n=size(K,3);
            I=K;
              fprintf('Generating reduced image array...\n');
h = waitbar(0,'Generating reduced image array...');
%Generate reduced image array
pellRed=zeros(size(pellet,1),1);
shif=ones(180,1);
iPellet=find(pellet(:,1));

for(j=1:length(iPellet))
    i=iPellet(j);
    if((pellet(i,1)+pellet(i,2))~=0)
        if(i<20)
            180-(20-i);
            shif1=ones(180-(20-i),1);
            pellRed(1:180-(20-i))=shif1;
        elseif(i+240>n)
            20+(n-i);
            size(pellRed);
            shif1=ones(20+(n-i),1);
            pellRed(i-19:end)=shif1;            
        else
            pellRed(i-19:i+160)=shif;
        end
    end
end

%I2=zeros(size(I,1),size(I,2),sum(pellRed));
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

close(h)
I=uint8(I2);

fprintf('Image array size went from ');
disp(n);
n=size(I,3);
fprintf(' to ');
disp(n);
save 'Ip.mat' I;
save 'pellet2.mat' pellet2;

        else
            load Ip.mat;
            load pellet2.mat
            n=size(I,3);
        end
K=I;
n=size(K,3);
 if(isempty(dir('L.mat')))
size(K)
fprintf('Finding fish positions...\n')
h = waitbar(0,'Finding fish positions...');%changed in v2
size(K)
for(i=1:n)
    x=K(:,:,i);
    [P3 O c]=PosOrientv2(x,0);
    if(sum([(P3==[40 40]) (O==0) (c==[10 10])])==6)
        P(i,:)=P(i-1,:);C(i,:)=C(i-1,:);
    else
    P(i,:)=[P3 O];
    C(i,:)=c;
    end
end
L=zeros(size(K),'uint8');
previousPosition=P(1,:);%for comparing to previous angle
for(i=1:n)
   
    x=K(:,:,i);
    P3=P(i,1:2);
    previousAngle=previousPosition(3);
    O=P(i,3);vO=[cosd(O) sind(O)];vpA=[cosd(previousAngle) sind(previousAngle)];
    c=C(i,:);
    if(acosd(dot(vO,vpA))>40)
        if(i+1>n)
            followingPosition=previousPosition;
        else
            followingPosition=P(i+1,:);
        end
        followingAngle=followingPosition(3);
        vfA=[cosd(followingAngle) sind(followingAngle)];
        angmean=(vpA+vfA)/2;
        O=rad2deg(atan2(angmean(2),angmean(1)));
        if(O<0)
            O=O+360;
        end
        pP=previousPosition(1:2);
        fP=followingPosition(1:2);
        %P3=(pP+fP)./2;
    end
    previousPosition=[P3 O];
    P(i,:)=[P3 O];
    P3=round(P3);
    c=round(c);
    x=uint8(x);
    x(P3(2)-2:P3(2)+2,P3(1)-2:P3(1)+2)=ones(5).*3;
    [ind label]=drawline([P3(2) P3(1)],[c(2) c(1)],size(x));
    x(ind)=label.*3;
    if(sum(size(x))>sum(size(K(:,:,i))))
        [m,n]=size(K(:,:,i));
        x=x(m,n);

    end

    L(:,:,i)=x;
    if(mod(i,50)==0)
        waitbar(i/n,h,'Finding fish positions...')
    end
end

close(h);
save 'L' L;
save 'positions' P;

clear K;

else
     load L.mat
     load positions.mat
     n=size(L,3);
 end

%look at responses after 1 second
[PelletIndices,RelDis,RelAng]=FishBehaviorv4(P,pellet2,size(L(:,:,1),2),14,20,20);

save 'RelDis1s' RelDis;
save 'RelAng1s' RelAng;

[m n]=size(RelAng);

LorR=char(m,2);

Thresh=10;%set threshold of angle to 10 degrees within 1 second

Success=zeros(m,1);

for(i=1:m)
    if(RelAng(i,1)>0)%is the pellet to the left or to the right?
        LorR(i,1)='L';
    else
        LorR(i,1)='R';
    end

    if(min(RelAng(i,:))<=Thresh)
        Success(i)=1;
        LorR(i,2)='1';
    else
        LorR(i,2)='0';
    end
end

Success(i+1)=mean(Success);

dlmwrite('Output.txt',LorR,'delimiter',' ')
dlmwrite('Output.txt',' ','-append')
dlmwrite('Output.txt',Success,'-append')

%look at responses after 4 seconds
[PelletIndices,RelDis,RelAng,Angle,NetDis]=FishBehaviorv5(P,pellet2,size(L(:,:,1),2),14,20,80);

save 'RelDis4s' RelDis;
save 'RelAng4s' RelAng;
save 'FishAngle' Angle;
save 'NetDis' NetDis;

%fprintf('Press any key to view final movies...\n');
%pause();

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
            if(row==1)
                x(row:row+2,col-1:col+1)=pell;
            elseif(col==1)
                x(row-1:row+1,col:col+2)=pell; 
            else
            x(row-1:row+1,col-1:col+1)=pell;
            end
            
            [ind label]=drawline([P(j,2) P(j,1)],[P(j-1,2) P(j-1,1)],size(x));%add trajectory
            traj(ind)=label.*2;
            traj=uint8(traj);
 
            M(:,:,j)=x+traj;
            imagesc(M(:,:,j)),axis image
            %pause(.05)
        end
    end
end
close(gcf)
fprintf('Saving M file...\n');    
save 'M' M;
        end
    end
    toc
    clear I I2 M;
    end
    cd ..;


return
        