function [times values start stop] = find_plateau_values(t,m)
%given a trace m, and time vector t this function will find the time and value of each plateau.
%for video or magnet eye traces. time vector in seconds.

ms=smooth(m,10);
msd=abs(diff(ms));

%figure
%plot(msd);
%title('Select threshold for movement')
%[a thresh]=ginput(1);

thresh=3.5*std(msd);

f=find(msd>thresh);

interval=sum((t-t(1))<200);

start=[];
stop=[];
mm=[];
j=1;
for i=1:length(f)-1 
    if f(i+1)-f(i)>interval
        stop(j)=f(i+1);
        start(j)=f(i);
        j=j+1;
    end;
end
length(start)
for i=1:length(start) 
    mm(i)=nanmean(m(start(i):stop(i)));
end

middle = round((start+stop)./2);

% plot(m)
% hold on
% scatter(start,mm,'g')
% scatter(middle,mm,'k')
% scatter(stop,mm,'r')
%close(gcf)

times = (t(middle));
values = mm;
start=t(start);
stop=t(stop);
