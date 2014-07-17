function density_plot(X,Y)
dat=[X Y];

rx=-45:1:15;
ry=-45:1:15;
ii = .05;%interpolant interval
rxi=rx(1):ii:rx(end);
ryi=ry(1):ii:ry(end);

m=median(dat);
% datn=[dat(:,1)-m(1) dat(:,2)-m(2)];
datn=[dat(:,1) dat(:,2)];
display(['Median values: ' num2str(m)]);

 [n x]=hist3(datn,{rx ry});
%[n ,x]=hist3(datn,{[-25:15] [-25:15]});

xb=cell2mat(x(1));
yb=cell2mat(x(2));

nn=n./sum(sum(n));
%nn=nn.*360;

k=1;
for i=1:length(rx)
    for j=1:length(ry) 
        D(k,:)=[xb(i) yb(j)];
        V(k)=nn(j,i);
        k=k+1;
    end;
end

[xbi ,ybi]=meshgrid(rxi,ryi);

F=scatteredInterpolant(D,V');
zi=F(xbi,ybi);

figure
pcolor(rxi,ryi,zi)
shading interp

% 
% 
% figure
% pcolor(xb,yb,nn)
% shading interp
 set(gcf, 'Renderer', 'opengl')


