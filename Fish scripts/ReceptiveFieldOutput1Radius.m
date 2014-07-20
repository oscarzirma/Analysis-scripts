function [M eM I eI zerozero]=ReceptiveFieldOutput1Radius(Angles,Reps,nmOutput)
%takes in the angles probed and the number of repititions as well as a
%standard neuromast output (first three lines, fish position, followed by
%two 0,0 positions) third column stimulus, fourth column repsonse, fifth
%column interferometer and outputs a matrix with different repititions in
%differont rows and angles in columns. Outputs a chart with different
%repititions as different lines. And a zerozero chart as well.

[m,n]=size(nmOutput);

j=1;z=1;

for(i=4:m)
    if((nmOutput(i,1)==0)&&(nmOutput(i,2)==0))
        zerozero(z,:)=nmOutput(i,:);
        z=z+1;
    else
        response(j,:)=nmOutput(i,:);
        j=j+1;
    end
end
a=length(Angles);
j=1;
for(i=1:Reps)
    res=response(j:j+a-1,4);
    int=response(j:j+a-1,5);
    j=j+a;
    if(mod(i,2)==0);
        res=res(end:-1:1);
        int=int(end:-1:1);
    end
    M(i,:)=res;
    I(i,:)=int;

end

eM=std(M)./sqrt(Reps);
eI=std(I)./sqrt(Reps);
M=mean(M);
I=mean(I);

plot(zerozero(:,4))
zmean=mean(zerozero(:,4));
zstd=std(zerozero(:,4));
if(zstd/zmean)>.5
    fprintf('(0,0) control points have high variability')
    pause()
end
