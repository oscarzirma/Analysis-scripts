function [vid_sacc mag_sacc conv]=eyeCalSaccade(vid_time,vid_trace,mag_time,mag_trace)
%given a trace of video-based pupil movements and another of magnetically
%or electrooculogramically recorded eye movements, will return the millivolts of
%signal to millimeter of movement. The program does this based on saccade
%size

Sv = vid_time(2)-vid_time(1);%vid sample rate
Sm = mag_time(2)-mag_time(1);%mag sample rate

Shv = round(.1/Sv);%to shift 75 ms, how many samples
Shm = round(.1/Sm);

%find saccade times
plot(vid_time,vid_trace);
title('Click on each saccade. Press enter when complete');
[X Y] = ginput
close(gcf)

for i=1:length(X) %for each saccade, find time for vid and mag and then find the saccade shift for each
    vi=1; while vid_time(vi)<X(i) vi=vi+1; end%find indices for saccade time
    mi=1; while mag_time(mi)<X(i) mi=mi+1; end
    mag_time(mi)
    vid_sacc(i)=vid_trace(vi+Shv)-vid_trace(vi-Shv);
    mag_sacc(i)=mag_trace(mi+Shm)-mag_trace(mi-Shm);
end

conv = mag_sacc./vid_sacc;