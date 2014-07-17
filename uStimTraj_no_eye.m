function [uX uY uZ ms_amp] = uStimTraj_no_eye(headPosition,microstim_index,STI,filename)
%This program will determine and plot the head trajectory of each trial,
%color coding by microstim or not. It will return three matrixes, which
%will have the position before microstim in the first column and after in
%the second. The third column contains the second minus the first.
%The user will input the baseline and stimmed timepoints. The
%values will be averaged over three time steps. file_name is the name of
%the figure files. Use 'no_save' to turn off saving.
%v2 integrates magnetic eye position in EYE

if strcmp(filename,'no_save')
    savev=false;
else
    savev=true;
end

[t Xdist Ydist Zdist] = getHeadPosfromCells(headPosition,0,3,.008);
Xdist=-1000.*Xdist;%flip XDist so left and right are properly represented
Ydist=1000.*Ydist;Zdist=1000.*Zdist;%convert to mm
n=size(Xdist,1); %M=zeros(n,2.4e4);E=M;
for i=1:length(STI)%get microstim and eye traces
    x=cell2mat(STI(i));
    if ~isempty(x) M(i,:)=x(2,:);end
end
te=x(1,:);

%find microstim amplitude
j=jet;
ms_amp=get_ustim_amp(M);ms_amp_max=max(ms_amp);if ms_amp_max==0 ms_amp_max = 1;end%case when there is no MAG data
ms_amp_scaled = 1+round((ms_amp./ms_amp_max).*63);

plot(ms_amp);pause

m=microstim_index(1:n)==1;%find microstim trials


