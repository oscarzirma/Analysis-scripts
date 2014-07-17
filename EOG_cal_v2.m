%function
%[eog_event_times,V_shift,eog_pix_shifts,eog_deg_shifts,eog_eye_size,conversion,scaled_trace]=EOG_cal_v2(data,mov,Fs,eye_size,eye_rotation_depth,gain,trace_number)
function [eye_shift_pix1,eye_shift_deg1,pupil_position2,eye_shift_deg2] = EOG_cal_v2(data,mov,Fs,eye_size,eye_rotation_depth,gain,trace_number)
%This is a program to aid in calibration of EOG voltage magnitudes to
%degrees of eye movement. The data is a matrix of voltages from one of the
%ht_test_... programs (time in first row, EOG trace in second), mov is a matrix of RGB uint8 at 30 fps, Fs is sample
%rate in kHz, eye size is the eye length in mm at its widest point (default 10%mm),
%eye rotation depth is the fulcrum of eye movements for angle, gain is the
%gain on the EOG trace;trace_number is which EOG trace it is.
%determination.
%The strategy of the program is as follows:
% 1. Load trial
% 2. Extract EOG trace, and low-pass filter at 30 Hz
% 3. Display filtered EOG trace and have user select EOG events. The use clicks at the initiation of the event. The program records the time of the event. It also records the amplitude by measuring the mean amplitude of the previous 50 ms and subtracting it from the mean amplitude of a 50 ms period following a 50 ms delay for the shift to occur.
% 4. For each EOG event, play clip from 5 frames before to 5 frames after. If this encompasses the saccade, the user indicates this. If it does not, the user can shift it back 5 frames by pressing 'b', forward 5 frames by pressing 'f', lengthen by 6 frames by pressing 'l', or shorten by 3 frames by pressing 's'.
% 5. The program then presents a before and after frame from each event, running the saccadeSize program.
% 6. The program then calculates the conversion factor between the trace and degrees and plots the trace rescaled to degrees.

% %Output files:
% eog_event_times - times of EOG events in ms
% V_shift - voltage amplitude of EOG event
% eog_pix_shifts - pixels of horizontal shift for each EOG event
% eog_eye_size - size of eye for that EOG event
% eog_deg_shifts - size of the eye shift in degrees for each EOG event
% conversion - the number of degrees per volt for that trial
% scaled_trace - an EOG trace with values in degrees

%version 2 uses now saccade size calculation and determines both x and y
%shift

status=1;%indicates how far along the program has gotten
file_name=['EOG_cal_' num2str(trace_number) '.mat']

if(exist(file_name))
    disp('Press any key to load existing file')
    pause
    load(file_name)
else
    disp('No file found')
end

if(status==1);

t=data(1,:);
e=data(2,:)./gain;

%disp('Filtering...');
%[ef d]=loadLPFilter(e,30,Fs);
ef=e;


disp('Press any key to indicate EOG event times');
pause

scrsz = get(0,'ScreenSize');
h=figure('Position',[1 scrsz(4) scrsz(3)/1.1 scrsz(4)/1.1]);
plot(t./1000,ef)

[x y]=ginput
clear y;
eog_event_times=x;

close all

status=2;
save(file_name);
end

if(status==2)

disp('Press any key to check movies for saccades.')
disp('If the movie contains the saccade and the eye is stable at the beginning and end,\n press y and hit return.')
disp('If the movie needs to be shifted forward, press f; backward, press b,\n lengthened, press l; or shortened, press s.\n Press y to continue without modification.')
disp('Press r to remove that event');
pause

n=length(x);
x
for i=1:n
   
    clipSize=5;%size of movie clip to play

    index=round(x(i)*Fs)
    preAmp=mean(ef(index-.050*Fs:index));
    postAmp=mean(ef(index+.050*Fs:index+.100*Fs));%Find the voltage shift at the EOG event
    V_shift(i)=postAmp-preAmp;
    
    frame=round(x(i)*29.97)
    
    while(frame+clipSize<size(mov,4))
        m=mov(:,:,:,frame-clipSize:frame+clipSize);
        playMov(m,10);
        r=input('Was the movie acceptable?','s');
        
        if(r=='y')
            break
        else
            
            r=input('What modification needs to be made?(f/b/l/s/y)','s');
            if(r=='f')
                frame=frame+3;
            elseif(r=='b')
                frame=frame-3;
            elseif(r=='l')
                clipSize=clipSize+3;
            elseif(r=='s')
                clipSize=clipSize-3;
            elseif(r=='r')
                clipSize=0;
            end
            disp('Press any key to display the modified clip');
            pause
        end
    end
    Frame(i)=frame;
    ClipSize(i)=clipSize;
end
%clear m
status=3;
save(file_name);

end

if status==3
    
disp('Press any key to begin determining saccade sizes on video');
pause;
for i=1:n
    frame=Frame(i);
    clipSize=ClipSize(i);
    if clipSize
    %[eog_eye_size(i),eog_pix_shifts(i),eog_deg_shifts(i)]=saccadeSizeV1(mov,frame-clipSize,frame+clipSize,eye_size,eye_rotation_depth);
    %[eye_shift_pix1(i),eye_shift_deg1(i),pupil_position2(i),eye_shift_deg2(i)]=
    saccadeSizeV2(mov,frame-clipSize,frame+clipSize,eye_size,eye_rotation_depth)
    else
        eog_eye_size(i)=0;eog_pix_shifts(i)=0;eog_deg_shifts(i)=0;
    end
    disp('Press any key to start the next saccade')
    pause
end

status=4;
save(file_name)
end

% bad_events=~eog_eye_size;
% 
% eog_deg_shifts(bad_events)=[];
% V_shift(bad_events)=[];
% 
% B=regress(eog_deg_shifts',V_shift');
% 
% conversion=B;
% 
% disp(['For this trial, there are ' num2str(B/1000) ' degrees per microvolt']);
% 
% scatter(V_shift,eog_deg_shifts);
% hold on;
% mn=min(V_shift);mx=max(V_shift);
% i=[mn:(mx-mn)./1000:mx];
% y=B.*i;
% plot(i,y);
% 
% scaled_trace=ef.*B;
% figure;plot(t,scaled_trace)
% 
% clear m mov 
% 
% save(file_name)

end

