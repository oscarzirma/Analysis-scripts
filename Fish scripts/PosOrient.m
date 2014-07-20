function [P3 O c]=PosOrient(Image,display)
%takes in high contrast Aplocheilus image and outputs the position of its
%head and center and the angle of its body with vertically pointing up being 0 degrees
%P3 is position. c is centroid position. O is angle.

bw=bwlabel(Image);%label image
warning off MATLAB:divideByZero

P=regionprops(bw,'Area','Extrema','Centroid');%get region properties
%P=regionprops(bw,'All');%get region properties

area=[P.Area];

[A,im]=max(area);%find region w/ maximum area

f=P(im);%assign region of maximum area to fish

%find extrema with maximum distance between them (representing points on
%the long distance of the fish

e=[f.Extrema];

jm=1;km=1;mlen=0;

for(j=1:length(e)-1)
    for(k=j:length(e)-1)
        len=sqrt((e(j,1)-e(k,1))^2+(e(j,2)-e(k,2))^2);
        if(len>mlen)
            mlen=len;
            jm=j;km=k;
        end
    end
end
if(isempty(e))
    c=[20,20];
    P3=c;
    O=0;
    return
end
    
e1=e(jm,:);%the most separated extrema
e2=e(km,:);

%determine which extrema is further from the centroid. since the centroid
%is closer to the head than the tail, the one that is further is at the
%tail.

c=f.Centroid;

l1=sqrt((e1(1)-c(1))^2+(e1(2)-c(2))^2);
l2=sqrt((e2(1)-c(1))^2+(e2(2)-c(2))^2);

if(l1>l2)
    head=e2;
    len=l2;
    h=km;
else
    head=e1;
    len=l1;
    h=jm;%record which extrema is being used for the head.
end

%define the position of the head of the fish as being on the line between
%the centroid coordinate and the head coordinate 2/3 of the way to the head
%coordinates. added new part, which finds the adjacent extrema (to head) that is
%furthest from the centroid, finds the x and y coordinates 2/3 of the way
%between those two, and averages the two x and y coordinates to find the
%head position.

dx=abs(head(1)-c(1));
dy=abs(head(2)-c(2));

if(head(1)>c(1))
    x=c(1)+.67*dx;
else
    x=head(1)+.33*dx;
end

if(head(2)>c(2))
    y=c(2)+.67*dy;
else
    y=head(2)+.33*dy;
end

if(h==1)
    ae=f.Extrema(2,:);
end    
if(h==8)
    ae=F.Extrema(7,:);
end
if((h~=8)&&(h~=1)) %determine which extrema adjacent to head is further from centroid
    aeL1=sqrt((c(1)-f.Extrema(h-1,1))^2+(c(2)-f.Extrema(h-1,2))^2);
    aeL2=sqrt((c(1)-f.Extrema(h+1,1))^2+(c(2)-f.Extrema(h+1,2))^2);
    if(aeL1>aeL2)
        ae=f.Extrema(h-1,:);
    else
        ae=f.Extrema(h+1,:);
    end
end

dx=abs(ae(1)-c(1));
dy=abs(ae(2)-c(2));

if(ae(1)>c(1))
    x2=c(1)+.67*dx;
else
    x2=ae(1)+.33*dx;
end

if(ae(2)>c(2))
    y2=c(2)+.67*dy;
else
    y2=ae(2)+.33*dy;
end

xm=mean([x x2]);
ym=mean([y y2]);

P=[x y];%position of head
P2=[xm ym];
P3=mean([P;P2]);
%new method of defining head: using the mean value of the four extrema.
%there are 8 extrema total, here we use the four on the same side as the
%'head' value found above. this is to try to find the head position in a
%more central location rather than to one side as the previous method did.

dx=P2(1)-c(1);
dy=P2(2)-c(2);

if(dx<0&&dy<0)
    O=atand(dx/dy);
elseif(dx<0&&dy>0)
    O=90+atand(-dy/dx);
elseif(dx>0&&dy>0)
    O=180+atand(dx/dy);
else
    O=270+atand(-dy/dx);
end
    

if(display==1)
%bw(round(c(2)),round(c(1)))=8;
%bw(round(y),round(x))=7;
%bw(round(head(2)),round(head(1)))=5;
bw(round(P3(2)),round(P3(1)))=4;
%figure,
imagesc(bw),axis image
colorbar()
pause(.001)
%close(gcf)
end


return



