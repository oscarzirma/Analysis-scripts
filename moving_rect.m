function moving_rect(theWindow,height,overlap,ir_pause,vert_move)
%displays a moving rectangle. height is specified. overlap is the number of
%pixels overlap between successive rectangles. pause is the duration before
%a new rectangle is presented, vert_move means the rectangle moves
%vertically if true, horizontally if false

screen_height = 1024;
screen_width   = 1280;

if vert_move
    num_iterations = (screen_height )/(height-overlap);
else
    num_iterations = (screen_width )/(height-overlap);
end

present_point = 0;

for i=1:num_iterations
    ti=tic;
    if vert_move
        display_rect(theWindow,[255 255 255],[0 present_point screen_width present_point+height],ti);
     else
        display_rect(theWindow,[255 255 255],[present_point 0   present_point+height screen_height],ti);
    end
    present_point=present_point+height-overlap;
    while toc(ti)<ir_pause
        %wait
    end
end

Screen('FillRect', theWindow, [0 0 0])
Screen('Flip', theWindow); %remove stimulus