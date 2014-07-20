%Program that actually runs the paradigm one protocol.
%There are two versions of this protocol: one for the touchscreen (TS) and
%one for the headtracking (HT). They are different in one important
%respect. Both iterate through a loop for each trial. However, for the TS,
%it waits for a peck in each iteration and then triggers the stimulus, not
%recording pecks during that period. This will not work for the HT system,
%as it needs to be actively updated to resample, so each iteration updates
%the position whereas the TS system automatically updates the position in
%real time.
%There are a few possibilities for moving forward. One is to stop the
%waiting in the TS version and just have it grab the current cursor
%position in each iteration. This will require either resetting the position
%or testing whether the cursor position moved on
%each iteration so that new pecks can be detected. Another option would be
%to write an independent program (exe) that will initialize the HT system
%and track movements which matlab can grab independently. Or we could set
%up a dedicated tracking server which would stream tracking data. That
%would probably be an easier option.
%The other possibility is to have the two programs run differently, which
%would also be acceptable.

%This version of the program iterates with a particular refresh period,
%sampling the pointer position at each iteration. Pecks to the cross are
%reset to a baseline pointer position (0,0) in order to reduce erroneous
%repeated cross pecks. It would be best to NOT touch the mouse while this
%version of the program is running.

%paradigm_one_HT differs from _TS in that the trial is triggered by head
%position rather than by a peck to the cross.

%%
%Initializations

if auto_reward %addition of auto reward
    dio=digitalio('parallel','LPT1');
    addline(dio,0,'out')
    putvalue(dio.Line(1),1)
end
%%
if head_tracking
    %initialize head tracking
    if ~libisloaded('NPTrackingTools')%ensure tracking tools library is loaded
        
        addpath('C:\Program Files\NaturalPoint\TrackingTools\lib');
        addpath('C:\Program Files\NaturalPoint\TrackingTools\inc');
        
        [notfound,warnings]=loadlibrary('NPTrackingTools','NPTrackingTools.h');
    end
    calllib('NPTrackingTools', 'TT_Initialize'); %initialize cameras
    calllib('NPTrackingTools', 'TT_ClearTrackableList'); %remove any pre-loaded trackables
    calllib('NPTrackingTools', 'TT_LoadProject', tt_project); %load project
    %define the outputs types from TT_TrackableLocation function
    X = 0;Y = 0;Z = 0;
    qx = 0;qy = 0;qz = 0;qw = 0;
    yaw = 0;pitch = 0;roll = 0;
    mx = 0; my = 0; mz = 0;
    
    TC = calllib('NPTrackingTools','TT_TrackableCount'); %find out how may trackable objects are present. the program will always track object #0
    if TC>1
        tcp = input('More than one rigid body. Continue assuming body #0 is the head(y/n)? ', 's');
        if tcp == 'n'
            error('Terminating run to avoid confusion over rigid bodies...')
        end
    end
end

%%start recordings

