function a = get_ustim_amp(M)
%given a microstim trace, this function will return the peak to peak
%amplitude of that trace, assuming that the peak is greater than half of
%the max/min.

for i=1:size(M,1)
    m=M(i,:);
[pmax]=findpeaks(m,max(m)/2);
[pmin]=findpeaks(-m,max(-m)/2);

a(i)=mean(m(pmax.loc))-mean(m(pmin.loc));
end
a(isnan(a))=0.00001;
a(a==0)=.00001;