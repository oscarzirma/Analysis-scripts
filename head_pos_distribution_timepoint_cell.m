function [Xdist Ydist Zdist]=head_pos_distribution_timepoint_cell(T,X,Y,Z,time,time_step)
%Takes in a head position and time and returns the X, Y,and Z coordinates
%at that time
%cell version takes in X,Y,Z cell matrices

n=length(X);


Xdist=NaN(n,1);Ydist=NaN(n,1);Zdist=NaN(n,1);

for i=1:n
    t=cell2mat(T(i));
    if max(t)>=time
        j=1;
        while (j<length(t))&&(t(j)<=time)
            j=j+1;
        end
        if t(j) < (time + time_step)
            x=cell2mat(X(i));y=cell2mat(Y(i));z=cell2mat(Z(i));
            
            if j<=length(x)
                Xdist(i)=x(j);
            end
            if j<=length(y)
                Ydist(i)=y(j);
            end
            if j<=length(z)
                Zdist(i)=z(j);
            end
        end
    end
end

%size(Xdist)