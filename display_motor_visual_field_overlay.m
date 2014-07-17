function display_motor_visual_field_overlay(headPosition,indices,baseline,ustim,visual_RF,color,yaw_switch)
%function will produce a scatter plot showing head trajectory in angular
%space from the baseline timepoint to the ustim timepoint. indices are the
%trials to include. visual RF is the visual receptive field location in in
%format of [azimuth,elevation].

[t Xdist Ydist Zdist YAdist Rdist Pdist] = getHeadPosfromCells_ang(headPosition(indices)',0,3,.008);
rectangle('Position',[visual_RF(1)-5 visual_RF(2)-5 10 10],'EdgeColor',color,'Curvature',[1 1]);
    hold on
    ys=yaw_switch;

for i=1:length(indices)

    p=plot(ys.*YAdist(i,baseline:ustim)-repmat(ys.*YAdist(i,baseline),1,ustim-baseline+1),-Pdist(i,baseline:ustim)-repmat(-Pdist(i,baseline),1,ustim-baseline+1),'Color',color);
    %scatter(YAdist(i,baseline:ustim)-YAdist(i,baseline),Pdist(i,baseline:ustim)-Pdist(i,baseline),100);
end

axis([-90 90 -90 90])