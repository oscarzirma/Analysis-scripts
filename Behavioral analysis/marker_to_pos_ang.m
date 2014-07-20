function [t X Y Z Yaw Rol Pit] = marker_to_pos_ang(headPosition)
%this script recreated the X,Y,and Z position from the marker positions. it
%also calculated the angular positions. it assumed that marker positions
%are continuous

for i=1:length(headPosition)
    markers=cell2mat(headPosition(i,2));
    [len dim mar]=size(markers);%len is length in time of marker array, dim is the number of dimensions (i.e.3), mar is the number of markers
    