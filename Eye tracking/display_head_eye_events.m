function display_head_eye_events(events)
%given a struct array with the following fields: eye_left,eye_right,x,y,z
%with event times in seconds, will display a raster of all events using
%different colors for the different fields and different rows for different
%trials

el_color = [0 0 1.0000];
er_color = [1 0 0.5];

x_color = [1 .75 0];
y_color = [1 0 0 ];
z_color = [0 .5 0];

peck_color = [0 1 0];

figure
hold on
n=length(events);
for i=1:length(events)
    e=events(i);
       scatter(e.eye_left-.1,0-i.*ones(size(e.eye_left)),15,el_color,'filled')
       scatter(e.eye_right-.1,-n-i.*ones(size(e.eye_right)),15,er_color,'filled')
scatter(e.x-.1,i.*ones(size(e.x)),15,x_color,'filled')
    scatter(e.y-.1,n+i.*ones(size(e.y)),15,y_color,'filled')

    scatter(e.z-.1,2*n+i.*ones(size(e.z)),15,z_color,'filled');

    scatter(e.peck-.1,3*n+i*ones(size(e.peck)),15,peck_color,'filled')
end