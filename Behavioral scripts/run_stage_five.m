% Stage 5
% Variable stimulus position
% Train the bird to respond well even when the stimulus position is highly variable. 
% The response circle will be relocated to directly beneath the cross.
% 
% Parameters to vary:
% 
% X_values - start with this the same as in Stage 4 ([30 -30]), but once the bird is doing well, switch to ([50 30 -30 -50)
% 
% Y_values - start with this at [0], but once the bird will reliably respond to the larger X_values array, switch to [20 0 -20].
% 
% sample_rf - when bird is doing well with the larger X_values and Y_values arrays, switch this parameter from 'false' to 'true'. 
%             The stimulus location will now be highly variable.
% 
% When to move on: When all of the parameters have met their goal and the bird's overall performance is >75%.

default_params;%initialize default parameters
default_params4;


%%
%Stage five parameters
X_values = [-30 30] ;%azimuth positions of stimulus. Positive values to the right.

Y_values = [0];%elevation positions of stimulus. Positive values up.

sample_rf = false;%If this is true, extra stimulus positions will be sampled.

nogo_freq = 0.5;%Try to keep this value at 0.5. If the bird will absolutely not give a certain response, force her to do so by moving this to 0 or 1.


%Other parameters
yaw_shift=0;%if the gaze is off in azimuth, adjustments can be made with this parameter. Positive values are to the right.
pitch_shift=-10;%if the gaze is off in elevation, adjustments can be made with this parameter. Positive values are up.


run_paradigm_two_training;