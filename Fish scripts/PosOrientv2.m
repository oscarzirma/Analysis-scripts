function [P O C1]=PosOrientv2(Image,Display)
%A new position and oriention program that tries to rectify the problem of
%finding the head when the fish is curled. P3=head position, O=orientation (with
%0 degrees being up and increasing counter-clockwise) and c=centroid.

bw=bwlabel(Image);%label image
warning off MATLAB:divideByZero

P=regionprops(bw,'Area','Extrema','Centroid','Orientation','MinorAxisLength');%get region properties
%P=regionprops(bw,'All');%get region properties

area=[P.Area];

[A,im]=max(area);%find region w/ maximum area
if isempty(A)
    P=[40 40];O=0;C1=[10 10];
    return
end
f=P(im);%assign region of maximum area to fish

%Cut the fish in two using by drawing a line along the minor axis of the
%fish

C1=f.Centroid;
minor=f.MinorAxisLength;
MajOrient=f.Orientation;
L=f.MinorAxisLength;

if(MajOrient>0)
    MinOrient=MajOrient-90;
else
    MinOrient=MajOrient+90;
end

Mn2=[C1(1)+((L/2)*cosd(MinOrient)),C1(2)-((L/2)*sind(MinOrient))];
Mn1=[C1(1)-((L/2)*cosd(MinOrient)),C1(2)+((L/2)*sind(MinOrient))];

%imshow(bw)
%hold on
%plot(C1(1),C1(2),'r*')
%plot(Mn1(1),Mn1(2),'b*')
%plot(Mn2(1),Mn2(2),'g*')

[ind label]=drawline([Mn1(2) Mn1(1)],[Mn2(2) Mn2(1)],size(bw));

bw2=bw;
bw2(ind)=0;


se = strel('disk',1);
bw2=imerode(bw2,se);

%now label the image with the fish cut along its minor axis

bw2=bwlabel(bw2,4);
P=regionprops(bw2,'Area','Extrema','Centroid','Orientation');


%and find the centroid of the largest unit. is it the right one?

area=[P.Area];

[A,im]=max(area);%find region w/ maximum area
if isempty(A)
    P=[40 40];O=0;C1=[10 10];
    return
end
f2=P(im);%assign region of maximum area to fish

C2=f2.Centroid;

if(Display)
    imshow(bw2)
    hold on
    plot(C2(1),C2(2),'r*')
end

%now find angle of line between C1 and C2(head position P).

P=C2;

dx=P(1)-C1(1);
dy=P(2)-C1(2);

if(dx<0&&dy<0)
    O=atand(dx/dy);
elseif(dx<0&&dy>0)
    O=90+atand(-dy/dx);
elseif(dx>0&&dy>0)
    O=180+atand(dx/dy);
else
    O=270+atand(-dy/dx);
end

    
return