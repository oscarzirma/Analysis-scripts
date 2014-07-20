function v=datazero(d,I,z)
%function that takes in a dataset of values in time (d) and an interval
%vector of the format [start,end] and returns the indices where the
%function crosses zero value z.

a=d(I(1));
k=1;
if(a>z) s=1;
else s=-1;
end
i=I(1);
while(i<=I(2))
    a=d(i);
    if((s==1)&(a<=z))
        v(k)=i;
        s=-1;
        k=k+1;
        i=i+40;
    end
    if((s==-1)&(a>=z))
        v(k)=i;
        s=1;
        k=k+1;
        i=i+40;
    end
    i=i+1;
end
return
        