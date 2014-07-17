function [f,m,r,s]=meanfreq(P,S)
%takes in peak data (P) and sample rate (S) and returns the mean frequency, range of ferquencies
%and standard deviation of frequencies

p=P(:,1)./S;
j=1;
for(i=3:length(p))
  f(j)=1/(p(i)-p(i-2));
  j=j+1;
end
m=mean(f);
r=range(f);
s=std(f);
return