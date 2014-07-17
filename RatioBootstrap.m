function [BaseB RidgeB]=RatioBootstrap(Base,Ridge,Iterations,Bins)


lB=length(Base);lR=length(Ridge);
BaseB=zeros(Iterations,Bins+1);RidgeB=zeros(Iterations,Bins+1);

for(i=1:Iterations)
j=randperm(lB);
I=Base(j);
l=ceil(lB*.7);
I=I(1:l);
x=histc(I,-1.5:3/Bins:1.5);
BaseB(i,:)=x./sum(x);

j=randperm(lR);
I=Ridge(j);
l=ceil(lR*.7);
I=I(1:l);
x=histc(I,-1.5:3/Bins:1.5);
RidgeB(i,:)=x./sum(x);

if(mod(i,1000)==0)
i
end
end
