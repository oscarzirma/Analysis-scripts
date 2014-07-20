function [V S]=mean_value_during_interval(time,values,start,stop)
%this function will return the mean value of trace during each interval start:stop

V=zeros(length(start),1);

for i=1:length(start)
    s=time_match(time,start(i));
    e=time_match(time,stop(i));
    V(i)=nanmedian(values(s:e));
     S(i)=nanstd(values(s:e));
end