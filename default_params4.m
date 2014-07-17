 notes    = 'stage_4';%any relevant notes, e.g. stim parameters


%%
%%Visual stimulus parameters 
stim_radius          = 6; %stimulus radius in degrees
stim_duration_a      = 500; %stimulus duration in milliseconds (ms). if array, will sample all elements of array equally 
stim_delay           = 100; %delay between initiation of subtrial and stimulus presentation in ms
stim_contrast        =[1];% %stimulus contrast. if array, will sample all elements of array equally 
no_stim_replacement  = false; %if true, stimuli parameters will not be replaced in queue following gaze break
loom                 = false;%if true, target and distractor increase in radius on each screen refresh
loom_speed_deg       = 30;%rate at which target will increase on each refresh in degrees per second
short_circuit_target = [];
target_only_loom     = false;%if true, only target looms

%Gabor characteristics
gabor_frequency  = .6;%gabor frequency in cycles per degree
stim_gabor       = 90;%gabor rotation on GO trials
nogo_gabor       = 0;%gabor rotation on NOGO trials



%Response box parameters
response_circle_radius = 6;%radius of circle displayed on screen (in pixels)
response_box_radius = 20;%response box radius in degrees
wrong_box_penalty  = [2 2 5];%time in seconds of timeout for wrong choice
response_box_delay = 50;
response_hold_time = 50;
invisible_response_boxes = false;%if true, response boxes are only visible once the bird has looked at one.
invis_box_move  = 5;%number of gaze points bird must move before response box appears
invis_box_delay = 1;%delay after which response box appears regardless of whether it moves
initial_response_box     = true;%if true, response box will be presented with the gaze box at the beginnig of the trial

fixed_response_box = true; %if true, the response will be fixed in angular space (rather than following the stim location). response_box_loc defines the distance from (0,0) in [az el]
response_box_loc = [-10 -20]; %response box location for single. also much change 'generate_response_boxes' to maintain fixed location

shifted_response_box = false;%if true, response box will be shifted from target by an amount selected from response_shift_array
response_shift_array = [10 -20;-10 -20];%shift in response box relative to target location in degrees [x1 y1;x2 y2]

random_response_box_loc = false;%if true, response box will occur randomly at locations specified in response_box_array
response_circle_array      = [-20 -30;0 -30;20 -30];%absolute location of response boxes in degree [x1 y1;x2 y2]

response_box_type  = 'single';%type of response box arrangement. 'horizontal' will mirror a response box on the opposite hemifield, 
                                  %'vertical' will mirror one above or below
                                  %the horizon, and 'quadrant' will produce
                                  %four mirrored boxes. 'single' will
                                  %generate only a single box at the target
                                  %location (for basic training)
post_cue_enable   = false;%this cue is presented at the time that the response boxes are activated. the looks just like the td cue
post_cue_duration = 250;%duration of cue following trialInitH
disable_incorrect_response = false;%this will disable all incorrect responses. for training purposes.

%%
%Distractor parameters
enable_distractor        = false;
yoke_distractor_contrast = true; %if this is true, the distractor contrast will be the same as the target
distractor_contrast      = [1 .25 .1];
dist_no_grating          = true;%if true, distractor will have a grating. Otherwise it is a gaussian

%%
%Head triggering parameters
total_fixation_time  = [525 500];%total delay until trial initiation with stim display, reward chime, reward enabling, and cross removal on response trials. if equal to soft initiation time, hard initiations will be delayed by ~10 ms 
trial_initiation_delay = [100 125];%amount of time before the hard initiation that the recordings should be initiated. IF ARRAY, WILL RANDOMLY SELECT

%Training parameters
head_trig_training   = false; %if true, birds get rewarded just for initiating trial with head position
ramp_initiation_time  = false;%if true, the hard initiation time will become longer over the course of the session. soft initiation will always occur a set time before
init_rate_change      =.1;%rate at which initiation time is increased. 0.5 would increase the time by 50% each time it is evaluated
init_eval_rate        = 15; %number of trials after which the rate will increase

%Peck punish parameters
peck_punish          = true; %if true, pecks to the screen will be punished
peck_threshold       = .071;%value of Y head position to be considered a peck
peck_punish_screen   = true; %if true, a white screen is presented in response to a peck and high frequency tone is played
peck_punish_duration = 2000; %time (in ms) of the timeout penastly screen

