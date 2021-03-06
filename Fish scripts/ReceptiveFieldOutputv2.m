function [M I]=ReceptiveFieldOutput(nm,rho,theta,cmap,n)
%takes in a neuromast response of the normal format [X Y Stim Micro Inter]
%and the radii and angle surveyed [min interval max] and displays the response 
%map in polar coordinates then a multi-pane plot with microphonic and
%interferometer response as well as the comparison of 0,0 values across
%runs. Outputs two matrices with responses (micro,interf) in polar coordinates. first
%column is radii labels, first row is angle labels. last column and row are
%averages.

Pnm=ReceptivePolarize(nm);
Pos=Pnm(:,1:2);
Pos=round(Pos.*100)./100;
Pos(1:3,:)=[];

%nm(3,:)=nm(1,:);
%nm(1:2,:)=[];

Micro=PolarMatrix(Pos,nm(:,4),rho,theta);
Interf=PolarMatrix(Pos,nm(:,5),rho,theta);
mMicro=Micro(1:3,:);
mInterf=Interf(1:3,:);

clf
bullseye(mMicro','rho',[rho(1) rho(3)],'tht0',-160);
colormap('jet')
colorbar
saveas(gcf,[n 'mmicrophonic'],'epsc');
plot2svg([n 'mmicrophonic.svg'],gcf);


%colormap('hot')
%colorbar
%saveas(gcf,'mmicrophonichot.tif');

clf
bullseye(Micro','rho',[rho(1) rho(3)],'tht0',-160);
colormap(cmap);
colorbar

saveas(gcf,[n 'microphonic'],'epsc');
plot2svg([n 'microphonic.svg'],gcf);


%colormap('hot')
%colorbar

%saveas(gcf,'microphonichot.tif');
%pause(2);

clf;
bullseye(mInterf','rho',[rho(1) rho(3)],'tht0',-160);
colormap('jet')
colorbar

saveas(gcf,[n 'minterferometer'],'epsc');
plot2svg([n 'minterferometer.svg'],gcf);
%pause(2);
clf
bullseye(Interf','rho',[rho(1) rho(3)],'tht0',-160);
colormap(cmap)
colorbar

saveas(gcf,[n 'interferometer'],'epsc');
plot2svg([n 'interferometer.svg'],gcf);
%pause(2);


[m n]=size(nm);
j=1;
for(i=1:m)
    if((nm(i,1)==0)&&(nm(i,2)==0))
        zerozero(j,:)=nm(i,4:5);
        j=j+1;
    end
end

h=plot(zerozero);
set(h,'LineWidth',3)
set(gca,'LineWidth',2,'FontSize',16);
%set(gca, 'Xlim', [1 length(zerozero)]) ;
axis([1 length(zerozero) 0 1.1*max(max(zerozero))]);
saveas(gcf,[n 'zerozero'],'epsc');
plot2svg([n 'zerozero.svg'],gcf);

M=Microspacev3(Pos,nm(:,4),rho,theta);
dlmwrite(['M' n],M,'\t')
clear Microspacev3
I=Microspacev3(Pos,nm(:,5),rho,theta);
dlmwrite(['I' n],I,'\t')
clear Microspacev3


return