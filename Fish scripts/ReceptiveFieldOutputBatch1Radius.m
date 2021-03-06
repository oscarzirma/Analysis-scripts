function ReceptiveFieldBatch1Radius()
%takes in a neuromast response of the normal format [X Y Stim Micro Inter]
%and the radii and angle surveyed [min interval max] and displays the response 
%map in polar coordinates then a multi-pane plot with microphonic and
%interferometer response as well as the comparison of 0,0 values across
%runs. Outputs two matrices with responses (micro,interf) in polar coordinates. first
%column is radii labels, first row is angle labels. last column and row are
%averages.

file=dir('**nm**');
angles=[135,130,125,120,115,110,105,100,95,90,85,80,75,70,65,60,55,50,45,40,35,30,25,20,15,10,5,0,-5,-10,-15,-20];

for(i=1:length(file))
    P=pwd;
    R=[P '/' file(i).name];
    fprintf(file(i).name);
    n=file(i).name;
    cd(R);
    namenm=dir('*.nm');
    namenm.name
    nm=load(namenm.name);
    [M(i,:) eM(i,:) I(i,:) eI(i,:) zz]=ReceptiveFieldOutput1radius(angles,5,nm);
    size(M)
    
    cd ..
end
x=[namenm.name];
dlmwrite(['M' ],M,'\t')
dlmwrite(['eM' ],eM,'\t')
dlmwrite(['I' ],I,'\t')
dlmwrite(['eI' ],eI,'\t')
dlmwrite(['zz' ],zz,'\t')

h=errorbar(M',eM');
set(h,'LineWidth',1.5)
set(gca,'LineWidth',2,'FontSize',12);

axis([1 33 0 1.1*max(max(M))]);
j=1;
for(i=1:3:32)
a(j)=angles(i);
j=j+1;
end
set(gca,'XTick',[1:3:32])
set(gca,'XTickLabel',a)
set(gcf,'Color','white')

saveas(gcf,['outputimage'],'epsc');
plot2svg(['outputimage.svg'],gcf);

figure;
plot(zz(:,4:5))
saveas(gcf,['zerozero'],'epsc');

return