function [mPosition,Speed,AngVel,RelPos,PelletIndices,RelDis,RelAng]=FishBehavior(position,pellet,fieldwidthpix,fieldwidthcm,fps,numframes)
%Takes in the fish position and pellet positions for a behavioral session.
%It also takes in the width of the field in cm and the number of FPS.
%It determines the fish's angle and distance relative to a pellet (RelPos) until
%another pellet appears, or 24 frames
%pass (3 seconds), whichever comes first. It also will do the same process
%but using a running mean of the fish position and orientation (outputing
%this as mPosition). It will use the running mean values to determine the
%fish's instaneous speed and angular velocity over time. RelPos contains
%the distance from the head to the pellet and the angle between the fish's 
%heading and the direction of the pellet. numframes is the number of frames
%to follow after each pellet. RelDis and RelAng output matrices with
%individual pellet tracks in rows.

n=length(position);
PelletIndices=find(pellet(:,1));%find frames that contain a pellet position
PI=PelletIndices;

mPosition=zeros(n,3);
Speed=zeros(n-2,1);
AngVel=Speed;
RelPos=zeros(n,2);
RelDis=zeros(length(PI),numframes);
RelAng=RelDis;

c=fieldwidthpix/fieldwidthcm;

mPosition(1,:)=mean(position(1:2,:));
mPosition(n,:)=mean(position(n-1:n,:));

for(i=1:n-2)%find running mean positions
    mPosition(i+1,:)=mean(position(i:i+2,:));
    distance=sqrt(sum((mPosition(i+1,1:2)-mPosition(i,1:2)).^2));%find distance beween consecutive positions
    Speed(i)=(distance*fps)/c;%find speed between consecutive positions
    AngVel(i)=mPosition(i+1,3)-mPosition(i,3);
end

c=fieldwidthpix/fieldwidthcm;%find number of pixels per cm

for(i=1:length(PI))
    k=PI(i);
    Pp=pellet(PI(i),:);%pellet position
    for(j=1:numframes)
        Pf=mPosition(k,1:2);%fish position
        Af=mPosition(k,3);%fish angle
        distance=sqrt(sum((Pf-Pp).^2));
        RelPos(k,1)=distance/c;%distance in cm
        diff=Pf-Pp;
        x=diff(1);y=diff(2);
        if((x>0)&&(y>0))
            Ap=atand(x/y);
        elseif((x>0)&&(y<0))
            Ap=90+atand(-y/x);
        elseif((x<0)&&(y<0))
            Ap=180+atand(x/y);
        else
            Ap=270+atand(-y/x);
        end
        ang=abs(Af-Ap);
        if(ang>180)
            ang=360-ang;
        end
        RelPos(k,2)=ang;
        k=k+1;
        if((k>n))
            break
        end
    end
    d=PI(i)+numframes-1;
    if(d>size(RelPos,1))
        fprintf('Final pellet too close to end of video.\n');
        break    
    end
    RelDis(i,:)=RelPos(PI(i):d,1)';
    RelAng(i,:)=RelPos(PI(i):d,2)';
end

return
    









