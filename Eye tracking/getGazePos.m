function [T X Y S Tm Xm Ym Sm ]=getGazePos(gazePosition)

l=size(gazePosition,1);

for i = 1 : l
    hp=cell2mat(gazePosition(i,1));
    t=hp(:,1)';%generate cell matrices for each dimension, removing any zeros
    r=find(t~=0);
    n=length(r);
    T(i)={t(r)};
    x=hp(:,2)';
    X(i)={x(r)};
    y=hp(:,3)';
    Y(i)={y(r)};
    s=hp(:,4)';
    S(i)={s(r)};
    
    n=length(t);%generate a matrix for each dimension
    Tm(i,1:n)=t;
    Xm(i,1:n)=x;
    Ym(i,1:n)=y;
    Sm(i,1:n)=s;
end

