function [x z] = pixToPos(xS,yS)
%accepts screen positions in pixels and returns those positions in meters

%based on -.319 m change per 1090 pixels in x and point (1415,.144)
% .240 m change per 801 pixels in y/z and point (134,.390)

xS=xS+1415;

mx=-.319/1090; 
bx = .144 - mx*1415;

my=.24/801; by = .39 - my*134;

x=mx*xS+bx;
z=-(my*yS+by);

% scatter([1415 xS],[.144 x])
% hold on
% l=axis;
% i=(l(1):((l(2)-l(1))/1000):l(2));
% plot(i,mx.*i + bx.*ones(size(i)))


return