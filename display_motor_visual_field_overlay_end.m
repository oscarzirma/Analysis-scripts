function display_motor_visual_field_overlay_end(headPosition,indices,baseline,ustim,visual_RF,color,yaw_switch)
%function will produce a scatter plot showing head trajectory in angular
%space from the baseline timepoint to the ustim timepoint. indices are the
%trials to include. visual RF is the visual receptive field location in in
%format of [azimuth,elevation].
%end version shows only the endpoint

[t Xdist Ydist Zdist YAdist Rdist Pdist] = getHeadPosfromCells_ang(headPosition(indices)',0,3,.008);
rectangle('Position',[visual_RF(1)-5 visual_RF(2)-5 10 10],'EdgeColor',color,'Curvature',[1 1]);
    hold on
    ys=yaw_switch;

for i=1:length(indices)

    scatter(ys*YAdist(i,ustim)-ys*YAdist(i,baseline),-Pdist(i,ustim)-(-Pdist(i,baseline)),100,'MarkerEdgeColor',color);
end

axis([-90 90 -90 90])