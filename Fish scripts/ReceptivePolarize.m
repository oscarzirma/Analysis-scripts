function [R,Rel]=ReceptivePolarize(M)
%takes in a matrix in the same format used for Microspace and outputs a
%matrix with the first two columns replaced with distance and angle.

[m,n]=size(M);
R=M;
x0=M(1,1);y0=M(1,2);%coordinates of fish head
theta=atan2((M(3,2)-M(2,2)),(M(2,1)-M(3,1)));


for(i=4:m)
    x=M(i,1)-x0;y=-M(i,2)+y0;
    R(i,2) = atan2(y,x)-theta;
    R(i,1) = 2.54*hypot(x,y);
    %R(i,1)=sqrt((x-x0)^2 + (y-y0)^2);
%    if(x<x0)&&(y<y0)
%        R(i,2)=atan2((y-y0),(x-x0))-theta;
%    end
%    if(x>x0)&&(y<y0)
%        R(i,2)=atan2((y-y0),(x-x0))-theta;
%    end
%    if(x>x0)&&(y>y0)
%        R(i,2)=(atan2((y-y0),(x-x0))-theta);
%    end
%    if(x<x0)&&(y>y0)
%        R(i,2)=(atan2((y-y0),(x-x0))-theta);
%    end
    
end
Rel=R;
%Rel(4:m,4)=Rel(4:m,4)-ones(m-3,1).*Rel(1,4);
%Rel(4:m,4)=Rel(4:m,4)./max(Rel(:,4));

return