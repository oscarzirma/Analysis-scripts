function [uX uY uZ] = uStimTraj_ang(headPosition,microstim_index,MAG,filename)
%This program will determine and plot the head trajectory of each trial,
%color coding by microstim or not. It will return three matrixes, which
%will have the position before microstim in the first column and after in
%the second. The third column contains the second minus the first.
%The user will input the baseline and stimmed timepoints. The
%values will be averaged over three time steps. file_name is the name of
%the figure files. Use 'no_save' to turn off saving.
%ang version uses angles instead of linear positions

if strcmp(filename,'no_save')
    save=false;
else
    save=true;
end

[t tmp1 tmp2 tmp3 Ydist Zdist Xdist] = getHeadPosfromCells_ang(headPosition,0,.5,.008);%Xdist is yaw, Ydist is roll, Zdist is pitch
n=size(Xdist,1); M=zeros(n,5e4);
for i=1:length(MAG)%get microstim traces
    x=cell2mat(MAG(i));
    l=length(x);
    if ~isempty(x) M(i,:)=x(2,1:5e4); end
end

%find microstim amplitude
j=jet;
ms_amp=max(M')-min(M');ms_amp_max=max(ms_amp);if ms_amp_max==0 ms_amp_max = 1;end%case when there is no MAG data
ms_amp_scaled = 1+round((ms_amp./ms_amp_max).*63);



m=microstim_index(1:n)==1;%find microstim trials

