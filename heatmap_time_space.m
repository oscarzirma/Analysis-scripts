function heatmap_time_space(time,data,bins)
%this function will generate a heat map across time and space of the data
%matrix. Time is across columns and independent trials are in rows.

n=length(time);

H=zeros(length(bins),n);

rti=time;
rbi=bins(1):1*diff(bins(1:2)):bins(end);

k=1;

for i=1:n;
    h=hist(data(:,i),bins);
    hn=h./sum(h);
    H(:,i)=hn;
    for j=1:length(bins)
        D(k,:)=[time(i) bins(j)];
        V(k)=hn(j);
        k=k+1;
    end
end

F=scatteredInterpolant(D,V');
[xbi ,ybi] = meshgrid(rti,rbi);

zi=F(xbi,ybi);

figure
pcolor(rti,rbi,zi)
shading flat

%  figure
% pcolor(time,bins,H);
%  shading flat

 set(gcf, 'Renderer', 'opengl')
 colorbar