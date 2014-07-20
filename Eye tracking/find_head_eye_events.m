function events = find_head_eye_events(EOG,headPosition)
%detects events given eye and head position cell arrays. events are
%detected using user-defined threshold of the absolute value of the
%derivative

n=length(EOG);

[T X Y Z Yaw Rol Pit Tm Xm Ym Zm Yawm Rolm Pitm]=getHeadPos(headPosition);%get head position data

for i=1:n
    %acquire data from cell arrays
    e=cell2mat(EOG(i));
    if ~isempty(e)
        te=e(1,:);
        ted=te(1:end-1);
        el=filter(ones(1,20)/20,1,e(2,:));
        eld=abs(diff(el));
        er=filter(ones(1,20)/20,1,e(3,:));
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
    
    
    if i==1 %on the first iteration, set thresholds
        h=figure;
        
        subplot(211)%left eye
        plot(te,el)
        subplot(212)
        plot(ted(100:end),eld(100:end))
        title('Choose threshold for events')
        [a elThresh] = ginput(1);
        
        subplot(211)
        plot(te,er)
        subplot(212)
        plot(ted(100:end),erd(100:end))
        title('Choose threshold for events')
        [a erThresh] = ginput(1);
        
        
        subplot(211)
        plot(t,x)
        subplot(212)
        plot(td,xd)
        title('Choose threshold for events')
        [a xThresh] = ginput(1);
        
        subplot(211)
        plot(t,y)
        subplot(212)
        plot(td,yd)
        title('Choose threshold for events')
        [a yThresh] = ginput(1);
        subplot(211)
        title('Choose threshold for pecks')
        [a pThresh] = ginput(1);
        
        subplot(211)
        plot(t,z)
        subplot(212)
        plot(td,zd)
        title('Choose threshold for events')
        [a zThresh] = ginput(1);
        
        close(h)
    end
    
    %find events based on thresholds
        
    tedd=ted(1:end-1);
    
    f=eld>=elThresh;
    events(i).eye_left=tedd(diff(f)>0)./1000;
    
    f=erd>erThresh;
    events(i).eye_right=tedd(diff(f)>0)./1000;
    
    tdd=td(1:end-2);

    f=xd>xThresh;
    events(i).x=td(diff(f)>0);
    
    f=yd>yThresh;
    events(i).y=td(diff(f)>0);
    
    f=y>pThresh;
    events(i).peck=td(diff(f)>0);
    
    f=zd>yThresh;
    events(i).z=td(diff(f)>0);
    
end