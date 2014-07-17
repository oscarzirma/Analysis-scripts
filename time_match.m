function index=time_match(time_trace,timepoint)
%this function will return the index most closely matching the timepoint
%in the given time_trace
index=[];
ing=find(time_trace>=timepoint&time_trace<1.1*timepoint);
if ~isempty(ing)
index=ing(1);
end