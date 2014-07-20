function MicroSpacev1(Info)
%takes in a 5 column matrix containing x-coordinates in the first column,
%y-coordinates in the second, stimuli in the third, microphonic responses
%in the fourth, and interferometer responses in the fifth. the first row
%contains the position of the fish's head. It will then
%generate three plots, causing between each. the first will be the
%microphonic response divided by the interferometer response. the second
%will be the microphonic response, and the third will be the interferometer
%response. the responses will be placed at the position from which the
%stimulus was sent. The intensity of the response will be indicated by the
%heat of the spot.

img=zeros(24,24,3);
[m,n]=size(Info);



for(i=4:m)
    x=Info(i,4);
    img(Info(i,2)*4+12,Info(i,1)*4+12,:)=[x x x];
end
img(Info(1,2)*4+12,Info(1,1)*4+12)=1.2*max(max(img));
img(Info(2,2)*4+12,Info(2,1)*4+12)=1.1*max(max(img));
img(Info(3,2)*4+12,Info(3,1)*4+12)=1.1*max(max(img));

imagesc(img)
colorbar
pause();

img=zeros(24);
for(i=4:m)
    x=Info(i,4)/Info(i,5);
    img(Info(i,2)*4+12,Info(i,1)*4+12)=x;
end
img(Info(1,2)*4+12,Info(1,1)*4+12)=1.2*max(max(img));
img(Info(2,2)*4+12,Info(2,1)*4+12)=1.1*max(max(img));
img(Info(3,2)*4+12,Info(3,1)*4+12)=1.1*max(max(img));

imagesc(img)
colorbar
pause();

img=zeros(24);
for(i=4:m)
    x=Info(i,5);
    img(Info(i,2)*4+12,Info(i,1)*4+12)=x;
end
img(Info(1,2)*4+12,Info(1,1)*4+12)=1.2*max(max(img));
img(Info(2,2)*4+12,Info(2,1)*4+12)=1.1*max(max(img));
img(Info(3,2)*4+12,Info(3,1)*4+12)=1.1*max(max(img));

imagesc(img)
colorbar
pause();

end