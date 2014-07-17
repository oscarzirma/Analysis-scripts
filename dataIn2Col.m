function [x y]=dataIn2Col(Range,prefix,suffix)
%will import to the workspace from the current directory a range of
%sequentially numbered data files with 2 columns of numbers given the Range of number, the prefix,
%suffix.

Range(1)
Range(2)
for(i=Range(1):Range(2))%indexes up based on the indices given in Range
    if(i<10)
       D= load([prefix ' 0' num2str(i) suffix]);
    else
       D=  load([prefix ' ' num2str(i) suffix]);
    end
    i
    size(D)
    x(:,i)=D(:,1);
    y(:,i)=D(:,2);
end
return