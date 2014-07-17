function h=HistNorm(Initial,Estimate,bins)
%Normalizes a distribution of estimate angles from behavioral data using
%a distribution of initial angles over a specified number of bins. The output
%is the histogram of the distribution of estimate normalized by the
%distribution of initial. Assumes initial is distributed from 0 to 180 and
%estiamte is distributed from -180 to 180.

[H n]=histc(Initial,[0:180/bins:180]);

H=H./sum(H);
H=ones(size(H))./H;
h=zeros(bins,1);

for(i=1:length(Estimate))
    j=ceil((Estimate(i)+180)/360*bins);
    h(j)=h(j)+H(n(i));
end

h=h./sum(h);
end

