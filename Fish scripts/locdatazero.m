function v=locdatazero(d)
%function that takes in a dataset of values in time (d) and returns the indices where the
%function crosses zero value

j=1;%index of zeros
for(i=1:(length(d)-1))
    if(sign(d(i))~=sign(d(i+1)))
        v(j)=i;
        j=j+1;
    end
end
return