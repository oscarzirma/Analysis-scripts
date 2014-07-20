%the Eye matrix as
%eye coordinates. The first row is time, the second and third are raw pupil
%center, forth and fifth are raw pupil - glint0, sixth and seventh are raw
%pupil - glint 1. it will produce correlation matrices for each of these
%sets


vertical = true;
right = 1;

camera_distance = 10.75;%camera distance in inches
IR_spacing = 9;%glint IR lamp spacing in inches
glint_angle = 2*atand((IR_spacing/2)/camera_distance);

conversion = easyGazeDistance(camera_distance*2.54)/10; %conversion in pixels per mm

fulcrum_pupil_distance = 4.58;%cornea-pupil distance in mm

    
Te=Eye(1,:);
if vertical
    X=Eye(3,:)./conversion;
    Y=Eye(2,:)./conversion;
else
    X=Eye(2,:)./conversion;
    Y=Eye(3,:)./conversion;
end

if right
    X=-X;
    mL=mdata;
    mdata=mdata2;
end

[V S]=rotate_eye(X,Y);%rotate X and Y so that X is along the axis of maximal variance

% [V S]=princomp_eye(X,Y);%rotate X and Y so that X is along the axis of maximal variance
 x=X;
y=Y;
X=V;
Y=S;

mX=median(X);
mY=median(Y);

Tm=mdata(1,:);
A=mdata(2,:);
B=mdata(3,:);
C=mdata2(2,:);
D=mdata2(3,:);

eye_mag_calibration_2chan;

 %pXAB=diff(vXAB,1,1);
% pYAB=diff(vYAB,1,1);
  pXAB=(vXAB);
 pYAB=(vYAB);


pX=X;
pY=Y;

% if vertical
%     X=Eye(5,:)./conversion;
%     Y=Eye(4,:)./conversion;
% else
%     X=Eye(4,:)./conversion;
%     Y=Eye(5,:)./conversion;
% end
% 
% eye_mag_calibration_2chan;
% 
% g0XAB=vXAB;
% g0YAB=vYAB;
% 
% g0X=X;
% g0Y=Y;
% 
% if vertical
%     X=Eye(7,:)./conversion;
%     Y=Eye(6,:)./conversion;
% else
%     X=Eye(6,:)./conversion;
%     Y=Eye(7,:)./conversion;
% end
% 
% eye_mag_calibration_2chan;
% 
% g1XAB=vXAB;
% g1YAB=vYAB;



display('Pupil X correlation')
corrcoef(pXAB)
display('Pupil Y correlation')
corrcoef(pYAB)
% 
% display(' ')
% display('Gaze 0 X correlation')
% corrcoef(g0XAB)
% display('Gaze 0 Y correlation')
% corrcoef(g0YAB)
% 
% display(' ')
% display('Gaze 1 X correlation')
% corrcoef(g1XAB)
% display('Gaze 1 Y correlation')
% corrcoef(g1YAB)
% 
figure
title('Pupil-based fit')
% subplot(321)
 %pXAB(:,1)=atand((pXAB(:,1))./fulcrum_pupil_distance);
% [Fpxa Gpxa]=fit(pXAB(:,2),pXAB(:,1),'poly1');
% hist(pXAB(:,1)-feval(Fpxa,pXAB(:,2)),20)
% title('Pupil X-A fit error')
% Cpxa = 1000/Fpxa.p1;%conversion in degrees per mV
% display(['X-A fit ' num2str(Cpxa) ' mV/°. R-square = ' num2str(Gpxa.rsquare) '. Mean residual = ' num2str(sum(abs(pXAB(:,1)-feval(Fpxa,pXAB(:,2))))/length(pXAB))])
% 
% subplot(322)
% [Fpxb Gpxb]=fit(pXAB(:,3),pXAB(:,1),'poly1');
% hist(pXAB(:,1)-feval(Fpxb,pXAB(:,3)),20)
% title('Pupil X-B fit error')
% Cpxb = 1000/Fpxb.p1;
% display(['X-B fit ' num2str(Cpxb) ' mV/°. R-square = ' num2str(Gpxb.rsquare) '. Mean residual = ' num2str(sum(abs(pXAB(:,1)-feval(Fpxb,pXAB(:,3))))/length(pXAB))])
% 
% subplot(323)
 %pYAB(:,1)=atand((pYAB(:,1))./fulcrum_pupil_distance);
% [Fpya Gpya]=fit(pYAB(:,2),pYAB(:,1),'poly1');
% hist(pYAB(:,1)-feval(Fpya,pYAB(:,2)),20)
% title('Pupil Y-A fit error')
% Cpya = 1000/Fpya.p1;
% display(['Y-A fit ' num2str(Cpya) ' mV/°. R-square = ' num2str(Gpya.rsquare) '. Mean residual = ' num2str(sum(abs(pYAB(:,1)-feval(Fpya,pYAB(:,2))))/length(pYAB))])
% 
% subplot(324)
% [Fpyb Gpyb]=fit(pYAB(:,3),pYAB(:,1),'poly1');
% hist(pYAB(:,1)-feval(Fpyb,pYAB(:,3)),20)
% title('Pupil Y-B fit error')
% Cpyb= 1000/Fpyb.p1;
% display(['Y-B fit ' num2str(Cpyb) ' mV/°. R-square = ' num2str(Gpyb.rsquare) '. Mean residual = ' num2str(sum(abs(pYAB(:,1)-feval(Fpyb,pYAB(:,3))))/length(pYAB))])

