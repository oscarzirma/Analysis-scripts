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


%Microphonic Response
img=zeros(48);
[m,n]=size(Info);

j=1;k=1; zerozero=[];
for(i=4:m)
    x=Info(i,4);
    M=ones(3).*x;
    M(2,2)=-.05*max(max(img));
    img((Info(i,2)*12+23):(Info(i,2)*12+25),(Info(i,1)*12+23):(Info(i,1)*12+25))=M;
    if ((Info(i,2)==0)&&(Info(i,1)==0))
        zerozero(j,k)=x;
        j=j+1;
    end
end
img(Info(1,2)*12+24,Info(1,1)*12+24)=.5*max(max(img));
img(Info(2,2)*12+24,Info(2,1)*12+24)=.4*max(max(img));
img(Info(3,2)*12+24,Info(3,1)*12+24)=.4*max(max(img));

imagesc(img)
colorbar
pause();

%Microphonic reponse / interferometer response
img=zeros(48);
[m,n]=size(Info);

j=1;k=2;
for(i=4:m)
    x=Info(i,4)/Info(i,5);
    M=ones(3).*x;
    M(2,2)=-.05*max(max(img));
    img((Info(i,2)*12+23):(Info(i,2)*12+25),(Info(i,1)*12+23):(Info(i,1)*12+25))=M;
    if ((Info(i,2)==0)&&(Info(i,1)==0))
        zerozero(j,k)=x;
        j=j+1;
    end
end
img(Info(1,2)*12+24,Info(1,1)*12+24)=.5*max(max(img));
img(Info(2,2)*12+24,Info(2,1)*12+24)=.4*max(max(img));
img(Info(3,2)*12+24,Info(3,1)*12+24)=.4*max(max(img));

imagesc(img)
colorbar
pause();

%interferometer response
img=zeros(48);
[m,n]=size(Info);

j=1;k=3;
for(i=4:m)
    x=Info(i,5);
    M=ones(3).*x;
    M(2,2)=-.05*max(max(img));
    img((Info(i,2)*12+23):(Info(i,2)*12+25),(Info(i,1)*12+23):(Info(i,1)*12+25))=M;
    if ((Info(i,2)==0)&&(Info(i,1)==0))
        zerozero(j,k)=x;
        j=j+1;
    end
end
img(Info(1,2)*12+24,Info(1,1)*12+24)=.5*max(max(img));
img(Info(2,2)*12+24,Info(2,1)*12+24)=.4*max(max(img));
img(Info(3,2)*12+24,Info(3,1)*12+24)=.4*max(max(img));

imagesc(img)
colorbar
pause();

[m,n]=size(zerozero);

for(i=1:n)
    zerozero(:,i)=zerozero(:,i)./max(zerozero(:,i));
end

plot(zerozero)
axis([0 m+1 0 1.1])

end