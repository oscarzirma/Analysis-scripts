function y = running_average(x,window)
%returns a running average of the vector x using a running window size
%specified by window. at the ends, it uses one half of the window size at
%the edges and the window remains uncentered while the index is closer to
%the edge than the window size

n=length(x);
y=zeros(1,n);
f=floor(window/2);
for i=1:n
    if i<=window/2
        y(i)=mean(x(1:i+f));
    elseif (i+window/2)>n
        y(i)=mean(x(i-f:n));
    else
        y(i)=mean(x(i-f:i+f));
    end
end