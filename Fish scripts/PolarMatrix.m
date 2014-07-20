function test=PolarMatrix(Positions,Values,rho,theta)
%Takes in matrix with radii in the first column and angles in the second
%(in cm and radians, respectively), the min, interval and max of the
%radius (rho) and the min,max, and interval of the angle (theta) and
%outputs a 3d colormapped polar plot according the values. The first value
%in Values is the zero value.
%Same as Microspace3, but does not label the rows and columns, does not
%delete rows and columns containing only 0s and does not average rows and
%columns.

[a,b]=size(Positions);

rmin=rho(1);rint=rho(2);rmax=rho(3);
tmin=theta(1);tint=theta(2);tmax=theta(3);



M=round((rmax-rmin)/rint);
N=round(2*pi()/tint);

O=ones(M,N).*Values(1);
Values(1:3)=[];

for(i=1:a)
    r=Positions(i,1);
    t=Positions(i,2);
    O(1+round((r-rmin)/rint),1+round((t-tmin)/tint))=Values(i);
end


%for(j=2:M-1)%averages over neighboring values
%    for(k=2:N-1)
%        if(O(j,k)==Values(1));
%            X=O(j-1:j+1,k-1:k+1);
%            O(j,k)=mean(mean(X));
%        end
%    end
%end

test=O;
return
