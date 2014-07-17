function [BHP RHP]=BehBootstrap(BInitP,BEstP,RInitP,REstP,Iterations,Bins)
%Returns histograms of bootstraps 

lB=length(BInitP);lR=length(RInitP);
BHP=zeros(Iterations,Bins);RHP=BHP;

for(i=1:Iterations)
j=randperm(lB);
I=BInitP(j);E=BEstP(j);
l=ceil(lB*.7);
I=I(1:l);E=E(1:l);
BHP(i,:)=histnormcum(I,E,Bins);

j=randperm(lR);
I=RInitP(j);E=REstP(j);
l=ceil(lR*.7);
I=I(1:l);E=E(1:l);
RHP(i,:)=histnormcum(I,E,Bins);

if(mod(i,1000)==0)
i
end
end

