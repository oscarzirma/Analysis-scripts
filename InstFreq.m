function [p,P,z,Z]=InstFreq(D,SRate)
%Takes in a vector D containing a trace and a sample rate SRate. And
%outputs a vector F of the same length as D with instantaneous frequencies 
%at the peaks of D and a vector f with instantaneous frequency at each peak
%THe frequenices are calculated by the interval between
%peaks of D. The peaks are found at the zeros of the derivative smoothed
%witha moving average of span 50.

P=zeros(size(D));Z=P;
dD=diff(D);

dD=dD-(ones(size(dD)).*mean(dD));
D=D-(ones(size(D)).*mean(D));

dD=smooth(dD,25);
%D=smooth(D);

x=locdatazero(dD);
y=locdatazero(D);

for(i=2:length(x))
    r=SRate/(2*(x(i)-x(i-1)));
    if(r<2000)
    P(x(i))=r;
    p(i-1)=r;
    end
end

for(i=2:length(y))
    r=SRate/(2*(y(i)-y(i-1)));
    if(r<1000)
    Z(y(i))=r;
    z(i-1)=r;
    end
end

return