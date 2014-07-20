function displayHeadPos_get(headPosition)%,stimulus_position,stimuli_positions,fixCenterX,fixCenterY)
[T X Y Z Yaw Rol Pit Tm Xm Ym Zm Yawm Rolm Pitm]=getHeadPos(headPosition)
 l=size(T,2);

% for i = 1 : l
%     hp=cell2mat(headPosition(i,1));
%     t=hp(:,1)';%generate cell matrices for each dimension, removing any zeros
%     r=find(t~=0);
%     n=length(r);
%     T(i)={t(r)};
%     x=hp(:,2)';
%     X(i)={x(r)};
%     y=hp(:,3)';
%     Y(i)={y(r)};
%     z=hp(:,4)';
%     Z(i)={z(r)};
%     
%     yaw = hp(:,5);
%     Yaw(i) = {yaw(r)};
%     rol = hp(:,6);
%     Rol(i) = {rol(r)};
%     pit = hp(:,7);
%     Pit(i) = {pit(r)};
%     
%     n=length(t);%generate a matrix for each dimension
%     Tm(i,1:n)=t;
%     Xm(i,1:n)=x;
%     Ym(i,1:n)=y;
%     Zm(i,1:n)=z;
%     Yawm(i,1:n)=yaw;
%     Rolm(i,1:n)=rol;
%     Pitm(i,1:n)=pit;
% end

figure;
subplot(131);hold on;axis([-.1 4 -.07 .05]);
subplot(132);hold on;axis([-.1 4 0 .12]);
subplot(133);hold on;axis([-.1 4 -.6 -.2]);
% subplot(234);hold on;axis([-.1 4 -180 180]);
% subplot(235);hold on;axis([-.1 4 -100 100]);
% subplot(236);hold on;axis([-.1 4 -180 180]);


for i=1:l %plot each dimension
    subplot(131)
    title('X')
    plot(cell2mat(T(i)),cell2mat(X(i)));
    subplot(132)
    title('Y')
    plot(cell2mat(T(i)),cell2mat(Y(i)),'g');
    subplot(133)
    title('Z')
    plot(cell2mat(T(i)),cell2mat(Z(i)),'r');
%     subplot(234)
%     title('Yaw')
%     plot(cell2mat(T(i)),cell2mat(Yaw(i)),'k');
%     subplot(235)
%     title('Roll')
%     plot(cell2mat(T(i)),cell2mat(Rol(i)),'k');
%     subplot(236)
%     title('Pitch')
%     plot(cell2mat(T(i)),cell2mat(Pit(i)),'k');
end
    

% m=length(unique(stimuli_positions));
% 
%  k=size(Xm,2);
% % colors = (1/k:1/k:1);
% 
% for i=1:k %display mean and std deviation over time
%     a=Tm(:,i);
%     f=a~=0;
%     t(i)=mean(a(f));
%     meanx=mean(Xm(f,i));
%     stdx=std(Xm(f,i));
% end
% figure
% plot(t,meanx);
% hold on;
% plot(t,meanx+stdx,'r')
% plot(t,meanx-stdx,'r');
% for i = 1 : m %build a 3d plot for each stimulus position with fixation and target both indicated
%     figure;hold on
%     index = find(stimuli_positions == i);
%     index(index>l)=[];
%     [targX targY] = pixToPos(stimulus_position(index(1),1)+fixCenterX,fixCenterY-stimulus_position(index(1),2));%find target position in space from pixesl
%     [fixX fixY] = pixToPos(fixCenterX,fixCenterY);
%     
%     scatter3(targX,targY,.11,40,'ro') %put target up
%     scatter3(fixX,fixY,.11,40,'go') %put fix up
%    
%     for j=1:length(index)
%     scatter3(Xm(index(j),:),Zm(index(j),:),Ym(index(j),:),5,colors)
%     end
% %     axis([-.175 .144 -.63 -.39])
%     pause
%     close(gcf)
% end
% figure;hold on
% for i=1:l
%     scatter3(Xm(i,:),Zm(i,:),Ym(i,:),15,colors)
% end

% n=length(Tm);
% figure
% 
% for i = 1 : n %make a movie of all head positions at each point in time
%     r = Xm(:,i)~=0;
%     plot(Ym(:,i),'ko')
%     %axis([-.02 .06 .04 .12 -.53 -.46])
%        axis([0 200 .04 .12])
% 
%     set(gcf,'Name',num2str(mean(Tm(r,i))))
%     pause(.01)
% end
%     close(gcf);

   
   
   
   