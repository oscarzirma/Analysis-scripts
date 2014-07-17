function [I1 I2] = circleIntersect(C1,C2,R1,R2)
%given the centers and radii of two circles, it will return the two points
%of intersection

A = C1; %# center of the first circle
B = C2; %# center of the second circle
a = R2; %# radius of the SECOND circle
b = R1; %# radius of the FIRST circle
c = norm(A-B); %# distance between circles

cosAlpha = (b^2+c^2-a^2)/(2*b*c);

u_AB = (B - A)/c; %# unit vector from first to second center
pu_AB = [u_AB(2), -u_AB(1)]; %# perpendicular vector to unit vector

%# use the cosine of alpha to calculate the length of the
%# vector along and perpendicular to AB that leads to the
%# intersection point
I1 = A + u_AB * (b*cosAlpha) + pu_AB * (b*sqrt(1-cosAlpha^2));
I2 = A + u_AB * (b*cosAlpha) - pu_AB * (b*sqrt(1-cosAlpha^2));

