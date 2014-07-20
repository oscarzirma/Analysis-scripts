function [pupil,i] = pupilDetect(image,regionID,check_regionID)
%given an image, this will binarize it (55/255), bwareaopen(100), invert,
%bwareaopen(100), bwlabel, then display to user, who will click on the
%pupil, which will then be returned as a struct with centroid, area,
%majorAxis, minorAxis, eccentricity, and orientation. i is the region ID
%(to test whether it is identical across frames). If check_regionID is
%true, it will display the frame and have the user click on the pupil to
%indicate the regionID. Otherwise it will use the number provided by the
%user.

i=0;

bw=im2bw(image,55/255);

bwa=bwareaopen(bw,100);

bwai=~bwa;

bwaia=bwareaopen(bwai,100);

l=bwlabel(bwaia);

if check_regionID
    imagesc(l);
    title('Click on the pupil');
    while i==0 %in case click outside pupil, get infinite chances
        [x y]=ginput(1);%where is pupil
        
        i=l(round(y),round(x));%which region is the pupil
    end
else
    i=regionID;
end

r=regionprops(l,'all');

rp=r(i);

pupil.Centroid=rp.Centroid;
pupil.Area=rp.Area;
pupil.MajorAxis=rp.MajorAxisLength;
pupil.MinorAxis=rp.MinorAxisLength;
pupil.Eccentricity=rp.Eccentricity;
pupil.Orientation=rp.Orientation;

