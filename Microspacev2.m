function MicroSpacev2(Info)
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
imgM=ones(384)*Info(1,4);
[m,n]=size(Info);

j=1;k=1; zerozero=[];
for(i=4:m)
    x=Info(i,4);
    if(x<Info(1,4))
        x=Info(1,4);
    end
    M=ones(16).*x;
    M(8:9,8:9)=ones(2).*(.5*Info(1,4));
    imgM(((Info(i,2)*64+184):(Info(i,2)*64+199)),((Info(i,1)*64+184):(Info(i,1)*64+199)))=M;
    if ((Info(i,2)==0)&&(Info(i,1)==0))
        zerozero(j,k)=x;
        j=j+1;
    end
end
imgM(Info(1,2)*64+192,Info(1,1)*64+192)=.5*max(max(imgM));
imgM(Info(2,2)*64+192,Info(2,1)*64+192)=.4*max(max(imgM));
imgM(Info(3,2)*64+192,Info(3,1)*64+192)=.4*max(max(imgM));

subplot(2,2,1); imagesc(imgM)
colormap('hot')
colorbar
%pause();

%Microphonic reponse / interferometer response
r=Info(1,4)/Info(1,5);
img=ones(384)*0;
[m,n]=size(Info);

j=1;k=2;
for(i=4:m)
    x=Info(i,4)/Info(i,5);
    if(x>r)
        x=0;
    end
    M=ones(16).*x;
    M(8:9,8:9)=ones(2).*(.5*Info(1,4));
    img(((Info(i,2)*64+184):(Info(i,2)*64+199)),((Info(i,1)*64+184):(Info(i,1)*64+199)))=M;
    if ((Info(i,2)==0)&&(Info(i,1)==0))
        zerozero(j,k)=x;
        j=j+1;
    end
end
img(Info(1,2)*64+192,Info(1,1)*64+192)=.5*max(max(img));
img(Info(2,2)*64+192,Info(2,1)*64+192)=.4*max(max(img));
img(Info(3,2)*64+192,Info(3,1)*64+192)=.4*max(max(img));

subplot(2,2,2); imagesc(img)
colormap('hot')
colorbar
%pause();

%interferometer response
img=ones(384)*Info(1,5);
[m,n]=size(Info);

j=1;k=3;
for(i=4:m)
    x=Info(i,5);
    if(x<Info(1,5))
        x=Info(1,5);
    end
    M=ones(16).*x;
    M(8:9,8:9)=ones(2).*(.5*Info(1,4));
    img(((Info(i,2)*64+184):(Info(i,2)*64+199)),((Info(i,1)*64+184):(Info(i,1)*64+199)))=M;
    if ((Info(i,2)==0)&&(Info(i,1)==0))
        zerozero(j,k)=x;
        j=j+1;
    end
end
img(Info(1,2)*64+192,Info(1,1)*64+192)=.5*max(max(img));
img(Info(2,2)*64+192,Info(2,1)*64+192)=.4*max(max(img));
img(Info(3,2)*64+192,Info(3,1)*64+192)=.4*max(max(img));

subplot(2,2,3); imagesc(img)
colormap('hot')
colorbar
%pause();


%zero zero point distribution
[m,n]=size(zerozero);

for(i=1:n)
    zerozero(:,i)=zerozero(:,i)./max(zerozero(:,i));
end

subplot(2,2,4); plot(zerozero)
axis([0 m+1 0 1.1])

end