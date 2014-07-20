function [M I]=ReceptiveFieldBatch()
%takes in a neuromast response of the normal format [X Y Stim Micro Inter]
%and the radii and angle surveyed [min interval max] and displays the response 
%map in polar coordinates then a multi-pane plot with microphonic and
%interferometer response as well as the comparison of 0,0 values across
%runs. Outputs two matrices with responses (micro,interf) in polar coordinates. first
%column is radii labels, first row is angle labels. last column and row are
%averages.

file=dir('**nm**');
rho=[2.4000    0.2000    8.0000];
theta=[-0.3491    0.0873    2.3562];

temp=[0 0 0;.08 .08 .08; .12 .12 .12; .16 .16 .16;.2 .2 .2;.25 .25 .25];
temp2=jet;
cmap=[temp;temp2];
clear temp temp2;

for(i=1:length(file))
    P=pwd;
    R=[P '/' file(i).name];
    fprintf(file(i).name)
    n=file(i).name;
    cd(R);
    namenm=dir('*.nm');
    namenm.name
    nm=load(namenm.name);
    [Mt It]=ReceptiveFieldOutputv2(nm,rho,theta,cmap,n);

    
    cd ..
end
save M
save I

return