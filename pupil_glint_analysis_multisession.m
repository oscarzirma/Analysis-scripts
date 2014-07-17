%this script will load each file in a directory and use the Eye matrix as
%eye coordinates. The first row is time, the second and third are raw pupil
%center, forth and fifth are raw pupil - glint0, sixth and seventh are raw
%pupil - glint 1. it will produce correlation matrices for each of these
%sets


num_files = 5;
vertical = true;

conversion = 15; %conversion in pixels per mm

pXAB=cell(num_files,1);pXABo=[];
pYAB=cell(num_files,1);pYABo=[];
g0XAB=cell(num_files,1);g0XABo=[];
g0YAB=cell(num_files,1);g0YABo=[];
g1XAB=cell(num_files,1);g1XABo=[];
g1YAB=cell(num_files,1);g1YABo=[];


for k=1:num_files load(['c55_d0131_left_' num2str(k) '.mat']);
    
    Te=rightEye(1,:);
    if vertical
        X=rightEye(3,:);
        Y=rightEye(2,:);
    end
    X=rightEye(2,:);
    Y=rightEye(3,:);
    
    Tm=mdata(1,:);
    A=mdata(2,:);
    B=mdata(3,:);
    C=mdata2(2,:);
    D=mdata2(3,:);
    
    eye_mag_calibration_2chan;
    
    pXAB(k)={[atand((vXAB(:,1)-median(vXAB(:,1)))./conversion./7) vXAB(:,2:3)]};
    pYAB(k)={[atand((vYAB(:,1)-median(vYAB(:,1)))./conversion./7) vYAB(:,2:3)]};
    
    pXABo=[pXABo; [atand((vXAB(:,1)-median(vXAB(:,1)))./conversion./7) vXAB(:,2:3)]];
    pYABo=[pYABo; [atand((vYAB(:,1)-median(vYAB(:,1)))./conversion./7) vYAB(:,2:3)]];
    
    
    if vertical
        X=rightEye(5,:);
        Y=rightEye(4,:);
    end
    X=rightEye(4,:);
    Y=rightEye(5,:);
    
    eye_mag_calibration_2chan;
    
    g0XAB(k)={vXAB};
    g0YAB(k)={vYAB};
    
    g0XABo=[g0XABo; vXAB];
    g0YABo=[g0YABo; vYAB];
    
    if vertical
        X=rightEye(7,:);
        Y=rightEye(6,:);
    end
    X=rightEye(6,:);
    Y=rightEye(7,:);
    
    eye_mag_calibration_2chan;
    
    g1XAB(k)={vXAB};
    g1YAB(k)={vYAB};
    
    g1XABo=[g1XABo; vXAB];
    g1YABo=[g1YABo ;vYAB];
end
figure;subplot(211)
display('pupil X vs A and B')
p=polyfitn(pXABo(:,2:3),pXABo(:,1),1)
scatter(pXABo(:,1),polyvaln(p,pXABo(:,2:3)));
a=axis;
hold on
plot(a(1):a(2),a(1):a(2))
title('pX vs X - pupil')
subplot(212)
display('pupil Y vs A and B')
p=polyfitn(pYABo(:,2:3),pYABo(:,1),1)
scatter(pYABo(:,1),polyvaln(p,pYABo(:,2:3)));
a=axis;
hold on
plot(a(1):a(2),a(1):a(2))
title('pY vs Y - pupil')

p0x=polyfitn(