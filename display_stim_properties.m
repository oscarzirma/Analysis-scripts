function STIMPROP = display_stim_properties(STIM,STIMPROP)
%This function will display the relative positions of the stimulus and
%distractor as well as their shapes in a figure window

if ~isfield(STIMPROP,'stimulus_figure')
    STIMPROP.stimulus_figure = figure;
end

figure(STIMPROP.stimulus_figure)
clf
whitebg(STIMPROP.stimulus_figure,[0 0 0]);
hold on;
axis([-60 60 -60 60])

if STIM.shape == 3 %if stimulus is square
    draw_square_to_figure(STIMPROP.stimulus_figure,STIM.x,STIM.y,STIM.radius)
elseif STIM.shape == 5 %if stimulus is X
    draw_X_to_figure(STIMPROP.stimulus_figure,STIM.x,STIM.y,STIM.radius)
end

if STIM.distractor&&STIMPROP.num_distractors == 1
    if STIM.d_shape == 3 %if stimulus is square
        draw_square_to_figure(STIMPROP.stimulus_figure,STIM.dx,STIM.dy,STIM.radius)
    elseif STIM.d_shape == 5 %if stimulus is X
        draw_X_to_figure(STIMPROP.stimulus_figure,STIM.dx,STIM.dy,STIM.radius)
    end
end