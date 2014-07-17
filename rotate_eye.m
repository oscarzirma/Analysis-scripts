function [V S]=princomp_eye(X,Y,rot)
%given an X and a Y in mm, this function will convert to angular
%coordinates and output the rotated elements.

pupil_fulcrum_distance = 4.58;



aX=atand((X-median(X))./pupil_fulcrum_distance);
aY=atand((Y-median(Y))./pupil_fulcrum_distance);

[c s l t] = princomp([aX' aY']);
v=atand(c(2,1)/c(1,1))
s=atand(c(2,2)/c(1,2))

rot = -30;%rotation in degrees

% r1=0*sign(v);
% r2=90*sign(s);
%
% r1=v;
% r2=s;

R = [cosd(rot) -sind(rot);sind(rot) cosd(rot)];

VSR = R*[aX;aY];

V = VSR(1,:);
S = VSR(2,:);

figure
scatter(aX,aY);
hold on
scatter(V,S)

display(['V contains ' num2str(100*var(V)/(var(V)+var(S))) '% of the variance.'])
display(['S contains ' num2str(100*var(S)/(var(V)+var(S))) '% of the variance.'])