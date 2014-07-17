function [t,Nffs]=displayNeuralTraces(Neural,stim_ang_pos)
%will present sorted and filtered neural traces

m=length(Neural);

for i=1:m
    x=cell2mat(Neural(i));
    N(i,:)=x(2,1:14600);
end

t=x(1,:);

Nf = batchhighpassFilter(N,300,24333);

Nff = batchlowpassFilter(Nf,3000,24333);

[x j]=sort(stim_ang_pos);

Nffs=Nff(j(:,1),:);

n=round(sqrt(m));

for i=1:m
    subplot(n,n,i);
    plot(t,Nffs(i,:));
    title(num2str(x(i,:)));
    axis([0 300 -.00005 .00005])
end
