function M=FfindpeaksFilter(F,I,f,s,cycles)
%takes in a one column dataset and finds the x and y locations of the
%peaks within the interval I by low-pass filtering by frequency f, differentiating, 
%and finding the zeros, outputting those locations in M in the for [x y].
%The program tends to average multi-peak peaks. If display is 'on', will
%display each iteration. If Filt is 'on' will filter out excess peaks
%averaging them together.

d=F(I(1):I(2));

for(i=1:length(d)) 
    t(i)=i;
end

t=t';
fNorm=f/(s/2);
[b,a]=butter(10,fNorm,'low');
v=filtfilt(b,a,d);

dv=diff(v);
M1=locdatazero(dv)';
[m,n]=size(M1);
if(m>2*cycles)
    int=length(d)/(2*cycles);
    x=M1;
    i=1;
    while(i<m)
        if((x(i+1)-x(i))<=(0.9*int))
            x(i)=round((x(i)+x(i+1))/2);
            x(i+1)=[];
            m=m-1;
            i=i-1;
        end
        i=i+1;
    end
    M1=[];
    M1=x;
    [m,n]=size(M1);
end
for(i=1:m)
    M2(i)=d(M1(i));
end
M2=M2';
M=[M1 M2];
return