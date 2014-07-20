function D=dataInB(Range,prefix,suffix,g)
%will import to the workspace from the current directory a range of
%sequentially numbered data files given the Range of number, the prefix,
%suffix, and g the number of columns for each file.

Range(1)
Range(2)-1
j=Range(1);
for(i=Range(1):Range(2)-1)%indexes up based on the indices given in Range
    if(i<10)
       load([prefix ' 0' num2str(i) suffix]);
    else
       load([prefix ' ' num2str(i) suffix]);
    end
    i
    j=j+2;
end