function [Rdata azimuth stim_pos stim_ind  stim_on stim_off]=find_RF_bar_v2(reps,stim_size,duration,azimuth,file_name)
%this program presents bars across visual space to determine the
%receptive field. reps are the number of repeat stimuli for each
%stimulation site. stim_size is the bar width in degrees. duration is
%the duration of stimulus presentation. it will be preceded by a defined predelay ms
%baseline period and followed by a defined postdelay response period. if azimuth is
%true, it will be across azimuth, if false across elevation. it will run
%from -70 to +70 tiling by stim_size.

isi=1;
pre_delay=.1;
post_delay=.2;

color=[255 255 255];

ra16_file = '../rpx/ro_ra16_two_channel_v.rcx';
[ra16_figure, ra16_handle] = initialize_ra16_rec (1, ra16_file,duration+1000*(pre_delay+post_delay));
[zbus_figure,zbus_handle] = initialize_zbus;

[theWindow,theRect] = Screen(2, 'OpenWindow',[0 0 0]);

pixels_per_cm = 165/6;
eye_screen_dist = 8.5;
DtoP = pixels_per_cm*eye_screen_dist;

stim_pos=-70:stim_size:70;
stim_pos(end)=70;

stim_ind=repmat((1:length(stim_pos)),1,reps);
stim_ind=stim_ind(randperm(length(stim_ind)));

Rdata=cell(length(stim_ind,1);

for i=1:length(stim_ind)
    if azimuth
        az=stim_pos(stim_ind(i));
        wi=stim_size;
        el=0;
        he=theRect(4);
    else
        az=
        wi=theRect(3); 
        el=stim_pos(stim_ind(i));
        he=stim_size;
    end
    
    display_bar(theWindow,theRect,color,az,el,wi,he,DtoP)
    
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

