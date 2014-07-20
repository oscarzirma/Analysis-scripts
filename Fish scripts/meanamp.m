function [d,m,r,s]=meanamp(P)
%takes in a 2-column matrix of peak values [x,y] and outputs the mean
%amplitude (m), the range of amplitudes (r) and the standard deviation of
%amplitude (s). This program will only work with alternating positive and
%negative peaks (e.g. sine wave)

p=P(:,2);
a=p(1)-p(2);
i=1;
j=1;
if(a>0)
    while(i<length(p))
        d(j)=p(i)-p(i+1);
        i=i+2;
        j=j+1;
    end
end
if(a<0)
    while(i<length(p))
        d(j)=p(i+1)-p(i);
        i=i+2;
        j=j+1;
    end
end
m=mean(d);
s=std(d);
r=range(d);
return