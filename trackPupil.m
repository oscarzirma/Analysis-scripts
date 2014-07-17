function [p centroid centroidp centroida zero mov] = trackPupil(Mov,eye_width)
%This program runs through a movie using pupilDetect to detect the pupil
%centroid of each frame. It also has the user input the eye width at its
%widest point in mm (input) and pixels (graphically). centroid position is
%returned in mm location.

scrsz = get(0,'ScreenSize');
h=figure('Position',[1 scrsz(4)/1.1 scrsz(3)/1.1 scrsz(4)/1.1]);
m=Mov(:,:,:,1);
imagesc(m);%get eye size
title('Drag line from nasal to temporal junction of eyelids, bisecting pupil, then double click online')
g=imline;
eye_pix=round(wait(g));
imagesc(m);%get eye size
pause(1)
title('Drag box around pupil')
rect=uint16(getrect);
% pupBox = m(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3));
% subplot(211)
% hist(double(m(:)),100)
% subplot(212)
% hist(double(pupBox(:)),100)
% title('select upper threshold for pupil')
% [t v]=ginput(1);
% imshow(m<t);
% pause
% c=[rect(1)+rect(3)/2 rect(2)+rect(4)/2];%find pupil centroid to prime
c=[rect(3)/2 rect(4)/2];%find pupil centroid to prime

close(h)
pause(.1)
w=eye_pix(2,:)-eye_pix(1,:);
pix_width = sqrt(w(1)^2+w(2)^2);

n=size(Mov,4);
p(n)=declare_pupil_struct;
mov=zeros(rect(4)+1,rect(3)+1,1,n);

for i=1:n
    
    p(i)=pupilDetectFullAuto(Mov(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3),:,i),c,55);%give the bounding box around the eye to the detection algorithm
    %c=p(i).Centroid;%find centroid of current iteration to prime next
    %iteration
    mov(:,:,1,i)=Mov(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3),:,i);
    
end

centroidp = cat(1, p.Centroid);

zero=median(centroidp);

centroidp=centroidp-repmat(median(centroidp),n,1);%remove error values

i=find((abs(centroidp(:,1))>10)+(abs(centroidp(:,2))>15));

%centroidp(i,:)=repmat(mean(centroidp),length(i),1);

centroidp(i,:)=nan(length(i),2);

centroida=cat(1,p.Area);
i=find(centroida<(centroida(1)/2));

centroidp(i,:)=nan(length(i),2);

%centroidp=centroidp-repmat(nanmedian(centroidp),n,1);

centroid=centroidp./(pix_width./eye_width);

eye_depth = 6;%eye depth of 6 mm
centroida=atand(centroid./eye_depth);