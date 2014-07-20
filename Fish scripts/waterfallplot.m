function waterfallplot(D,shift,r)
%takes in a matrix with data in columns and plots a graph with those
%columns shifted relative to each other by shift. If s is zero will shift with
%regards to the maximum value in the trace being shifted. R is the sampling
%rate in s^-1.

k=size(D);
for(i=1:k(1)) t(i)=i/r; end%sets up time index t for plotting
G(:,1)=D(:,1);%Sets the first column of the output matrix equal to the first column of the data
n=0;
m=0;
if(shift==0)
    for(i=2:k(2))
        v=D(:,i);
        p=max(v)-n;
        if(p<3)
            m=m+3;
        else
            m=m+p;
        end
        n=min(v);
        s=ones(k(1),1)*m;%builds shift vector        
        G(:,i)=(v-s);%shifts each column
    end
else
    for(i=1:k(1)) s(i)=shift; end %builds shift vector
    s=s';
    for(i=2:k(2)) G(:,i)=(D(:,i)-((i-1)*s)); end%shifts each column
end
plot(t,G);

