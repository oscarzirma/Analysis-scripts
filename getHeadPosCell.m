function [T X Y Z Yaw Rol Pit Tm Xm Ym Zm Yawm Rolm Pitm]=getHeadPosCell(headPosition)

l=size(headPosition,1);

for i = 1 : l
    hp=cell2mat(headPosition(i,1));
    t=hp(:,1)';%generate cell matrices for each dimension, removing any zeros
    r=find(t~=0);
    n=length(r);
    T(i)={t(r)};
    x=hp(:,2)';
    X(i)={x(r)};
    y=hp(:,3)';
    Y(i)={y(r)};
    z=hp(:,4)';
    Z(i)={z(r)};
    
    yaw = hp(:,5);
    Yaw(i) = {yaw(r)};
    rol = hp(:,6);
    Rol(i) = {rol(r)};
    pit = hp(:,7);
    Pit(i) = {pit(r)};
    
    n=length(t);%generate a matrix for each dimension
    Tm(i,1:n)=t;
    Xm(i,1:n)=x;
    Ym(i,1:n)=y;
    Zm(i,1:n)=z;
    Yawm(i,1:n)=yaw;
    Rolm(i,1:n)=rol;
    Pitm(i,1:n)=pit;
end

