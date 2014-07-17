function trace = aligned_mag_vid(vid_time,vid_trace,mag_time,mag_trace,shift)
%Given a trace and timestamp for both video centroid and magnetic
%responses, this will return a matrix with video values in the first column
%and magnetic values in the second column. vid_time and mag_time should be
%in the same units. Shift specifies the amount to shift the magnetic trace
%by relative to the video trace.

j=1;

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