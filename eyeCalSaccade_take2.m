function [vid_sacc mag_sacc conv]=eyeCalSaccade_take2(vid_trace,mag_trace)
%given a trace of video-based pupil movements and another of magnetically
%or electrooculogramically recorded eye movements, will return the millivolts of
%signal to millimeter of movement. The program does this based on saccade
%size


%find saccade times
plot(vid_trace);
title('Click before and after each saccade. Press enter when complete');
[Xv Yv] = ginput;
Xv=round(Xv);

for i=2:2:length(Xv)
    j=Xv(i);
    vid_sacc(i/2)=vid_trace(Xv(i))-vid_trace(Xv(i-1));
end

%find saccade times
plot(mag_trace);
title('Click before and after each saccade. Press enter when complete');
[Xv Yv] = ginput;
Xv=round(Xv);

for i=2:2:length(Xv)
    j=Xv(i);
    mag_sacc(i/2)=mag_trace(Xv(i))-mag_trace(Xv(i-1));
end

conv=mag_sacc./vid_sacc;