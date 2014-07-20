function [eye_shift_pix1,eye_shift_deg1,pupil_position2,eye_shift_deg2]=saccadeSizeV3(m,frame1,frame2,eye_dimension,eye_depth)
%m is a movie of eye movements, frame1 is the pre-saccade frame, frame 2 is
%the post-saccade frame. eye_dimension is the length across the eye in mm,
%eye_depth is the presumed depth of the eye for the angle calculation. will
%present first the frame1 and will request the left border of the eye and
%then the right border of the eye, and then the caudal end of the nares. it will the present the post-saccade
%frame and request first the left and then the right border of the eye,
%followed by the caudal end of the nares. recommending targeting the left
%and rigth borders near the eog electrodes. measured eye dimension was 10
%mm and eye depth 10 mm.
%V2 first asks the user to draw a rectangle around the region of interest.
%the program will adjust the axes to display just that rectangle. Improfile
%will then be run and the user will draw a line connecting the nasal and
%temporal eyelid junctions. The program will then plot the image
%intensities along this line and ask for the user to specify the left and
%right margins of the pupil, which are represented by drops of intensity.
%The program then determines the shift in pupil position in pixels and
%degrees
%2 strategies: one determines the shift in pixels of the pupil center and
%then uses the average of the eye size in the two frames as a conversion
%factor to convert this shift in pixels to one in degrees
%the second assumes that the pupil is at 0° in the very center and as it 
%shifts forward and back it moves in absolute degrees in the orbit. So the
%position of the pupil center is calculated in degrees for both frames and
%then the shift is calculated based on that difference. eye_position2
%represents the pupil position in degrees before and after the shift

%version 3 segments the eye and then asks the user to select the pupil
%segment.

frame1 = m(:,:,:,frame1);
scrsz = get(0,'ScreenSize');
h=figure('Position',[1 scrsz(4)/1.1 scrsz(3)/1.1 scrsz(4)/1.1]);
imshow(frame1);

title('Select the ROI')
rect=round(getrect);
axis([rect(1) rect(1)+rect(3) rect(2) rect(2)+rect(4)])

title('Drag line from nasal to temporal junction of eyelids, bisecting pupil, then double click online')

g=imline;
ey1=round(wait(g));
clear g;

ey1_intensity=improfile(frame1,ey1(:,1),ey1(:,2));

plot(ey1_intensity);

title('Click left, then right border of pupil (transition to low value)')

[pupil1 ~]=ginput(2);


last_frame=size(m,4); 
if(frame2>last_frame)
    frame2=last_frame;
end
frame2=m(:,:,:,frame2);
imshow(frame2);

title('Select the ROI')
rect=round(getrect);
axis([rect(1) rect(1)+rect(3) rect(2) rect(2)+rect(4)])

title('Drag line from nasal to temporal junction of eyelids, bisecting pupil, then double click online')

g=imline;
ey2=round(wait(g));
clear g

ey2_intensity=improfile(frame2,ey2(:,1),ey2(:,2));

plot(ey2_intensity);

title('Click left, then right border of pupil (transition to low value)')

[pupil2 ~]=ginput(2);

close(h)

ey_size1 = length(ey1_intensity);%calculate eye size, which is the number of pixels per eye dimension (default = 10mm)
ey_size2 = length(ey2_intensity);

pupil_center1 = mean(pupil1);%calculate center of pupil
pupil_center2 = mean(pupil2);


%pixel position using algorithm 1
eye_shift_pix1 = pupil_center2-pupil_center1%shift in pixels

mean([ey_size1 ey_size2])
eye_shift_pix1/mean([ey_size1 ey_size2])

eye_shift_mm1 = eye_shift_pix1/mean([ey_size1 ey_size2])*eye_dimension

eye_shift_deg1 = atand(eye_shift_mm1/eye_depth)

%pixel position using algorithm 2
pupil_center1_mm = (pupil_center1-(ey_size1/2))/ey_size1*eye_dimension;
pupil_center2_mm = (pupil_center2-(ey_size2/2))/ey_size2*eye_dimension;

pupil_position2(1) = atand(pupil_center1_mm/eye_depth);
pupil_position2(2) = atand(pupil_center2_mm/eye_depth);

eye_shift_deg2 = diff(pupil_position2);

