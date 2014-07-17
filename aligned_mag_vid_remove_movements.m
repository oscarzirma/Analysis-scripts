function trace = aligned_mag_vid_remove_movements(vid_time,vid_trace,mag_time,mag_trace,shift)
%Given a trace and timestamp for both video centroid and magnetic
%responses, this will return a matrix with video values in the first column
%and magnetic values in the second column. vid_time and mag_time should be
%in the same units. Shift specifies the amount to shift the magnetic trace
%by relative to the video trace.
%remove movements will strip all timepoints in which the eye is moving,
%defined as diff(vid_trace)>(std(diff(vid_trace))/4
j=1;

id=abs(diff(vid_trace))<(std(diff(vid_trace)))/10;

vid_time=vid_time(id);
vid_trace=vid_trace(id);

trace(:,1)=vid_trace;

for i=1:length(vid_time) 
    
    while(mag_time(j)<vid_time(i)+shift) 
        j=j+1;
        if j>length(mag_time)
            j=length(mag_time);
            break
        end
    end; 
    
    trace(i,2)=mag_trace(j);
end