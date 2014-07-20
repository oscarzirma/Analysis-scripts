function [BaseMean BaseStd RidgeMean RidgeStd p]=BehAnalysisRespVNoResp(BaseEstoInit,RidgeEstoInit,Interval,iterations)
%Takes in two vectors of the ratio of the response to the initial. it then
%randomly permutes the vectors and using 70% of the data finds the
%proportion of the values within the specified Range. It then outputs the
%mean and standard deviation of those values at the end.

Base=zeros(iterations,1);
Ridge=Base;
lR=ceil(0.7*length(RidgeEstoInit));
lB=ceil(.7*length(BaseEstoInit));
r=length(RidgeEstoInit);b=length(BaseEstoInit);

for(i=1:iterations)
   j=randperm(r);
   R=RidgeEstoInit;
   R=R(j);
   R=R(1:lR);
   Ridge(i)=length(find((R>Interval(1)).*(R<Interval(2))))./length(R);
   
   j=randperm(b);
   B=BaseEstoInit;
   B=B(j);
   B=B(1:lB);
   Base(i)=length(find((B>Interval(1)).*(B<Interval(2))))./length(B);
end

BaseMean=mean(Base);BaseStd=std(Base);
RidgeMean=mean(Ridge);RidgeStd=std(Ridge);
[h p]=ttest2(Ridge,Base,.05,'both')
return