function [Rdata   azimuth elevation stim_pos stim_ind  stim_on stim_off]=find_RF_circles(reps,stim_size,duration,azimuth, elevation,file_name)
%this program presents dots over a portion of visual space to determine the
%receptive field. reps are the number of repeat stimuli for each
%stimulation site. stim_size is the stimulus size in degrees. duration is
%the duration of stimulus presentation. it will be preceded by a 300 ms
%baseline period and followed by a 400 ms response period. azimuth defines
%the azimuth range in the format [left :interval :right]. for example, if you
%want to sample from -20 (left) to 40 (right) every 10°, azimuth=[-20:10:40].
%elevation is the same, with downward values being negative.

isi=2;
pre_delay=.2;
post_delay=.2;

color=[255 255 255];

ra16_file = '../rpx/ro_ra16_two_channel_v.rcx';
[ra16_figure, ra16_handle] = initialize_ra16_rec (1, ra16_file,duration+1000*(pre_delay+post_delay));
[zbus_figure,zbus_handle] = initialize_zbus;

[theWindow,theRect] = Screen(2, 'OpenWindow',[0 0 0]);

pixels_per_cm = 165/6;
eye_screen_dist = 8.5;
DtoP = pixels_per_cm*eye_screen_dist;

j=1;
for i=1:length(azimuth)
    for k=1:length(elevation)
        stim_pos(j,:)=[azimuth(i) elevation(k)];
        j=j+1;
    end
end

stim_ind=repmat((1:j),1,reps);
stim_ind=stim_ind(randperm(length(stim_ind)));

Rdata=cell(length(stim_ind,1);

for i=1:length(stim_ind)
    display_dot(theWindow,theRect,color,stim_pos(stim_ind(i),1),stim_pos(stim_ind(i),2),stim_size,DtoP)
    
    t1=tic;
    invoke(zbus_handle, 'ZBUSTrigA', 0, 0, 10);%trigger recordings
    
    while toc(t1)<pre_delay
        %baseline delay
    end
    Screen('Flip', theWindow); %remove stimulus
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
    Rdata(i)= {rdata};%CHECK
end


Screen('Close',theWindow)

if ~strcmp(file_name,'no_save')
    save(file_name);
end

