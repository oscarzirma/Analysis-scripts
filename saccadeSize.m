function s=saccadeSize(m,frame1,frame2,eye_dimension,eye_depth)
%m is a movie of eye movements, frame1 is the pre-saccade frame, frame 2 is
%the post-saccade frame. eye_dimension is the length across the eye in mm,
%eye_depth is the presumed depth of the eye for the angle calculation. will
%present first the frame1 and will request the left border of the eye and
%then the right border of the eye, and then the caudal end of the nares. it will the present the post-saccade
%frame and request first the left and then the right border of the eye,
%followed by the caudal end of the nares. recommending targeting the left
%and rigth borders near the eog electrodes. measured eye dimension was 10
%mm and eye depth 10 mm.

f1=m(:,:,:,frame1);
f2=m(:,:,:,frame2);

scrsz = get(0,'ScreenSize');
h=figure('Position',[1 scrsz(4)/1.1 scrsz(3)/1.1 scrsz(4)/1.1]);
imshow(f1,'InitialMagnification',160);

disp('Click first left, then right borders of eye along longest dimension')%get the eye size
eys=ginput(2);
% 
% disp('Click left border of pupil, right border of pupil, and caudal edge of nares.')%get the pupil position for frame 1
% ey1=ginput(3);

f1B=rgb2gray(f1)<.22*255;
f2B=rgb2gray(f2)<.25*255;
imshow(f1B,'InitialMagnification',160);pause
imshow(f2B,'InitialMagnification',160);pause

imshow(f2B-f1B,'InitialMagnification',160)

disp('Click on the left and right borders of the eye shift. Then click on the left and right borders of the body shift.')%get the eye size
positions=ginput(4);

close(h)


eye_size=sqrt((eys(1,1)-eys(2,1))^2+(eys(1,2)-eys(2,2))^2);%measure eye size in pixels

conversion=eye_size/eye_dimension;%determine conversion from pixels to mm

head_shift=positions(4,1)-positions(3,1)%how far did the head shift between frames

eye_shift=positions(2,1)-positions(1,1)-head_shift

s=atand(eye_shift/(eye_depth*conversion))

return