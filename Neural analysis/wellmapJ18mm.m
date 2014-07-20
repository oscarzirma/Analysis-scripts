function wellmapJ18mm
%plots a well map for the double eccentric well positioning system. the
%center of the disk rotates around the center of the well at a radius of
%its eccentricity

wellRadius   = 9; %well is 18 mm in diameter
diskRadius   = 8; %radius of the disk that the guide tube moves in
eccentricity = 8; %distance between the centers of the two circles

rotationInterval = 10; %interval in degrees of rotation of the disk around the well (lower coordinates)
diskGrid         = 20; %number of divisions of the grid lines for the rotation of the disk itself (upper coordinates)

c = (2*pi)/360; % degree to radian conversion

t = (0:(2*pi)/100:2*pi);

plot(wellRadius.*sin(t),wellRadius.*cos(t),'g','LineWidth',2)
axis square; hold on

rot = (0:rotationInterval:360); %intervals of well rotation (lower coordinates)

t = (0:-120/diskGrid:-140); %intervals of disk rotation (upper coordinates)
o = ones(size(t));

for index=1:length(rot)
    
    
    switch mod(index,5) 
         case 0 
             color = 'r';
        case 1
             color = 'g';
         case 2 
             color = 'b';
         case 3
             color = 'k';
        case 4
            color = 'c';
        case 5
            color = 'm';
         end
    i=rot(index);
    x = eccentricity*cos(i*c); %find center of circle
    y = eccentricity*sin(i*c);
    
    I = circleIntersect([0 0],[x y],wellRadius,diskRadius);
        
    ts = t + o.*atan2(c*(I(2)-y),c*(I(1)-x))/c; %rotate disk grid
    
    plot(wellRadius*sin(i*c),wellRadius*cos(i*c),[color '*'],'MarkerSize',20) %blue * indicate the interval marks in lower coordinates
    
    plot((eccentricity.*sin(ts*c))+y.*o,(eccentricity.*cos(ts*c))+x.*o,['-' color '.'],'MarkerSize',10)
    
end

axis([-wellRadius wellRadius -wellRadius wellRadius])
  xlabel('Medial <---> Lateral');
  ylabel('Posterior <---> Anterior');
  grid on