subplot(3,1,1)
plot(t,Xdist(m,:)')
%axis([.3 .5 -40 40])
subplot(312)
plot(t,Ydist(m,:)')
%axis([.3 .5 0 70])
subplot(313)
plot(t,Zdist(m,:)')
%axis([.3 .5 -480 -440])
title('Click the baseline time')
[bx y] = ginput(1); [y bx]=min(abs(t-bx));
title('Click the microstimmed time')
[mx y] = ginput(1); [y mx]=min(abs(t-mx));
close(gcf)

%find baseline and stimmed positions in each dimension
uX(:,1) = nanmean(Xdist(:,bx-1:bx+1),2);
uX(:,2) = nanmean(Xdist(:,mx-1:mx+1),2);
uX(:,3) = uX(:,2)-uX(:,1);

uY(:,1) = nanmean(Ydist(:,bx-1:bx+1),2);
uY(:,2) = nanmean(Ydist(:,mx-1:mx+1),2);
uY(:,3) = uY(:,2)-uY(:,1);


uZ(:,1) = nanmean(Zdist(:,bx-1:bx+1),2);
uZ(:,2) = nanmean(Zdist(:,mx-1:mx+1),2);
uZ(:,3) = uZ(:,2)-uZ(:,1);


m=microstim_index(1:n)==1;%find microstim trials

h=figure;

%plot baseline and stimmed points
subplot(2,2,[1 3])
scatter3(uX(:,1),uY(:,1),uZ(:,1),'k')
hold on
scatter3(uX(~m,2),uY(~m,2),uZ(~m,2),'b')
scatter3(uX(m,2),uY(m,2),uZ(m,2),'r')
%axis([-100 100 0 100 -520 -320])
xlabel('Yaw');ylabel('Roll');zlabel('Pitch');
colorbar('YTickLabel',round(max(ms_amp).*10^5.*((10:10:60)./64)))


subplot(2,2,2)
scatter(uX(:,1),uY(:,1),'k');hold on;scatter(uX(~m,2),uY(~m,2),'b');scatter(uX(m,2),uY(m,2),'r');xlabel('Yaw');ylabel('Roll');axis equal
subplot(2,2,4)
scatter(uX(:,1),uZ(:,1),'k');hold on;scatter(uX(~m,2),uZ(~m,2),'b');scatter(uX(m,2),uZ(m,2),'r');xlabel('Yaw');ylabel('Pitch');axis equal


for i=1:n%plot lines connecting baseline and stimmed points from the same trial
    subplot(2,2,[1 3])
    line([uX(i,1) uX(i,2)],[uY(i,1) uY(i,2)],[uZ(i,1) uZ(i,2)],'Color',j(ms_amp_scaled(i),:))
    subplot(2,2,2); line([uX(i,1) uX(i,2)],[uY(i,1) uY(i,2)],'Color',j(ms_amp_scaled(i),:))
    subplot(2,2,4); line([uX(i,1) uX(i,2)],[uZ(i,1) uZ(i,2)],'Color',j(ms_amp_scaled(i),:))
    
    
    
    %     start=[uX(i,1) uZ(i,1)]
    %     stop=[uX(i,2) uZ(i,2)]
    
    %     na=sum(isnan([start stop]));
    %
    %     if na==0
    %         if microstim_index(i) == 1
    %             arrow(start,stop,'FaceColor','r','EdgeColor','r','Length',10)
    %         else
    %             arrow(start,stop,'FaceColor','b','EdgeColor','b','Length',10)
    %         end
    %     end
    %     pause
    
    
end
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
if save
    saveas(gcf,[filename ' fig1.fig'])
    saveas(gcf,[filename ' fig1.eps'],'epsc');
end


pause
close(gcf)


subplot(2,2,[1 3])
xlabel('Yaw');ylabel('Roll');zlabel('Pitch');
colorbar('YTickLabel',round(max(ms_amp).*10^5.*((10:10:60)./64)))
view(3);
subplot(2,2,2);xlabel('Yaw');ylabel('Roll');axis equal
subplot(2,2,4);xlabel('Yaw');ylabel('Pitch');axis equal


for i=1:n%plot trajectory w/ color indicating stim strength
    subplot(2,2,[1 3])
    line([0 uX(i,3)],[0 uY(i,3)],[0 uZ(i,3)],'Color',j(ms_amp_scaled(i),:));
    
    subplot(2,2,2)
    line([0 uX(i,3)],[0 uY(i,3)],'Color',j(ms_amp_scaled(i),:));
    
    subplot(2,2,4)
    line([0 uX(i,3)],[0 uZ(i,3)],'Color',j(ms_amp_scaled(i),:));
    
    
    %     if(m(i))
    %         line([0 uX(i,3)],[0 uY(i,3)],[0 uZ(i,3)],'Color','r');
    %     else
    %         line([0 uX(i,3)],[0 uY(i,3)],[0 uZ(i,3)],'Color','b');
    %     end
end

set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
if save
    saveas(gcf,[filename ' fig2.fig'])
    saveas(gcf,[filename ' fig2.eps'],'epsc')
end
pause
close(gcf)

subplot(2,2,[1 3])
line([0 nanmean( uX(m,3))],[0 nanmean( uY(m,3))],[0 nanmean( uZ(m,3))],'Color','r')
line([0 nanmean( uX(~m,3))],[0 nanmean( uY(~m,3))],[0 nanmean( uZ(~m,3))],'Color','b')
xlabel('Yaw');ylabel('Roll');zlabel('Pitch');
view(3)

subplot(2,2,2)
line([0 nanmean( uX(m,3))],[0 nanmean( uY(m,3))],'Color','r','LineWidth',3)
line([0 nanmean( uX(m,3))+nanstd( uX(m,3))],[0 nanmean( uY(m,3))+nanstd( uY(m,3))],'Color','r')
line([0 nanmean( uX(m,3))-nanstd( uX(m,3))],[0 nanmean( uY(m,3))-nanstd( uY(m,3))],'Color','r')
line([0 nanmean( uX(~m,3))],[0 nanmean( uY(~m,3))],'Color','b','LineWidth',3)
line([0 nanmean( uX(~m,3))+nanstd( uX(~m,3))],[0 nanmean( uY(~m,3))+nanstd( uY(~m,3))],'Color','b')
line([0 nanmean( uX(~m,3))-nanstd( uX(~m,3))],[0 nanmean( uY(~m,3))-nanstd( uY(~m,3))],'Color','b')
xlabel('Yaw');ylabel('Roll');axis equal

subplot(2,2,4)
line([0 nanmean( uX(m,3))],[0 nanmean( uZ(m,3))],'Color','r','LineWidth',3)
line([0 nanmean( uX(m,3))+nanstd( uX(m,3))],[0 nanmean( uZ(m,3))+nanstd( uZ(m,3))],'Color','r')
line([0 nanmean( uX(m,3))-nanstd( uX(m,3))],[0 nanmean( uZ(m,3))-nanstd( uZ(m,3))],'Color','r')
line([0 nanmean( uX(~m,3))],[0 nanmean( uZ(~m,3))],'Color','b','LineWidth',3)
line([0 nanmean( uX(~m,3))+nanstd( uX(~m,3))],[0 nanmean( uZ(~m,3))+nanstd( uZ(~m,3))],'Color','b')
line([0 nanmean( uX(~m,3))-nanstd( uX(~m,3))],[0 nanmean( uZ(~m,3))-nanstd( uZ(~m,3))],'Color','b')
xlabel('Yaw');ylabel('Pitch');axis equal

set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
if save
    saveas(gcf,[filename ' fig3.fig'])
    saveas(gcf,[filename ' fig3.eps'],'epsc')
end
pause
close(gcf)
%microstim shift as a function of initial position
subplot(131)
scatter(uX(:,1),uX(:,3),3.*ms_amp_scaled,ms_amp_scaled);xlabel('baseline yaw');ylabel('microstim shift yaw');

subplot(132)
scatter(uY(:,1),uY(:,3),3.*ms_amp_scaled,ms_amp_scaled);xlabel('baseline roll');ylabel('microstim shift roll');

subplot(133)
scatter(uZ(:,1),uZ(:,3),3.*ms_amp_scaled,ms_amp_scaled);xlabel('baseline pitch');ylabel('microstim shift pitch');

colorbar('YTickLabel',round(max(ms_amp).*10^5.*((10:10:60)./64)))

set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
if save
    saveas(gcf,[filename ' fig4.fig'])
    saveas(gcf,[filename ' fig4.eps'],'epsc')
end
pause;close(gcf)

%microstim shift vector amplitude as a function of microstimulation amplitude

scatter(ms_amp.*10^5,sqrt(uX(:,3).^2 + uY(:,3).^2 + uZ(:,3).^2),100)
xlabel('microstim current (uA)');ylabel('head vector amplitude (°)')
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
if save
    saveas(gcf,[filename ' fig5.fig'])
    saveas(gcf,[filename ' fig5.eps'],'epsc')
end
pause;close(gcf)


