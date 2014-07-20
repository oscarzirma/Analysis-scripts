function [Rdata   direction dimension stim_dur start_pos end_pos stim_time]=find_RF_full_bars(reps,bar_width,duration,file_name)
%this program uses bars across the entire field to find the receptive
%field. reps is the nubmer of repititions each for vertical and horizontal probes.
%half of the probes will be up/down and the other half down/up. bar_width is the bar width in
%degrees, duration is the time it should take for the bar to cross the
%screen in ms. the output is a cell array of neural traces and the indices of
%stimulus direction and dimension. goes from ±70 in each dimension. if file
%name = 'no_save', it will not save.

ra16_file = '../rpx/ro_ra16_two_channel_v.rcx';
[ra16_figure, ra16_handle] = initialize_ra16_rec (1, ra16_file,duration+500);
[zbus_figure,zbus_handle] = initialize_zbus;

[theWindow,theRect] = Screen(2, 'OpenWindow',[0 0 0]);

pixels_per_cm = 165/6;
eye_screen_dist = 8.5;
DtoP = pixels_per_cm*eye_screen_dist;

direction = randi([0 1],1,2*reps);%1 is up to down or left to right
dimension = randi([0 1],1,2*reps);%1 is up/down

overlap = round(.3*bar_width);
ir_pause = .9*(duration/1000)/(140/(bar_width-overlap));

Rdata=cell(2*reps,1);

for i=1:2*reps
   
    if direction(i)%if + to -, set parameters
        r_start = 80;
        r_end = -80;
    else
        r_start = -80;
        r_end = 80;
    end
        
    
    if dimension(i)%if up/down, set parameters
        width = [80 -80];
        vert_move = true;
    else
        width = [80 -80];
        vert_move = false;
    end
    t1=tic;
    invoke(zbus_handle, 'ZBUSTrigA', 0, 0, 10);%trigger recordings
    
    while toc(t1)<.3
    %baseline delay
    end    
    tr=tic;
    [start_pos(i,:) end_pos(i,:) stim_time(i,:)]=moving_rect_ang(theWindow,bar_width,width,r_start,r_end,overlap,ir_pause,vert_move,DtoP,tr);
    stim_dur(i)=toc(tr);
    
    while toc(t1)<(duration+500)/1000
    %wait after
    end
    rdata=rec_neur_data (ra16_handle);
    Rdata(i)= {rdata};%CHECK
    while toc(t1) < 5
        %inter stim interval
    end
 end

%     rdata=nan(length(Rdata),(duration+500)*24);
% 
% for i=1:length(Rdata)
%     x=cell2mat(Rdata(i));
%     size(x)
%     if ~isempty(x)
%         rdata(i,:)=x(2,1:(duration+500)*24);
%     end
% end
 stim_dur
Screen('Close',theWindow)

if ~strcmp(file_name,'no_save')
    save(file_name);
end
    
    