%this script will extract data, using curscoords, from eMagData and
%headPosition(sridhar).

clear Ap Bp Cp Dp

prepad  = .3;%time before each peck to extract
postpad = .3;%time after each peck to extract

cCindex = cursCoords(:,11);%index to track which trial
peckTimes = cursCoords(:,8);%peck times

i=1;
j=1;
k=1;

x=cell2mat(eMagData(1,1));
tm=x(1,:)./1000;
tmend=tm(end);
d=time_match(tm,prepad+postpad);
tp=tm(1:d+1)-prepad;

dh=time_match(th,prepad+postpad);

while i<=length(headPosition)
    ML=cell2mat(eMagData(i,1));
    MR=cell2mat(eMagData(i,2));
    np=1;
    p0=peckTimes(j);
    %j=j+1;
    
    while cCindex(j)==-1
        p=peckTimes(j);
        if p>tmend
            while cCindex(j)==-1
                j=j+1;
            end
            break
        end
        np=np+1;
        i1=time_match(tm,p-prepad);
        i2=i1+d;
        
        i1h=time_match(th,p-prepad);
        i2h=i1h+dh;
        
        if ~isempty(i1)&&i1>=1&&i2<=length(tm)
            %         Ap(k,:) = smooth(ML(2,i1:i2),20);
            %         Bp(k,:) = smooth(ML(3,i1:i2),20);
            %         Cp(k,:) = smooth(MR(2,i1:i2),20);
            %         Dp(k,:) = smooth(MR(3,i1:i2),20);
            Ap(k,:) = (ML(2,i1:i2));
            Bp(k,:) = (ML(3,i1:i2));
            Cp(k,:) = (MR(2,i1:i2));
            Dp(k,:) = (MR(3,i1:i2));
            
            if i1h>1&i2h<=length(Xdist(i,:))
                Xp(k,:) = Xdist(i,i1h:i2h);
                Yp(k,:) = Ydist(i,i1h:i2h);
                Zp(k,:) = Zdist(i,i1h:i2h);
            end
            k=k+1;
            
            
        end
        
        
%         Xp(i,:)= hL(time_match(th,p-prepad):time_match(th,p+prepad),1);
        
        j=j+1;
    end
    numpecks(i)=np;
    j=j+1;
    i=i+1;
end
hist(numpecks)