function [Xdist Ydist Zdist]=head_pos_distribution_timepoint(headPosition,time)
%Takes in a head position and time and returns the X, Y,and Z coordinates
%at that time

[T X Y Z Yaw Rol Pit Tm Xm Ym Zm Yawm Rolm Pitm]=getHeadPos(headPosition);

n=length(headPosition);
Xdist=[];Ydist=[];Zdist=[];
for i=1:n
    t=cell2mat(T(i));
     j=1;
    while (j<=length(t))&&(t(j)<time)
        j=j+1;
    end
    
     x=cell2mat(X(i));y=cell2mat(Y(i));z=cell2mat(Z(i));

    if j<=length(x)
        Xdist(i)=x(j);
    end
    if j<=length(y)
        Ydist(i)=y(j);
    end
    if j<=length(z)
        Zdist(i)=z(j);
    end
    
end

%size(Xdist)