function [t Xdist Ydist Sdist] = getGazePosfromCells(gazePosition,start_time,end_time,time_step)
%given the inputs, it will return a matrix for X,Y,and Z positions. padded
%with NaNs

t=(start_time:time_step:end_time);

[T X Y S Tm Xm Ym Sm]=getGazePos(gazePosition);

for i=1:length(t) 
    [Xdist(:,i) Ydist(:,i) Sdist(:,i)]=head_pos_distribution_timepoint_cell(T,X,Y,S,t(i),time_step);
end