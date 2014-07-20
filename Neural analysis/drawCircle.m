function drawCircle(center,radius,color,style,width)
%draws a circle based on the inputs


rectangle('Position',[center-(radius.*ones(1,2)) 2*radius 2*radius],'Curvature',[1 1],'EdgeColor',color,'LineStyle',style,'LineWidth',width)
