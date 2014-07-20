function d=aadiff(a,b)
%takes in two aligned protein sequences a and b and returns the number of
%differences between them. if one sequence is shorter, it will only count
%the number of differences to the shorter sequence
d=0;
if(length(a)<length(b))
    x=length(a);
else
    x=length(b);
end
for(i=1:x)
    if(a(i)~=b(i))
        d=d+1;
    end
end
return
    