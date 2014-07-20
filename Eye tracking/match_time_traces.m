function time_shift=match_time_traces(time1,trace1,time2,trace2)
%this function will plot both traces and then have the user indicate good
%synchronizing timepoints on trace1. It will then present both traces and
%the the user select corresponding timepoints in each trace. assumed times
%are in ms

plot_interval = 1500;%time in ms to be plotted
interval1=time_match(time1,plot_interval)
interval2=time_match(time2,plot_interval)

scrsz = get(0,'ScreenSize');
figure('Position',[1 scrsz(4)/1.1 scrsz(3)/1.1 scrsz(4)/1.1]);
subplot(212)
plot(trace2)
ax=axis;ax(1)=0;ax(2)=length(trace2);axis(ax);

subplot(211)
plot(trace1)
ax=axis;ax(1)=0;ax(2)=length(trace1);axis(ax);

title('Click on useful timepoints. Hit enter when finished')
[x y]=ginput;
close(gcf);

x=round(x);

figure('Position',[1 scrsz(4)/1.1 scrsz(3)/1.1 scrsz(4)/1.1]);

for i=1:length(x)
    t=time_match(time2,time1(x(i)));
    
    subplot(212)
    plot(time2(t-interval2/2:t+interval2/2),trace2(t-interval2/2:t+interval2/2))

        subplot(211)
        x(i)
    plot(time1(x(i)-interval1/2:x(i)+interval1/2),trace1(x(i)-interval1/2:x(i)+interval1/2))
    
    title('Click synch point on trace1')
    [t1(i) b]=ginput(1)
    
        subplot(212)
    plot(time2(t-interval2/2:t+interval2/2),trace2(t-interval2/2:t+interval2/2))
    
        title('Click synch point on trace2')
    [t2(i) d]=ginput(1)
end
close(gcf)

dt=t2-t1;
time_shift=mean(dt);

display(['Trace2 follows trace1 by ' num2str(time_shift) ' ms. ' num2str(dt)])