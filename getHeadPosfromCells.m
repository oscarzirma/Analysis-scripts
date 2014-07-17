function [t Xdist Ydist Zdist] = getHeadPosfromCells(headPosition,start_time,end_time,time_step)
%given the inputs, it will return a matrix for X,Y,and Z positions. padded
%with NaNs

t=(start_time:time_step:end_time);

[T X Y Z Yaw Rol Pit Tm Xm Ym Zm Yawm Rolm Pitm]=getHeadPos(headPosition);

for i=1:length(t) 
    [Xdist(:,i) Ydist(:,i) Zdist(:,i)]=head_pos_distribution_timepoint_cell(T,X,Y,Z,t(i),time_step);
end