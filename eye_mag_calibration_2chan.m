%this script will align and correlate eyelink traces with magnet traces. it
%will look for eye traces labeled X and Y with time Te and magnet traces
%labeled A and B with time Tm. It calls find_plateau_values and
%align_mag_eyelink.

[tA values start stop] = find_plateau_values(Tm,A);
tB=tA;
vA=mean_value_during_interval(Tm,A,start,stop);
vB=mean_value_during_interval(Tm,B,start,stop);
% [tB vB] = find_plateau_values(Tm,B);

[tC values startC stopC] = find_plateau_values(Tm,C);
tD=tC;
vC=mean_value_during_interval(Tm,C,startC,stopC);
vD=mean_value_during_interval(Tm,D,startC,stopC);


tX=tA;tY=tA;
[vX sX]=mean_value_during_interval(Te,X,start,stop);
[vY sY]=mean_value_during_interval(Te,Y,start,stop);

i=sX>3;
 vX(i)=nan;

i=~isnan(vX);
tX=tX(i);
tY=tY(i);
vX=vX(i);
vY=vY(i);
% [tX vX] = find_plateau_values_eyelink(Te,X);
% [tY vY] = find_plateau_values_eyelink(Te,Y);

% [tX vX] = find_matched_eyelink(Te,X,tA);
% [tY vY] = find_matched_eyelink(Te,Y,tA);

% h=figure;
% 
% plot(X);
% title('Indicate center of plateau periods. Enter when complete');
% [x ~] = ginput;
% x=round(x);
% tX = Te(x);
% for i=1:length(x)
%     vX(i) = mean(X(x(i)-10:x(i)+10));
% end
% 
% 
% plot(Y);
% title('Indicate center of plateau periods. Enter when complete');
% [y ~] = ginput;
% y=round(y);
% tY = Te(y);
% for i=1:length(y)
%     vY(i) = mean(Y(y(i)-10:y(i)+10));
% end

[tAB vAB] = align_mag_eyelink(tA,vA,tB,vB);

[tAX vAX] = align_mag_eyelink(tA,vA,tX,vX);
[tAY vAY] = align_mag_eyelink(tA,vA,tY,vY);

[tBX vBX] = align_mag_eyelink(tB,vB,tX,vX);
[tBY vBY] = align_mag_eyelink(tB,vB,tY,vY);

 [tCD vCD] = align_mag_eyelink(tC,vC,tD,vD);
% 
% [tCX vCX] = align_mag_eyelink(tC,vC,tX,vX);
% [tCY vCY] = align_mag_eyelink(tC,vC,tY,vY);
% 
% [tDX vDX] = align_mag_eyelink(tD,vD,tX,vX);
% [tDY vDY] = align_mag_eyelink(tD,vD,tY,vY);

[tXY vXY] = align_mag_eyelink(tX,vX,tY,vY);


% %2-D plots
% subplot(231)
% scatter(vAB(:,1),vAB(:,2))
% title('A vs B')
% axis equal
% 
% subplot(234)
% scatter(vXY(:,1),vXY(:,2));
% title('X vs Y')
% axis equal
% 
% subplot(232)
% scatter(vAX(:,1),vAX(:,2));
% title('A vs X')
% 
% subplot(233)
% scatter(vAY(:,1),vAY(:,2));
% title('A vs Y')
% 
% subplot(235)
% scatter(vBX(:,1),vBX(:,2));
% title('B vs X')
% 
% subplot(236)
% scatter(vBY(:,1),vBY(:,2));
% title('B vs Y')
% 
 [tmp1 tmp2 index] = align_mag_eyelink(tAB(:,1),vAB(:,1),tX,vX);
 tXAB = [tmp1(:,2) tmp1(:,1) tAB(index,2)]; 
 vXAB = [tmp2(:,2) tmp2(:,1) vAB(index,2)];
% 
 [tmp1 tmp2 index] = align_mag_eyelink(tAB(:,1),vAB(:,1),tY,vY);
 tYAB = [tmp1(:,2) tmp1(:,1) tAB(index,2)]; 
 vYAB = [tmp2(:,2) tmp2(:,1) vAB(index,2)];

 [tmp1 tmp2 index] = align_mag_eyelink(tXAB(:,1),vXAB(:,1),tY,vY);
 tXYAB = [tmp1(:,1) tmp1(:,2) tXAB(index,2:3)];
 vXYAB = [tmp2(:,1) tmp2(:,2) vXAB(index,2:3)];
 
 
 % 
% figure
% subplot(121)
% scatter3(vXAB(:,2),vXAB(:,3),vXAB(:,1))
% title('X vs A vs B')
% 
% subplot(122)
% scatter3(vYAB(:,2),vYAB(:,3),vYAB(:,1))
% title('Y vs A vs B')
% 
% 
% 


