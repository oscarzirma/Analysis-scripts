function test=MicroSpacev3(Positions,Values,rho,theta)
%Takes in matrix with radii in the first column and angles in the second
%(in cm and radians, respectively), the min, interval and max of the
%radius (rho) and the min,max, and interval of the angle (theta) and
%outputs a 3d colormapped polar plot according the values. The first value
%in Values is the zero value.

[a,b]=size(Positions);

rmin=rho(1);rint=rho(2);rmax=rho(3);
tmin=theta(1);tint=theta(2);tmax=theta(3);
Values(1:3)=[];


M=round((rmax-rmin)/rint)+2;Cm=[rmin:rint:rmax];Cm=[0 Cm];
N=round((tmax-tmin)/tint)+2;Cn=[tmax:-tint:tmin-tint];%Cn(33)=[];
Cn=[0 Cn];Cn=round(rad2deg(Cn));
O=zeros(M,N);


O(:,1)=Cm';
O(1,:)=Cn;

clear Cn

for(i=1:a)
    r=Positions(i,1);
    t=Positions(i,2);
    O(2+round((r-rmin)/rint),2+round((tmax-t)/tint))=Values(i);
end


%for(j=2:M-1)%averages over neighboring values
%    for(k=2:N-1)
%        if(O(j,k)==Values(1));
%            X=O(j-1:j+1,k-1:k+1);
%            O(j,k)=mean(mean(X));
%        end
%    end
%end

j=1;
[m,n]=size(O);
for(i=1:M)
    if(sum(O(i,2:n))~=0)
        P(j,:)=O(i,:);
        j=j+1;
    end
end
O=P;
j=1;
[m,n]=size(O);
for(i=1:N)
    if(sum(O(2:m,i))~=0)
        P(:,j)=O(:,i);
        j=j+1;
    end
end

[m,n]=size(P);
for(i=2:m)
    x=P(i,2:n);
    Xm(i)=mean(x(x>0));
end
P(:,n+1)=Xm';
for(i=2:n+1)
    x=P(2:m,i);
    Xn(i)=mean(x(x>0));
end

P(m+1,:)=Xn;



test=P;

return
