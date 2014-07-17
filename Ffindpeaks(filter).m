function M=Ffindpeaks(F,I,f,s,Display)
%takes in a one column dataset and finds the x and y locations of the
%peaks within the interval I by low-pass filtering by frequency f, differentiating, 
%and finding the zeros, outputting those locations in M in the for [x y].
%The program tends to average multi-peak peaks. If display is 'on', will
%display each iteration.

d=F(I(1):I(2));

for(i=1:length(d)) 
    t(i)=i;
end

t=t';
fNorm=f/(s/2);
[b,a]=butter(10,fNorm,'low');
v=filtfilt(b,a,d);

dv=diff(v);
M(:,1)=locdatazero(dv);
[m,n]=size(M);
for(i=1:m)
    M(i,2)=d(M(i,1));
end
Filter='on';
FilterFreq=200;
if(Filter=='on')%if on will filter out extra peaks
    [x,y]=size(M)
    (length(d)/s)*FilterFreq
    if(x>(length(d)/s)*FilterFreq)
        for(i=1:x-1)
            if(M(i+1,1)-M(i,1)<(.25*(s/FilterFreq)))
                M(i,1)=(M(i,1)+M(i+1,1))/2;
                M(i,2)=(M(i,2)+M(i+1,2))/2;
                M(i+1,:)=[];
                [x,y]=size(M);
            end
        end
    end
    end
if(Display=='on')
r=zeros(size(d));
[j,k]=size(M);
M
for(i=1:j)
    i
    x=M(i,1)
    r(x)=M(i,2);
end
plot([d r])
pause();
end
return