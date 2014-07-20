function [pupil,i] = pupilDetectAuto(image,starting_pos)
%given an image, this will binarize it (55/255), bwareaopen(100), invert,
%bwareaopen(100), bwlabel, then display to user, who will click on the
%pupil, which will then be returned as a struct with centroid, area,
%majorAxis, minorAxis, eccentricity, and orientation. i is the region ID
%(to test whether it is identical across frames). If check_regionID is
%true, it will display the frame and have the user click on the pupil to
%indicate the regionID. Otherwise it will use the number provided by the
%user.
%auto version will assume that the relevant region is near the starting
%position. if the starting_pos does not overlap a region, it will test one
%to the left,up,right,down, then 2 to the left, right, up down, etc until a
%region is found. recommend using previous centroid for the starting_pos
i=0;

x=round(starting_pos(1));
y=round(starting_pos(2));

bw=im2bw(image,55/255);

bwa=bwareaopen(bw,100);

bwai=~bwa;

bwaia=bwareaopen(bwai,100);

l=bwlabel(bwaia);

i=l(y,x);%which region is the pupil

j=1;
while i==0%if the starting_pos was uninformative, explore
    display(['Explore ... j = ' num2str(j)])
   i=l(y,x-j);if i~=0 break;end
   i=l(y-j);if i~=0 break;end
   i=l(y,x+j);if i~=0 break;end
   i=l(y+j,x);
end

r=regionprops(l,'all');

rp=r(i);

pupil.Centroid=rp.Centroid;
pupil.Area=rp.Area;
pupil.MajorAxis=rp.MajorAxisLength;
pupil.MinorAxis=rp.MinorAxisLength;
pupil.Eccentricity=rp.Eccentricity;
pupil.Orientation=rp.Orientation;

