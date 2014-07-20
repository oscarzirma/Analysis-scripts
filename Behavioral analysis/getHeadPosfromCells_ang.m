function [t Xdist Ydist Zdist YAdist Rdist Pdist] = getHeadPosfromCells_ang(headPosition,start_time,end_time,time_step)
%given the inputs, it will return a matrix for X,Y,and Z positions. padded
%with NaNs. ang version returns angular positions as well, reformted to be
%true yaw, roll, and pitch

t=(start_time:time_step:end_time);

[T X Y Z Yaw Rol Pit Tm Xm Ym Zm Yawm Rolm Pitm]=getHeadPos(headPosition);

for i=1:length(t) 
    [Xdist(:,i) Ydist(:,i) Zdist(:,i) YAdist(:,i) Rdist(:,i) Pdist(:,i)]=head_pos_distribution_timepoint_cell_ang(T,X,Y,Z,Yaw,Rol,Pit,t(i),time_step);
end