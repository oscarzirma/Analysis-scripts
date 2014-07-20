function M = generateEyeHeadVid_movie(EOG,headPosition,mov)
%given an EOG cell, a headPosition cell, and a movie from a single trial, will generate a
%figure with all three time matched.

duration = (size(mov,4)-3)/30; %duration in seconds

e=cell2mat(EOG);
te=e(1,:)./1000;%get eog time vector and convert from ms to s
el=e(2,:);
er=e(3,:);

f=find(te>duration);%find eog index at t=duration
n=f(1);

[t X Y Z] = getHeadPosfromCells(headPosition,0,duration,.008);

el_color = [0 0 1.0000];
er_color = [1 0 0.5];

x_color = [1 .75 0];
y_color = [1 0 0 ];
z_color = [0 .5 0];

h=figure('Position',[1 1 1200 1000]);

j=1;%head position index
k=1;%video index
m=1;%movie index

subplot(3,3,[1 2 4 5])
imshow(mov(:,:,:,k))

for i=1:n
    subplot(3 ,3 ,3)%EOG left
    plot(te(1:i),el(1:i),'Color',[0 0 1]);
    axis([0 .8 -1.3 -1.1])
    title('Left EOG')
    
    subplot(3,3,6)%EOG right
    plot(te(1:i),er(1:i),'Color',[1 0 .6]);
    axis([0 .8 -1.5 -1.4])
    title('Right EOG')
    
    if j<=length(t)&&te(i)>=t(j)%if the timepoint has a head position update, plot it
        subplot(3,3,7)%X
        plot(t(1:j),X(1:j),'LineWidth',2,'Color',[1 .75 0])
        axis([0 .8 0 .05])
        title('Head: left to right')
        
        subplot(3,3,8)%Z
        plot(t(1:j),Z(1:j),'LineWidth',2,'Color',[0 .5 0])
        axis([0 .8 -.48 -.43])
        title('Head: up to down')
        
        subplot(3,3,9)%Y
        plot(t(1:j),Y(1:j),'LineWidth',2,'Color',[1 0 0])
        axis([0 .8 0.025 .05])
        title('Head: front to back')
        
        j=j+1;
    end
    
    if (te(i)/(1/30))>k-3 %-3 is to account for camera lag of ~100 ms
        k=k+1;
        subplot(3,3,[1 2 4 5])
        if k<=size(mov,4)
        imshow(mov(:,:,:,k))
        pause(.001)
        M(m)=getframe(gcf);
        m=m+1;
        end
    end
end