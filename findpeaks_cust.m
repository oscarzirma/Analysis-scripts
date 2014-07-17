function [M,F]=findpeaks(D,I)
%takes in a one column dataset and finds the x and y locations of the
%peaks within the interval I by fitting the addition of 8 sin waves, differentiating, 
%and finding the zeros, outputting those locations in M in the for [x y].
%The program tends to average multi-peak peaks.

d=D(I(1):I(2));
for(i=1:length(d)) 
    t(i)=i;
end
t=t';
F=fit(t,d,'sin8');
dF=differentiate(F,t);
M(:,1)=locdatazero(dF);
[m,n]=size(M);
for(i=1:m)
    M(i,2)=d(M(i,1));
end
return