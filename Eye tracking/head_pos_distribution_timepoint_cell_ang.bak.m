function [Xdist Ydist Zdist YAdist Pdist Rdist]=head_pos_distribution_timepoint_cell_ang(T,X,Y,Z,YA,P,R,time,time_step)
%Takes in a head position and time and returns the X, Y,and Z coordinates
%at that time
%cell version takes in X,Y,Z cell matrices
%ang version takes and returns angles in addition to linear positions

n=length(X);


Xdist=NaN(n,1);Ydist=NaN(n,1);Zdist=NaN(n,1);YAdist=NaN(n,1);Rdist=NaN(n,1);Pdist=NaN(n,1);


for i=1:n
    t=cell2mat(T(i));
    if max(t)>=time
        j=1;
        while (j<length(t))&&(t(j)<=time)
            j=j+1;
        end
        if t(j) < (time + time_step)
            x=cell2mat(X(i));y=cell2mat(Y(i));z=cell2mat(Z(i));
            ya=cell2mat(YA(i));r=cell2mat(R(i));p=cell2mat(P(i));
            
            if j<=length(x)
                Xdist(i)=x(j);
            end
            if j<=length(y)
                Ydist(i)=y(j);
            end
            if j<=length(z)
                Zdist(i)=z(j);
            end
            if j<=length(ya)
                YAdist(i)=ya(j);
            end
            if j<=length(r)
                Rdist(i)=r(j);
            end
            if j<=length(p)
                Pdist(i)=p(j);
            end            
        end
    end
end

%size(Xdist)