%Break gaze parameters
break_gaze_duration  = .5;%pause following breaking gaze after soft initiation in s
break_gaze_color     = [0 0 255].*get_contrast(.5);

calibrate_gaze       = true;

%Gaze box parameters
gaze_box_width_ang    = [18 18];%gaze box width. [x_width y_width] in degrees]
gaze_box_loc_arr      = [0 0];%; -75 -75;75 75;-75 75;75 -75];%;100 0;-100 0;0 -50;100 -50;-100 -50;0 50];%the gaze box center. the first column is the X locations, the second column is the Y. Column location is randomly selected on each trial
gaze_box_loc_shift    = false;
gaze_box_loc_rate     = 2; %# of trials after which box location is switched
gaze_box_shrink       = false;
gaze_box_shrink_freq  = 25;%number of trials after which gaze box shrinks
gaze_box_shrink_rate  = .95;%rate of gaze box shrinking
gaze_loc_refresh      = 25;%time in ms to update the gaze location of the bird onto the screen
gaze_width            = 3;
trackable_reload_time = 30;%time in s between reloadint trackable project. this is to realign it with gaze

%Head zone parameters
Y_center              = .0375;%center of Y (forward-back) limit
Y_limit               = .1;%radius of Y limit
X_center              = 0.005;
X_limit               = .1;
Z_center              = -.468;
Z_limit               = .2;
gaze_box_roll         = 40;%roll in absolute degrees from zero that will allow the trial to go ahead


%Gaze box colors
gaze_box_color_out   = [255 255 255]*get_contrast(.15);
gaze_box_color_in    = [255 0 0].*get_contrast(.15);
gaze_color_out       = [255 0 0].*get_contrast(.4);
gaze_color_in        = [255 0 0].*get_contrast(.4);
gaze_box_present     = false;%if true, a box will be present around the cross at the gaze box
gaze_box_fill        = false;%if true, the box will fill when the gaze is within it


%gaze shift parameters
x_lin_shift=0;
z_lin_shift=0;
yaw_shift=0;
pitch_shift=-10;
pitch_shift_initiation=0;%shift in pitch on trial initiation. to make it easier to get response boxes

%%
%Eye evaluation parameters
track_eye_pos   = false; %if true, the program will block trial initiation or abort trials when the eye is in motion during stimulus presentation
eye_thresh      = 1e-3;%difference between consecutive eye samples that will abort eye eval
eye_pos_refresh = 5;


%%
%NoGo parameters
enable_nogo         = true;
nogo_freq           = .5;
nogo_reward         = 0;%reward rate for a nogo response on a go trial
nogo_hold_time      = 50;%delay in ms before a nogo gaze is counted as a nogo response
nogo_on_go_punish   = true;%if true, will punish bird for making nogo on go trial
break_nogo_punish   = false;%if true, will punish bird for breaking nogo gaze
bias_go_nogo        = false; %will bias the balance of go/nogo trials toward the class with poorer performance
bias_nogo_range     = [.4 .6];%upper and lower limits on bias
nogo_gaze_width     = 20;
nogo_box_loc        = [0 50];%location of nogo box relative to gaze_box_loc

%%
%Posner cue
posner_enable     = false;
cue_targ_inter_a  = 125;%cue target interval
posner_duration   = 10;
posner_size       = 15;

%%
%Top-down cue
TD_enable        = false; %enables top-down cue
td_duration      = 50; %this is the duration of the cue following soft initiation
td_delay         = 50; %delay following trialInitS before cue onsets
td_size          = 5; %cue size in degrees
td_valid         = 1; %proportion of trials on which the top-down cue is valid
cue_frequency    = 0; %proportion of trials on which the top down cue is presented
cue_elevation    = [0];%array of cue elevations. randomly selected on each trial
double_uncue     = true;%if true, on uncued trials cues is presented on both sides, symmetrically
%TD_training      = true; %if true, cue stays on until response boxes appear. The cue photodiode rect is disabled.


%%
%Video eye tracking
video_eye_tracking      = false; %if true, eyelink video eye tracking is enabled
eye_sample_period       = 5; %number of milliseconds between consecutive sampling
eye_sampling_duration   = 400; %time in milliseconds that samples are acquired

