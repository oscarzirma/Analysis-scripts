function P=microphonics1(v,i,f,r)
%program that takes in voltage trace v and finds the x and y values of each
%maximum and minimum in interval i[start,finish]. P has x values in column 1 and y values
%in column 2. Also takes in frequency (f) and sample rate (r) in order to
%eliminate false peaks.

p=1;%index of peaks
z=0;%initiation value for finding peaks
n=1;%index of derivative. 1 for +, -1 for -.
d=round((1/(4*f))*r);%approximate inter-peak distance
%d=round(d-(0.02*d));%inter-peak distance reduced by 2% and rounded to nearest integer;
j=i(1);
while(j<i(2))
    if((n==1)&(v(j)<(z)))    
            P(p,1)=(j-1)
            P(p,2)=v(j-1);
            p=p+1;
            n=-n
            j=j+d;
            z=v(j-1);
    elseif((n==-1)&(v(j)>z))
            P(p,1)=(j-1)
            P(p,2)=v(j-1);
            p=p+1;
            n=-n;
            j=j+d;
            z=v(j-1);
        else
            z=v(j)
            j=j+1;
        end
end
return