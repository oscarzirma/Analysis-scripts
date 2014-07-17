function draw_square_to_figure(fig,x,y,r)
%this function will draw a square in the figure fig with center at x,y and
%radius r. 'hold' should already be set to 'on'

figure(fig)

plot([x-r x-r],[y-r,y+r],'LineWidth',2)
plot([x+r x+r],[y-r,y+r],'LineWidth',2)
plot([x-r x+r],[y-r,y-r],'LineWidth',2)
plot([x-r x+r],[y+r,y+r],'LineWidth',2)
