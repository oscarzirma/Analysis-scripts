function [A D]=BehaviorInterpreterBatch1(LoadFileA,LoadFileD,cutoffAng,cutoffDis)
%Will iterate through the folders in the current directory loading LoadFile
%variable, which should be an array. It will then go through that array and
%determine if the fish got to the cutoff value over the course of the
%array. it will return an array with the proportion of successful trials.

file=dir('**09**');
A=zeros(length(file),1);
D=A;
file.name
for(i=1:length(file))
    P=pwd;
    R=[P '/' file(i).name];
    fprintf(file(i).name)
    n=file(i).name;
    cd(R)
    l=load(LoadFileA);
    w=l.RelAng;
    x=abs(w);
    y=min(x,[],2);
    z=y<cutoffAng;
    A(i)=mean(z);
    
    l=load(LoadFileD);
    w=l.RelDis;
    y=min(w,[],2);
    z=y<cutoffDis;
    D(i)=mean(z);
    
    
    cd ..
end

return