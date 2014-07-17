function [Cc]=coordPol2Cart(Fish,Cp)
%Takes in a fish position matrix (fish head;fishnose;fishtail) and a list
%of polar coordinates relative to the fish head. Returns the coordinates
%converted to cartesian coordinates relative to (0,0). takes in degrees and
%cm, outputs in inches.

x0=Fish(1,1);y0=Fish(1,2);%coordinates of fish head
theta=atan2((Fish(3,2)-Fish(2,2)),(Fish(2,1)-Fish(3,1)));
[m,n]=size(Cp);O=ones(m,1);

[x,y]=pol2cart(deg2rad(Cp(:,2))+O.*theta,Cp(:,1)/2.54);

x=x+O.*Fish(1,1);
y=-1.*y+O.*Fish(1,2);

Cc=[x y];

return