subplot(211)
[Fpxab Gpxab]=fit(pXAB(:,2:3),pXAB(:,1),'poly11','Weight',abs(pXAB(:,1)));
hist(pXAB(:,1)-feval(Fpxab,pXAB(:,2:3)),20)
title('Pupil X-AB fit error')
display(['X-AB fit - A: ' num2str(1000/Fpxab.p10) ' mV/°. B: ' num2str(1000/Fpxab.p01) ' mV/°.  R-square = ' num2str(Gpxab.rsquare) '.']) 
display(['Mean residual = ' num2str(sum(abs(pXAB(:,1)-feval(Fpxab,pXAB(:,2:3))))/length(pXAB)) '. Residual st dev = ' num2str(std(pXAB(:,1)-feval(Fpxab,pXAB(:,2:3))))])


subplot(212)
[Fpyab Gpyab]=fit(pYAB(:,2:3),pYAB(:,1),'poly11','Weight',abs(pYAB(:,1)));
hist(pYAB(:,1)-feval(Fpyab,pYAB(:,2:3)),20)
title('Pupil Y-AB fit error')
display(['Y-AB fit - A: ' num2str(1000/Fpyab.p10) ' mV/°. B: ' num2str(1000/Fpyab.p01) ' mV/°.  R-square = ' num2str(Gpyab.rsquare) '.'])
display(['Mean residual = ' num2str(sum(abs(pYAB(:,1)-feval(Fpyab,pYAB(:,2:3))))/length(pYAB)) '. Residual st dev = ' num2str(std(pYAB(:,1)-feval(Fpyab,pYAB(:,2:3))))])

figure
subplot(211)
%plot(Te./1000,atand((X-mX)/fulcrum_pupil_distance))
plot(Te./1000,X)
hold on
plot(Tm./1000,feval(Fpxab,[smooth(A,50) smooth(B,50)]),'k')
% plot(Tm./1000,feval(Fpxab,[smooth(A,50)-median(A) smooth(B,50)-median(B)]),'k')
subplot(212)
%plot(Te./1000,atand((Y-mY)/fulcrum_pupil_distance))
plot(Te./1000,Y)
hold on
plot(Tm./1000,feval(Fpyab,[smooth(A,50)-median(A) smooth(B,50)-median(B)]),'k')
%plot(Tm,feval(Fpxa,[A']),'g')
%plot(Tm,feval(Fpxb,[ B']),'c')

figure
subplot(211)
title('X vs pX')
scatter(pXAB(:,1),feval(Fpxab,pXAB(:,2:3)))
a=axis;
hold on
plot(a(1):a(2),a(1):a(2))
xlabel('X')
ylabel('pX')

subplot(212)
title('Y vs pY')
scatter(pYAB(:,1),feval(Fpyab,pYAB(:,2:3)))
a=axis;
hold on
plot(a(1):a(2),a(1):a(2))
xlabel('Y')
ylabel('pY')


if right
    mdata=mL;
    A=mdata(2,:);
    B=mdata(3,:);
end

% g0XAB(:,1)=g0XAB(:,1)-median(g0X);
% g0XAB(:,2)=g0XAB(:,2)-median(A);
% 
% [Fg0xa Gg0xa]=fit(g0XAB(:,1),g0XAB(:,2),'poly1');
% [Fg1xa Gg1xa]=fit(g1XAB(:,1),g1XAB(:,2),'poly1');
% 
% [Fg0xb Gg0xb]=fit(g0XAB(:,1),g0XAB(:,3),'poly1');
% [Fg1xb Gg1xb]=fit(g1XAB(:,1),g1XAB(:,3),'poly1');
% 
% [Fg0ya Gg0ya]=fit(g0YAB(:,1),g0YAB(:,2),'poly1');
% [Fg1ya Gg1ya]=fit(g1YAB(:,1),g1YAB(:,2),'poly1');
% 
% [Fg0yb Gg0yb]=fit(g0YAB(:,1),g0YAB(:,3),'poly1');
% [Fg1yb Gg1yb]=fit(g1YAB(:,1),g1YAB(:,3),'poly1');
% 
% display(' ')
% figure
% title('Glint-Pupil based fit')
% subplot(221)
% Cgxa = (Fg0xa.p2-Fg1xa.p2)/glint_angle*1000;%fit in mV per degree
% display(['Glint X-A fit ' num2str(Cgxa) ' mV/°. R-square = ' num2str(Gg0xa.rsquare) ' and ' num2str(Gg1xa.rsquare)])
% hist(pXAB(:,1)-(1000.*pXAB(:,2)/Cgxa))
%  subplot(222)
% scatter(pXAB(:,1),(1000.*pXAB(:,2)/Cgxa))