%%
%%Trial parameters
num_trials_per_stim = 500; %number of trials per stimulus position (response trials do not count toward this total)
trial_duration      = 3000; %trial duration in ms
auto_reward         = true; %enables automated reward
prob_reward         = 1; %probability of a reward given a successful trial
intertrial_interval = 2000; %minimum delay between the end of one trial and the start of the next
online_analysis     = true;

%%Update parameters
tracker_refresh     = 7; %period of head tracker refresh in ms
screen_update_period = 5;%screen update period in ms

%%
%Head tracking parameters
tt_project    = 'ttj.ttp'; %tracking tools project file containing the relevant rigid body object
head_tracking = true; %if true, head tracking will be enabled

%% all color/shading related parameters
fullblack = 0;
fullwhite = 255;

fixationCrossColor = fullwhite/2;% color of fixation cross/backg
fixationCrossBackg = fullblack;
startBackg         = fullblack;% color of backg when trial starts
experimentBackg    = fullblack;% color of backg for experiment stimuli
punishBackg        = [255 0 0]; %color of backg for punishment
rewardBackg        = [15 75 0];

noise_background = false;%if enabled, the background will be pulled at random from directory 'noise'
noise_mean       = .1;
noise_std        = .01;

%%
%Stimulus location parameters
stimulation_type = 'sampling'; %determines the stimulation type. eligible values are 'quadrant', 'flash', 'sampling'
flash_trials = 0; %the number of whole-screen flash trials to precede target presentation

%Quadrant paramenters
q_X_offset = 30; %x-offset from the cross location
q_Y_offset = 15; %y-offset from the cross location

%Sampling parameters
X_values =[ -30 30]; %x values to be sampled. 0 is center.
Y_values = [ 20 ]; %y values to be sampled. 0 is center.

%Training parameters
bias_stim_location = false; %if bias stim location is true, then stim location will be biased toward locations at which the bird is performing poorly

%RF sampling parameters
sample_RF  = false;%if sample_RF is true, for each stimulus location the azimuth will be shifted according to the values in the X_sampling vector, allowing the RF to be probed
X_sampling = [-30 -20 -10 0 10 20 30];%azimuths to sample relative to each X_values value. allows sampling of RF.
Y_sampling = [-10 0 10 20 30 40];%elevations to sample relative to each Y_values value. allows sampling of RF.

%%
%Pixel to degree conversion

pixels_per_cm            = 100/6.198; %pixel density on screen
eye_screen_distance      = 7; %default distance between eye and screen when stimulus is presented
DtoP                     = pixels_per_cm*eye_screen_distance;%eye-screen distance in pixels

%%
%Recording parameters

record_EOG    = false; %if true, record EOG from the RP2 index 1
record_MAG    = false; %if true, record mag from RP2 index 2
record_neural = false; %if true, record neural responses from Ch1, RA16 index 1

recording_duration = 1000; %duration of recording, starting at the time of the peck.
rp2_file  = '../rpx/ro_rp21_two_channel.rcx';
%ra16_file = '../rpx/ro_ra16_two_channel_v.rcx';
ra16_file = '../rpx/ro_ra16_four_channel_V_new.rcx';

record_video        = false; %if true, records video starting from peck
num_frames          = 30; %number of frames to record. frames are separated by 33 ms
frame_grab_interval = 1;%interval of frames to grab. 1 grabs every frame, 2 grabs every other, etc

online_neural  = false; %if true, will present online analysis of neural responses
high_pass_freq = 400;
spike_thresh   = 4;
Fs             = 2.4332e+004;
labels         = 'azimuth';

enable_blocks = false;%if true, following block_duration trials, the program will evaluate the next row in block_parameters. following the last row, it will return to the first row
block_parameters = {'nogo_freq = 1';'nogo_freq = 0'};
%block_parameters = { 'nogo_freq = 1';'nogo_freq = 0;'; 'nogo_freq = 1';'nogo_freq = 0'; 'nogo_freq    = 1;';'nogo_freq = 0'; 'nogo_freq    = 1;';'nogo_freq = 0'; 'nogo_freq    = 1;'};
block_duration = 10;%number of trials per block
    