% Stage 4
% Go/NoGo Response
% Train the bird to orient to the response circle on Go stimuli and to the NoGo cross on NoGo stimuli. 
% This may take a while, but she should eventually grasp it.
% 
% Parameters to vary:
% 
% X_values - stimulus X position. Switch this between -30 and 30. Initially, only use one value for the entire day.
%                                 Once the bird is performing reasonably well (>65%), you can switch to having 
%                                 both values (X_values = [30 -30]), which will then randomly switch sides.
% 
% nogo_freq - proportion of trials that will be nogo. if the bird will only give either go or nogo responses, 
%             you can give only trials of the other until she will give both. Make sure not to just be switching back 
%             and forth from all Gos to all NoGos and vice versa.
% 
% When to move on: When the bird will perform interleaved trials with both X_values and her overall performance is >75%

default_params;%initialize default parameters
default_params4;


%%
%Stage four parameters
X_values = [-30] ;%azimuth position of stimulus. Positive values to the right.

nogo_freq = 0.5;%Try to keep this value at 0.5. If the bird will absolutely not give a certain response, force her to do so by moving this to 0 or 1.


%Other parameters
yaw_shift=0;%if the gaze is off in azimuth, adjustments can be made with this parameter. Positive values are to the right.
pitch_shift=-10;%if the gaze is off in elevation, adjustments can be made with this parameter. Positive values are up.


run_paradigm_two_training;