function [S R]=dataIn(Range,prefix,suffix)
%will import to the workspace from the current directory a range of
%sequentially numbered data files given the Range of number, the prefix,
%suffix

%Range(1)
%Range(2)
S=cell(Range(2)-Range(1)+1,1);
R=cell(Range(2)-Range(1)+1,1);
for(i=Range(1):Range(2))%indexes up based on the indices given in Range
    if(i<10)
       D= load([prefix ' 0' num2str(i) suffix]);
    else
      D=  load([prefix ' ' num2str(i) suffix]);
    end
    S(i)=num2cell(D(:,1),1);
    R(i)=num2cell(D(:,2),1);
    i
end
