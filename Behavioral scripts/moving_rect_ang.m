function moving_rect_ang(theWindow,height,width,r_start,r_end,overlap,ir_pause,vert_move,DtoP)
%displays a moving rectangle. height is specified in °. width has the coordinates
%in the invariant direction in °, [+ -] (e.g [20 -10]. start is starting position
%in °, end is ending position. positive values are up/left. overlap is the number of
%° overlap between successive rectangles. pause is the duration before
%a new rectangle is presented, vert_move means the rectangle moves
%vertically if true, horizontally if false. DtoP is the eye-screen distance
%times the number of pixels per degree.

screen_height = 1024;
screen_width   = 1280;

span = r_end-r_start;

num_iterations = abs(span)/(height-overlap);

present_point = start;

r_width=tand(width).*DtoP;

for i=1:num_iterations
    if vert_move
        if span>0%if bar is moving vertically, top to bottom
            left = r_width(1);
            right = r_width(2);
            top = tand(present_point)*DtoP;
            bottom = tand(present_point-height)*DtoP;
            present_point=present_point-height+overlap;
        else%bottom to top
            left = r_width(1);
            right = r_width(2);
            top = tand(present_point+height)*DtoP;
            bottom = tand(present_point)*DtoP;
            present_point=present_point+height-overlap;
        end
    else
        if span>0%bar moving horizontally, left to right
            left = tand(present_point)*DtoP;
            right = tand(present_point-height)*DtoP;
            top = r_width(1);
            bottom = r_width(2);
            present_point=present_point-height+overlap;
        else%right to left
            left = tand(present_point+height)*DtoP;
            right = tand(present_point)*DtoP;
            top = r_width(1);
            bottom = r_width(2);
            present_point=present_point+height-overlap;
        end
    end
            
    while toc(ti)<ir_pause
        %wait
    end
        display_rect(theWindow,[255 255 255],[left top right bottom],ti);
end

Screen('FillRect', theWindow, [0 0 0])
Screen('Flip', theWindow); %remove stimulus
        
        