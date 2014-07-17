function [PelletIndices,RelDis,RelAng]=FishBehaviorv4(position,pellet,fieldwidthpix,fieldwidthcm,fps,numframes)
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
RelDis=zeros(length(PI),numframes);
RelAng=RelDis;


c=fieldwidthpix/fieldwidthcm;


c=fieldwidthpix/fieldwidthcm;%find number of pixels per cm

for(i=1:length(PI))
    k=PI(i);
    Pp=pellet(PI(i),:);%pellet position
    for(j=1:numframes)
        Pf=position(k,1:2);%fish position
        Af=position(k,3);%fish angle
        distance=sqrt(sum((Pf-Pp).^2));
        RelPos(k,1)=distance/c;%distance in cm
        diff=Pf-Pp;
        x=diff(1);y=diff(2);
        if((x>0)&&(y>0))
            Ap=atand(x/y);
            ang=AngleDetermine(Af,Ap,2);
            
        elseif((x>0)&&(y<0))
            Ap=90+atand(-y/x);
            ang=AngleDetermine(Af,Ap,3);
            
        elseif((x<0)&&(y<0))
            Ap=180+atand(x/y);
            ang=AngleDetermine(Af,Ap,4);
            
        else
            Ap=270+atand(-y/x);
            ang=AngleDetermine(Af,Ap,1);
           
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
        D=zeros(1,numframes);
        A=D;
       
        D(1:length(RelPos)-PI(i))=RelPos(PI(i):end-1,1);
        A(1:length(RelPos)-PI(i))=RelPos(PI(i):end-1,2);
    else
        D=RelPos(PI(i):d,1);
        A=RelPos(PI(i):d,2);  
    end
    RelDis(i,:)=D';
    RelAng(i,:)=A';
end

return
    









