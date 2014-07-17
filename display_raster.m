function display_raster(E,trigger,new_fig,color,starting_i)
%this function will display a raster of the event struct E synchronized by
%the time in the vector trigger
if new_fig
    figure
end
hold on
for i=1:length(E)
    x=E(i).spk-trigger(i);
    scatter(x,ones(size(x)).*(i+starting_i-1),color)
end