if record_EOG
    [rp2_figure, rp2_handle, zbus_figure, zbus_handle] = initialize_rp2_rec (1, rp2_file,recording_duration);
    edata=[];
    save([fname_data 'EOG'],'edata')
    scrsz = get(0,'ScreenSize');
    efig=figure('Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
end
if record_neural
    [ra16_figure, ra16_handle, zbus_figure, zbus_handle] = initialize_rp2_rec (1, ra16_file,recording_duration);
        ndata=[];
    save([fname_data 'Neural'],'ndata')
end

if record_video
    vid=videoinput('winvideo',1,'RGB24_720X480','FramesPerTrigger',10);
    tinfo = triggerinfo(vid);
    triggerconfig(vid,tinfo(2));
    clear tinfo;
    set(vid,'ReturnedColorSpace','grayscale');
end

if limit_head_pos %if the head position is constrained, load the limits. in format [Lxh Lxl;Lyh Lyl;Lzh ...]
    load(head_limit)
end
%% display startup and run trials (psychtoolbox)

% open a window on screen "1" and clear it: identity of screen (#) in a
% multi-display setup can be found using:
% Desktop(rt-click)->Properties->Settings->Identify
display_num = 2;
cur_disp    = 0;
verbosity_level = 1; % turn off ptb warnings and stuff, except error

[theWindow, theRect, midScreenX, midScreenY, fixCenterX, fixCenterY] = ...
    startup_screen(display_num, verbosity_level, fix_X_offset, fix_Y_offset);

Screen(theWindow,'FillRect', startBackg);
Screen('Flip', theWindow);
%ShowCursor

trial_counter = 1;
vis_trials=1;
vis_trial_id = 1; %record the identity of each response trial preceding a visual trial

targ_color = (targ_contrast * (fullwhite - fullblack));
%stim_color = (stim_contrast * (fullwhite - fullblack));

vis_trial_failures = 0;

while vis_trials <= num_trials
    
    %Find location of target
    
    response_trial = 0; %response and visual subtrial indicator
    
    if (~response_trial_index(trial_counter)&&(vis_trial_id==1))||all_response_trials
        xstimp = x_stim_array(stimuli_positions(vis_trials));%find stim location
        ystimp = y_stim_array(stimuli_positions(vis_trials));
        
        x_stim_pos = DtoP*tand(xstimp);
        y_stim_pos = DtoP*tand(ystimp);
        
        xdisp = fixCenterX+x_stim_pos; % abs because stim_pos automagically adjusts these given just the displacement magnitudes
        ydisp = fixCenterY-y_stim_pos;
        
        vis_trials=vis_trials+1;
        
        
        
    elseif response_trial_index(trial_counter) %if it is a response trial, assign identifier
        response_trial = 1;
        vis_trial_id   = 1;
        if reduce_contrast
            if (sum(targ_color)/3)>final_contrast
                targ_color = targ_color - [1 1 1]%reduce target contrast to zero
            elseif targ_duration>=final_duration
                targ_duration = targ_duration - 10
            end
        end
    else
        vis_trials=vis_trials+1;
    end
    
    stimulus_position(trial_counter,:)=[x_stim_pos y_stim_pos];
    subtrial_type(trial_counter)=response_trial;
    
    %calculate target radius and permitted radius
    ang_disp = sqrt(xstimp^2 + ystimp^2);%net displacement from center (radius between target location and center)
    
    targ_permitted_radius_pix = ((DtoP*tand(ang_disp+targ_permitted_radius)-DtoP*tand(ang_disp-targ_permitted_radius))/2);
    
    %% pre trial initializations
    xChoice             = -1;
    yChoice             = -1;
    succFlag            = 0;
    fixUp               = false; %has the fixation cross been presented?
    trialInit           = false;
    trialOver           = false;
    firstPeck           = false;
    num_fix_peck        = 0;
    stimDisplay         = false; %stimulus display indicator - is stimulus CURRENTLY on
    reward_given        = 0; %indicator of whether a reward was given on the trial
    stimPresented       = false; %was a stimulus presented?
    p0                  = tic; %pointer refresh index initialization
    h0                  = tic; %head tracker refresh index initialization
    iteration           = 1; %index of head tracking frames
    track_pos           = [];
    marker_pos          = [];
    pt_track_pos         = []; %pre-trial initiation tracker position
    pt_index            = 1; %pre-trial tracker index
    frame_marker_pos    = [];
    rxn                 = 0;
    fx_pk_tm            = 0;
    num_pecks           = 0;
    peck_loc            = [];
    pointer_delay       = 0;
    
    SetMouse(0,0,theWindow); %initialize mouse pointer to baseline condition
    if record_video
        start(vid);
    end
    
    %set parameters for response or visual trial
    if response_trial
        delay             = targ_delay;
        duration          = targ_duration;
        color             = round(targ_color);
        cross_color       = experimentBackg;
        circ_rad_targ  = (DtoP*tand(ang_disp+targ_radius)-DtoP*tand(ang_disp-targ_radius))/2;
        trial_duration    = resp_trial_duration;
    else
        delay          = stim_delay;
        duration       = stim_duration(trial_counter);
        color          = (stim_contrast(trial_counter) * (fullwhite - fullblack));
        cross_color    = fixationCrossColor;
        circ_rad_targ  = (DtoP*tand(ang_disp+stim_radius)-DtoP*tand(ang_disp-stim_radius))/2;
        trial_duration = vis_trial_duration;
        if identical_visual_trials %if all visual trials are identical, index them up one. this will block the assignment of a new target location
            vis_trial_id = vis_trial_id + 1;
        end
    end
    
    display(['Trial #' num2str(trial_counter)]);
    
    t0=tic; %timer from start of trial, rather than initiation of trial
    
    while ~trialOver
        if trialInit %if the trial has been initiated, go on to evalueate stimuli, reward, etc
            %If trialInit is true, then determine based on the clock
            %whether the stimulus should be presented
            
            if (~stimDisplay)&&(~stimPresented)&&(toc(t1) >= delay/1000) %if time is after and stimulus has not been presented, display stimulus
                t2 = toc(t1); %duration of delay
                t3=tic;
                Screen('FillOval', theWindow, color, [fixCenterX+x_stim_pos-circ_rad_targ, fixCenterY-y_stim_pos-circ_rad_targ+cur_disp, fixCenterX+x_stim_pos+circ_rad_targ, fixCenterY-y_stim_pos+circ_rad_targ+cur_disp]);
                Screen('DrawLine', theWindow, cross_color, fixCenterX-fix_radius-1, fixCenterY, fixCenterX+fix_radius, fixCenterY, 3);
                Screen('DrawLine', theWindow, cross_color, fixCenterX, fixCenterY-fix_radius-1, fixCenterX, fixCenterY+fix_radius, 3);
                Screen('Flip', theWindow); %display stimulus
                stimDisplay = true;
            elseif stimDisplay&&(toc(t3) >= (duration)/1000) %if the target duration is passed but stimDisplay is still true, turn off the stimulus
                t4=toc(t3); %duration of stimulus
                Screen('DrawLine', theWindow, cross_color, fixCenterX-fix_radius-1, fixCenterY, fixCenterX+fix_radius, fixCenterY, 3);
                Screen('DrawLine', theWindow, cross_color, fixCenterX, fixCenterY-fix_radius-1, fixCenterX, fixCenterY+fix_radius, 3);
                Screen('Flip', theWindow); %remove stimulus
                stimDisplay = false;
                stimPresented = true;
            end
        end
        if head_tracking&&toc(h0) > tracker_refresh/1000 %if sufficient time has passed, update head position
            if trialInit %if the trial has been initiated, save all tracking position
                calllib('NPTrackingTools', 'TT_Update');%update frame
                th=toc(t1);%tracking update timestamp
                h0=tic;
                if calllib('NPTrackingTools','TT_IsTrackableTracked',0) %is the head tracked in this frame? if so, capture data
                    [X,Y,Z,qx,qy,qz,qw,yaw,pitch,roll] = calllib('NPTrackingTools', 'TT_TrackableLocation',0,X,Y,Z,qx,qy,qz,qw,yaw,pitch,roll);
                    track_pos(iteration,:)=[th X Y Z yaw pitch roll];
                    marks = calllib('NPTrackingTools','TT_TrackableMarkerCount',0); %Get a count of the markers within trackable 0
                    for m=0:marks-1 %get position of each marker within trackable
                        [mx my mz] = calllib('NPTrackingTools','TT_TrackableMarker',0,m,mx,my,mz); %relative positions
                        marker_pos(iteration,:,m+1) = [X Y Z] + [mx my mz]; %save absolute positions
                    end
                end
                marks = calllib('NPTrackingTools','TT_FrameMarkerCount'); %count of all markers in the frame
                for m=0:marks-1 %get position of each marker within frame
                    mx = calllib('NPTrackingTools','TT_FrameMarkerX',m); %x position
                    my = calllib('NPTrackingTools','TT_FrameMarkerY',m); %y position
                    mz = calllib('NPTrackingTools','TT_FrameMarkerZ',m); %z position
                    frame_marker_pos(iteration,:,m+1)= [mx my mz];
                end
                iteration = iteration + 1;
            else %if the trial has not been initiated, update pt_track_pos (pre trial track position)
                calllib('NPTrackingTools', 'TT_Update');%update frame
                tp=toc(t0);%tracking update timestamp
                h0=tic;
                [X,Y,Z,qx,qy,qz,qw,yaw,pitch,roll] = calllib('NPTrackingTools', 'TT_TrackableLocation',0,X,Y,Z,qx,qy,qz,qw,yaw,pitch,roll);
                pt_track_pos(pt_index,:) = [tp X Y Z yaw pitch roll];
                if pt_index == 12;
                    pt_track_pos(1,:)=[];
                else
                    pt_index = pt_index + 1;
                end
            end
        end
        
        %%determine if head is within initiation zone and, if so, initiate trial
        if ~trialInit
            if head_within_limits_lin(limits,X,Y,Z)
                if head_in_zone
                    if toc(z0)>initiation_zone_time
                        firstPeck = true;
                        trialInit=true;
                        t1=tic;
                        %trigger recordings
                    end
                else
                    head_in_zone = true;
                    z0=tic;
                end
            else
                head_in_zone = false;
            end
        end
                            else
                                firstPeck = true;
                                trialInit=true;
                                t1=tic;
                                if(record_EOG||record_neural)
                                    invoke(zbus_handle, 'ZBUSTrigA', 0, 0, 10);%trigger recordings
                                end
                                if record_video
                                    trigger(vid)%trigger video
                                end
                            end
                        else
                            fx_pk_tm(num_fix_peck+1) = toc(t1);
                            num_fix_peck = num_fix_peck + 1;
                            if (~response_trial)&&visual_trial_reward&&(num_fix_peck > visual_trial_reward_num_pecks)%&&stimPresented
                                disp('visual trial success')
                                succFlag = -1; %reward on visual trial indicator
                                if (rand < visual_trial_prob_reward)
                                    reward_given = 1;
                                    disp('reward')
                                end
                                trialOver = true;
                                break
                            end
                        end
                        %setmouse(0,0,theWindow); %reinitialize pointer to baseline in order to stop an automatic fix peck
                    end

        
        
        if trialInit&&(toc(t1) > trial_duration/1000) %if the trial has exceeded its fixed duration, break
            trialOver = true;
            if response_trial
                succFlag = -5;
            else
                succFlag = -4; %time out success flag
            end
            break
        end
        
        
        if toc(p0) > pointer_refresh/1000 %Has sufficient time passed to update pointer position?
            [xloc,yloc,buttons] = GetMouse(theWindow); %get pointer position for this iteration
            SetMouse(0,0,theWindow); %reinitialize pointer to baseline in order to detect pecks on next iteration
            if toc(p0) > pointer_delay/1000
                pointer_delay = 0;
                if ~fixUp %has the fixation cross been presented. if no, put up cross
                    Screen(theWindow,'FillRect', experimentBackg);
                    Screen('DrawLine', theWindow, fixationCrossColor, fixCenterX-fix_radius-1, fixCenterY, fixCenterX+fix_radius, fixCenterY, 3);
                    Screen('DrawLine', theWindow, fixationCrossColor, fixCenterX, fixCenterY-fix_radius-1, fixCenterX, fixCenterY+fix_radius, 3);
                    Screen('Flip', theWindow);
                    fixUp = true; %trial has been initiated
                end
                %%Determine if there was a peck and find the location of that peck
                if ~((xloc==-1280)&&(yloc==0)) %has the pointer moved? i.e. has the bird pecked
                    pointer_delay = 50; %if a peck is detected, delay the next pointer refresh
                    %if the trial is already initiated, check if the bird pecked the cross
                    if trialInit
                        num_pecks = num_pecks + 1;
                        peck_loc(num_pecks,:)=[toc(t1) xloc yloc];
                    end
                    fixDist = ((xloc - fixCenterX)^2 + (yloc - fixCenterY)^2)^0.5;
                    
%                     if fixDist < fix_permitted_radius %was the peck to the fixation cross?
%                         if ~firstPeck %is this the first peck to the fixation cross? if so, start stimulation clock (t1) and initiate recordings
%                             if limit_head_pos %if trial initiation is limited by head position, evaluate head pos
%                                 if head_within_limits(limits,X,Y,Z,yaw,pitch,roll)
%                                     firstPeck = true;
%                                     trialInit=true;
%                                     t1=tic;
%                                     %trigger recordings
%                                 end
%                             else
%                                 firstPeck = true;
%                                 trialInit=true;
%                                 t1=tic;
%                                 if(record_EOG||record_neural)
%                                     invoke(zbus_handle, 'ZBUSTrigA', 0, 0, 10);%trigger recordings
%                                 end
%                                 if record_video
%                                     trigger(vid)%trigger video
%                                 end
%                             end
%                         else
%                             fx_pk_tm(num_fix_peck+1) = toc(t1);
%                             num_fix_peck = num_fix_peck + 1;
%                             if (~response_trial)&&visual_trial_reward&&(num_fix_peck > visual_trial_reward_num_pecks)%&&stimPresented
%                                 disp('visual trial success')
%                                 succFlag = -1; %reward on visual trial indicator
%                                 if (rand < visual_trial_prob_reward)
%                                     reward_given = 1;
%                                     disp('reward')
%                                 end
%                                 trialOver = true;
%                                 break
%                             end
%                         end
%                         %setmouse(0,0,theWindow); %reinitialize pointer to baseline in order to stop an automatic fix peck
%                     end
                    if response_trial&&(stimDisplay||stimPresented)%if it's a response trial and the target is or has been displayed, determine if peck to target
                        targDist = ((xloc - xdisp)^2 + (yloc -ydisp)^2)^0.5;
                        if (targDist < targ_permitted_radius_pix) %was the peck to the target?
                            rxn = toc(t1); %rxt time measured from initiation of trial
                            disp('successful trial reward')
                            trialOver = true;
                            succFlag = 1; %successful success flag
                            reward_given = 1;
                            break
                        end
                    end
                    
                    if visual_trial_fail_punish
                        if (fixDist>visual_trial_fail_radius)&&((~response_trial)||(~(stimDisplay||stimPresented)))
                            Screen(theWindow,'FillRect', punishBackg);
                            Screen('Flip', theWindow);
                            disp('visual trial fail')
                            vis_trial_failures = vis_trial_failures + 1;
                            pause(2);
                            Screen(theWindow,'FillRect', experimentBackg);
                            Screen('DrawLine', theWindow, fixationCrossColor, fixCenterX-fix_radius-1, fixCenterY, fixCenterX+fix_radius, fixCenterY, 3);
                            Screen('DrawLine', theWindow, fixationCrossColor, fixCenterX, fixCenterY-fix_radius-1, fixCenterX, fixCenterY+fix_radius, 3);
                            Screen('Flip', theWindow); %remove fail screen
                            SetMouse(0,0,theWindow); %reinitialize pointer to baseline in order to detect pecks on next iteration
                        end
                    end
                end
                p0=tic;
            end
        end
        
    end
    
    Screen('DrawLine', theWindow, cross_color, fixCenterX-fix_radius-1, fixCenterY, fixCenterX+fix_radius, fixCenterY, 3);
    Screen('DrawLine', theWindow, cross_color, fixCenterX, fixCenterY-fix_radius-1, fixCenterX, fixCenterY+fix_radius, 3);
    Screen('Flip', theWindow); %remove stimulus
    
    
    display(['Trial outcome: ' num2str(succFlag)]);
    
    if reward_given == 1
        if auto_reward && rand < prob_reward
            putvalue(dio.Line(1),0)
            pause(0.01)
            putvalue(dio.Line(1),1)
            pause(1.5)
        end
    end
    
    succFlag_index(trial_counter) = succFlag;
    reward_index(trial_counter) = reward_given;
    
    if stimPresented
        delay_duration(trial_counter)=t2;
        actual_target_duration(trial_counter)=t4;
    end

    if record_EOG
        figure(efig)
        edata= rec_eog_data(rp2_handle);
        subplot(2,1,1)
        if(~isempty(edata))
        plot(edata(1,:),edata(2,:))
        subplot(2,1,2)
        plot(edata(1,:),edata(3,:))
        end
        EOG(trial_counter)={edata};
        clear edata
    end
    if record_neural
        ndata= rec_neur_data(ra16_handle);
        subplot(2,1,2)
        if ~isempty(ndata)
        plot(ndata(1,:),ndata(2,:));
        end
        Neural(trial_counter)={ndata};
        clear ndata
    end
    if record_video
        mov=getdata(vid);
        flushdata(vid);
        save([fname_data '_mov' num2str(trial_counter)],'mov')
        clear mov
    end
    
    if head_tracking
        if size(pt_track_pos)~=[0 0]
            pt_track_pos(:,1)=pt_track_pos(:,1)-ones(size(pt_track_pos(:,1))).*tp;%make the times in the pt_track_pos vector negative from the trial initiation time
            track_pos = [pt_track_pos;track_pos]; %concatenate pt_track_pos to _track_pos
        end
        headPosition(trial_counter,:)={track_pos marker_pos frame_marker_pos};
    end
    
    peckLocations(trial_counter) = {peck_loc};
    reaction_time(trial_counter) = rxn;
    fix_peck_time(trial_counter) = {fx_pk_tm};
    
    if response_trial
        save([fname_data '_tr' num2str(trial_counter)])
    end
    
    trial_counter = trial_counter + 1;%increment trial counter
    
    
end

delete(dio)
clear dio

if record_EOG
    cleanup_ht_rec(rp2_handle, rp2_figure, zbus_figure)
end
if record_neural
    cleanup_ht_rec(ra16_handle, ra16_figure, zbus_figure)
end

%cleanup_eog_neur_ht_rec(ra16_handle1, ra16_figure1,ra16_handle2, ra16_figure2,ra16_handle3,ra16_figure3, zbus_figure)

Screen(theWindow,'Close');
ShowCursor;



