function t=display_rect(theWindow,color,coordinates,ti)
%clears screen to black and displays a rectangle of the given color and
%coordinates. color is rgb. coordinates are left border, top, right,
%bottom. returns time of screen flip relative to ti input.

%displays stimulus

Screen('FillRect', theWindow, [0 0 0])
Screen('FillRect', theWindow, color,coordinates)
Screen('Flip', theWindow); %present stimulus
t = toc(ti); %duration of delay