subplot(4,1,1)
plot(t,Xdist(m,:)')
%axis([0 .4 -60 60])
subplot(412)
plot(t,Ydist(m,:)')
%axis([0 .4 -60 70])
subplot(413)
plot(t,Zdist(m,:)')
%axis([0 .4 -480 -360])
subplot(414)
plot(te,M');
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
title('Click the baseline time')
[bx y] = ginput(1) 
[y bx]=min(abs(t-bx));
t(bx)
title('Click the microstimmed time')
[mx y] = ginput(1); [y mx]=min(abs(t-mx));
close(gcf)

%find baseline and stimmed positions in each dimension
uX(:,1) = nanmean(Xdist(:,bx-5:bx+5),2);
uX(:,2) = nanmean(Xdist(:,mx-5:mx+5),2);
uX(:,3) = uX(:,2)-uX(:,1);

uY(:,1) = nanmean(Ydist(:,bx-5:bx+5),2);
uY(:,2) = nanmean(Ydist(:,mx-5:mx+5),2);
uY(:,3) = uY(:,2)-uY(:,1);


uZ(:,1) = nanmean(Zdist(:,bx-5:bx+5),2);
uZ(:,2) = nanmean(Zdist(:,mx-5:mx+5),2);
uZ(:,3) = uZ(:,2)-uZ(:,1);


m=microstim_index(1:n)==1;%find microstim trials

h=figure;

%plot baseline and stimmed points
subplot(2,2,[1 3])
scatter3(uX(:,1),uY(:,1),uZ(:,1),'k')
hold on
scatter3(uX(~m,2),uY(~m,2),uZ(~m,2),'b')
scatter3(uX(m,2),uY(m,2),uZ(m,2),'r')
axis([-100 100 0 100 -520 -320])
xlabel('X');ylabel('Y');zlabel('Z');
colorbar('YTickLabel',round(max(ms_amp).*10^3.*((10:10:60)./64)))


subplot(2,2,2)
scatter(uX(:,1),uY(:,1),'k');hold on;scatter(uX(~m,2),uY(~m,2),'b');scatter(uX(m,2),uY(m,2),'r');xlabel('X');ylabel('Y');axis equal
subplot(2,2,4)
scatter(uX(:,1),uZ(:,1),'k');hold on;scatter(uX(~m,2),uZ(~m,2),'b');scatter(uX(m,2),uZ(m,2),'r');xlabel('X');ylabel('Z');axis equal


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
if savev
saveas(gcf,[filename ' fig1.fig'])
saveas(gcf,[filename ' fig1.eps'],'epsc');end


pause
close(gcf)


subplot(2,2,[1 3])
xlabel('X');ylabel('Y');zlabel('Z');
colorbar('YTickLabel',round(max(ms_amp).*10^3.*((10:10:60)./64)))
view(3);
subplot(2,2,2);xlabel('X');ylabel('Y');axis equal
subplot(2,2,4);xlabel('X');ylabel('Z');axis equal


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
if savev
saveas(gcf,[filename ' fig2.fig'])
saveas(gcf,[filename ' fig2.eps'],'epsc')
end
pause
close(gcf)

subplot(2,2,[1 3])
line([0 nanmean( uX(m,3))],[0 nanmean( uY(m,3))],[0 nanmean( uZ(m,3))],'Color','r')
line([0 nanmean( uX(~m,3))],[0 nanmean( uY(~m,3))],[0 nanmean( uZ(~m,3))],'Color','b')
xlabel('X');ylabel('Y');zlabel('Z');
view(3)

subplot(2,2,2)
line([0 nanmean( uX(m,3))],[0 nanmean( uY(m,3))],'Color','r','LineWidth',3)
line([0 nanmean( uX(m,3))+nanstd( uX(m,3))],[0 nanmean( uY(m,3))+nanstd( uY(m,3))],'Color','r')
line([0 nanmean( uX(m,3))-nanstd( uX(m,3))],[0 nanmean( uY(m,3))-nanstd( uY(m,3))],'Color','r')
line([0 nanmean( uX(~m,3))],[0 nanmean( uY(~m,3))],'Color','b','LineWidth',3)
line([0 nanmean( uX(~m,3))+nanstd( uX(~m,3))],[0 nanmean( uY(~m,3))+nanstd( uY(~m,3))],'Color','b')
line([0 nanmean( uX(~m,3))-nanstd( uX(~m,3))],[0 nanmean( uY(~m,3))-nanstd( uY(~m,3))],'Color','b')
xlabel('X');ylabel('Y');axis equal

subplot(2,2,4)
line([0 nanmean( uX(m,3))],[0 nanmean( uZ(m,3))],'Color','r','LineWidth',3)
line([0 nanmean( uX(m,3))+nanstd( uX(m,3))],[0 nanmean( uZ(m,3))+nanstd( uZ(m,3))],'Color','r')
line([0 nanmean( uX(m,3))-nanstd( uX(m,3))],[0 nanmean( uZ(m,3))-nanstd( uZ(m,3))],'Color','r')
line([0 nanmean( uX(~m,3))],[0 nanmean( uZ(~m,3))],'Color','b','LineWidth',3)
line([0 nanmean( uX(~m,3))+nanstd( uX(~m,3))],[0 nanmean( uZ(~m,3))+nanstd( uZ(~m,3))],'Color','b')
line([0 nanmean( uX(~m,3))-nanstd( uX(~m,3))],[0 nanmean( uZ(~m,3))-nanstd( uZ(~m,3))],'Color','b')
xlabel('X');ylabel('Z');axis equal

set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
if savev 
    saveas(gcf,[filename ' fig3.fig'])
saveas(gcf,[filename ' fig3.eps'],'epsc');end
pause
close(gcf)
%microstim shift as a function of initial position
subplot(131)
scatter(uX(:,1),uX(:,3),3.*ms_amp_scaled,ms_amp_scaled);xlabel('baseline X');ylabel('microstim shift X');

subplot(132)
scatter(uY(:,1),uY(:,3),3.*ms_amp_scaled,ms_amp_scaled);xlabel('baseline Y');ylabel('microstim shift Y');

subplot(133)
scatter(uZ(:,1),uZ(:,3),3.*ms_amp_scaled,ms_amp_scaled);xlabel('baseline Z');ylabel('microstim shift Z');

colorbar('YTickLabel',round(max(ms_amp).*10^3.*((10:10:60)./64)))

set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
if savev saveas(gcf,[filename ' fig4.fig'])
saveas(gcf,[filename ' fig4.eps'],'epsc');end
pause;close(gcf)

%microstim shift vector amplitude as a function of microstimulation amplitude

scatter(ms_amp.*10^3,sqrt(uX(:,3).^2 + uY(:,3).^2 + uZ(:,3).^2),100)
xlabel('microstim current (uA)');ylabel('head vector amplitude (mm)')
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
if savev
saveas(gcf,[filename ' fig5.fig'])
saveas(gcf,[filename ' fig5.eps'],'epsc');end
pause;close(gcf)


