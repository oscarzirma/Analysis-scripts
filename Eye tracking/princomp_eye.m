function [V S]=princomp_eye(X,Y)
%given an X and a Y in mm, this function will convert to angular
%coordinates and output the dominant component as V (vergence) and the
%secondary component as S (orthogonal to vergence).

pupil_fulcrum_distance = 4.58;



aX=atand((X-median(X))./pupil_fulcrum_distance);
aY=atand((Y-median(Y))./pupil_fulcrum_distance);

[c s l t] = princomp([aX' aY']);
atand(c(2,1)/c(1,1))
atand(c(2,2)/c(1,2))
V = aX.*c(1,1) + aY.*c(2,1);
S = aX.*c(1,2) + aY.*c(2,2);

figure
scatter(aX,aY);
hold on
scatter(V,S)

display(['V contains ' num2str(100*l(1)./sum(l)) '% of the variance.'])
    display(['S contains ' num2str(100*l(2)./sum(l)) '% of the variance.'])