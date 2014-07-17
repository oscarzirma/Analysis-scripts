function events = find_head_eye_events_bars(EOG,headPosition)
%detects events given eye and head position cell arrays. events are
%detected using user-defined threshold of the absolute value of the
%derivative
%bars uses events with duration, rather than instantaneous events

n=length(EOG);

[T X Y Z Yaw Rol Pit Tm Xm Ym Zm Yawm Rolm Pitm]=getHeadPos(headPosition);%get head position data

% elThresh = .002;
% erThresh = .002;
% xThresh = .002;
% yThresh = .002;
% zThresh = 002;
% pThresh = .077;
h=figure;


for i=1:20:n %get thresholds
    %acquire data from cell arrays
    e=cell2mat(EOG(i));
    if ~isempty(e)&&length(e)>2000
        te=e(1,:);
        ted=te(1:end-1);
        %el=filter(ones(1,20)/20,1,e(2,:));
        el=running_average(e(2,:),20);
        eld=abs(diff(el));
        %er=filter(ones(1,20)/20,1,e(3,:));
        er=running_average(e(3,:),20);
        erd=abs(diff(er));
    end
    
    t=cell2mat(T(i));
    x=cell2mat(X(i));
    y=cell2mat(Y(i));
    z=cell2mat(Z(i));
    
    td=t(1:end-1);
    xd=abs(diff(x));
    yd=abs(diff(y));
    zd=abs(diff(z));
    
    figure(h)
    
    subplot(251)%left eye
    hold on
    plot(te,el)
    subplot(256);hold on
    plot(ted(100:end),eld(100:end))
    
    subplot(252);hold on
    plot(te,er)
    subplot(257);hold on
    plot(ted(100:end),erd(100:end))
   
    
    
    subplot(253);hold on
    plot(t,x)
    subplot(258);hold on
    plot(td,xd)
   
    
    subplot(254);hold on
    plot(t,y)
    subplot(259);hold on
    plot(td,yd)
   
    
    subplot(255);hold on
    plot(t,z)
    subplot(2, 5, 10);hold on
    plot(td,zd)
    
    
end

subplot(256)

title('Choose threshold for events')
elThresh = input('Left eye threshold:');

subplot(257)
title('Choose threshold for events')
erThresh = input('Right eye threshold:');


subplot(258)
title('Choose threshold for events')
[xThresh] = input('X threshold:');

subplot(259)
title('Choose threshold for events')
[yThresh] =input('Y threshold:');
subplot(254)
title('Choose threshold for pecks')
[pThresh] = input('Peck threshold:');

subplot(2 ,5, 10)
title('Choose threshold for events')
[zThresh] = input('Z threshold:');

close gcf

for i=1:n
    %acquire data from cell arrays
    e=cell2mat(EOG(i));
    if ~isempty(e)&&length(e)>2000
        te=e(1,:);
        ted=te(1:end-1);
        %el=filter(ones(1,20)/20,1,e(2,:));
        el=running_average(e(2,:),20);
        eld=abs(diff(el));
        %er=filter(ones(1,20)/20,1,e(3,:));
        er=running_average(e(3,:),20);
        erd=abs(diff(er));
    end
    
    t=cell2mat(T(i));
    x=cell2mat(X(i));
    y=cell2mat(Y(i));
    z=cell2mat(Z(i));
    
    td=t(1:end-1);
    xd=abs(diff(x));
    yd=abs(diff(y));
    zd=abs(diff(z));
    
    
    %     if i==1 %on the first iteration, set thresholds
    %
    %         subplot(211)%left eye
    %         plot(te,el)
    %         subplot(212)
    %         plot(ted(100:end),eld(100:end))
    %         title('Choose threshold for events')
    %         [a elThresh] = ginput(1);
    %
    %         subplot(211)
    %         plot(te,er)
    %         subplot(212)
    %         plot(ted(100:end),erd(100:end))
    %         title('Choose threshold for events')
    %         [a erThresh] = ginput(1);
    %
    %
    %         subplot(211)
    %         plot(t,x)
    %         subplot(212)
    %         plot(td,xd)
    %         title('Choose threshold for events')
    %         [a xThresh] = ginput(1);
    %
    %         subplot(211)
    %         plot(t,y)
    %         subplot(212)
    %         plot(td,yd)
    %         title('Choose threshold for events')
    %         [a yThresh] = ginput(1);
    %         subplot(211)
    %         title('Choose threshold for pecks')
    %         [a pThresh] = ginput(1);
    %
    %         subplot(211)
    %         plot(t,z)
    %         subplot(212)
    %         plot(td,zd)
    %         title('Choose threshold for events')
    %         [a zThresh] = ginput(1);
    %
    %         close(h)
    %     end
    
    %find events based on thresholds
    
    tedd=ted(1:end-1);
    
    f=eld>=elThresh;
    events(i).eye_left=ted(f)./1000;
    
    f=erd>erThresh;
    events(i).eye_right=ted(f)./1000;
    
    tdd=td(1:end-2);
    
    f=xd>xThresh;
    events(i).x=td(f);
    
    f=yd>yThresh;
    events(i).y=td(f);
    
    f=y>pThresh;
    events(i).peck=td(diff(f)>0);
    
    f=zd>yThresh;
    events(i).z=td(f);
    
end