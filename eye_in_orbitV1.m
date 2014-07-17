function [pupil_mm pupil_deg]=eye_in_orbitV1(M,eye_dimension,eye_depth)
%based on saccade size V2 algorithm 2. returns the eye in orbit position
%for each frame. returns the deviation of the pupil center in mm and in
%degrees along the long axis of the eye

n=size(M,4);

pupil_mm=nan(n,1);
pupil_deg=nan(n,1);

for i=1:n
    frame = M(:,:,:,i);
    scrsz = get(0,'ScreenSize');
    h=figure('Position',[1 scrsz(4)/1.1 scrsz(3)/1.1 scrsz(4)/1.1]);
    imshow(frame);
    
    title('Select the ROI. If the image is bad,just double click')
    rect=round(getrect);
    
    if rect(3)>5
        
        axis([rect(1) rect(1)+rect(3) rect(2) rect(2)+rect(4)])
        
        title('Drag line from nasal to temporal junction of eyelids, bisecting pupil, then double click online')
        
        g=imline;
        ey1=round(wait(g));
        clear g;
        
        ey1_intensity=improfile(frame,ey1(:,1),ey1(:,2));
        
        plot(ey1_intensity);
        
        title('Click left, then right border of pupil (transition to low value)')
        
        [pupil1 ~]=ginput(2);
        
        close(h)
        
        ey_size1 = length(ey1_intensity);%calculate eye size, which is the number of pixels per eye dimension (default = 10mm)
        
        pupil_center1 = mean(pupil1);%calculate center of pupil        
        
        %pixel position using algorithm 2
        pupil_mm(i) = (pupil_center1-(ey_size1/2))/ey_size1*eye_dimension;
        
        pupil_deg(i) = atand(pupil_mm(i)./eye_depth);
        
        
    end
end