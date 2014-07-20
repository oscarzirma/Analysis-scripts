function [Rdata   azimuth elevation stim_val stim_ind  stim_on stim_off]=vary_duration_contrast(reps,stim_size,duration,contrast,azimuth,elevation,file_name)
%this program presents dots at a point in visual space of varying contrast and duration. 
%reps are the number of repeat stimuli for each
%stimulation site. stim_size is the stimulus size in degrees. duration is a vector of
%the duration of stimulus presentation. it will be preceded by a specified
%pre_delay baseline period and followed by a post_delay period. contrast 
%defines the range of contrasts to be tested azimuth defines
%the azimuth and elevation the elevation. if file_name = 'no_save' it will
%not save.

isi=2;
pre_delay=.2;
post_delay=.2;

full_color=[255 255 255];

ra16_file = '../rpx/ro_ra16_two_channel_v.rcx';
[ra16_figure, ra16_handle] = initialize_ra16_rec (1, ra16_file,duration+1000*(pre_delay+post_delay));
[zbus_figure,zbus_handle] = initialize_zbus;

[theWindow,theRect] = Screen(2, 'OpenWindow',[0 0 0]);

pixels_per_cm = 165/6;
eye_screen_dist = 8.5;
DtoP = pixels_per_cm*eye_screen_dist;

j=1;
for i=1:length(duration)
    for k=1:length(contrast)
        stim_val(j,:)=[duration(i) contrast(k)];
        j=j+1;
    end
end

stim_ind=repmat((1:j),1,reps);
stim_ind=stim_ind(randperm(length(stim_ind)));

n=length(stim_ind);

Rdata=cell(n,1);
stim_on=zeros(n,1);stim_off=stim_on;

for i=1:length(n)
    color=full_color*stim_val(i,2);
    duration=stim_val(i,1);
    
    display_dot(theWindow,theRect,color,azimuth,elevation,stim_size,DtoP)
    
    t1=tic;
    invoke(zbus_handle, 'ZBUSTrigA', 0, 0, 10);%trigger recordings
    
    while toc(t1)<pre_delay
        %baseline delay
    end
    Screen('Flip', theWindow); %add stimulus
    stim_on(i)=toc(t1);
    
    Screen('FillRect', theWindow, [0 0 0])
    
    while toc(t1)<(pre_delay+duration/1000)
        %wait after stim onset
    end
    Screen('Flip', theWindow); %remove stimulus
    stim_off(i)=toc(t1);
    
    while toc(t1) < isi
        %inter stim interval
    end
    rdata=rec_neur_data (ra16_handle);
    Rdata(i)= {rdata};
end


Screen('Close',theWindow)

if ~strcmp(file_name,'no_save')
    save(file_name);
end

