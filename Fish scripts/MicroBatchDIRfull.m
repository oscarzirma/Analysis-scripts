function [Frequency,Amplitude]=MicrophonicBatchDIRfull(Range,Interval,Freq,Srate,coordinates,fishposition,display)
%Runs MicrophonicBatch on all directories starting XX-nm where XX are
%digits to put the directories in the proper order.

file=dir('**nm**');
Frequency=[];
Amplitude=[];
mkdir 'Output'


for(i=1:length(file))
    P=pwd;
    R=[P '/' file(i).name];
    fprintf(file(i).name)
    n=file(i).name;
    n=[n '.nm'];
    cd(R);
    [f a]=MicrophonicBatch(Range,Interval,Freq,Srate,display);

    Positions=zeros(size(a,1)+2,5);
    Positions(1:3,1:2)=fishposition;
    Positions(1,3:5)=a(1,:);
    size(Positions(4:3+size(coordinates,1),1:2))
    size(coordinates)
    Positions(5:4+size(coordinates,1),1:2)=coordinates;
    Positions(4:size(Positions,1),3:5)=a(2:size(a,1),:);
    

    dlmwrite(n,Positions,'\t')
    %ReceptiveFieldOutputv2(Positions,rho,theta,cmap);
    cd ..
    cd('Output')
    dlmwrite(n,Positions,'\t')
    cd ..
    Frequency=[Frequency;[0 0 0];f(1,:);[0 0 0];[0 0 0];f(2:length(f),:)];
    Amplitude=[Amplitude;[0 0 0];a(1,:);[0 0 0];[0 0 0];a(2:length(a),:)];
end
dlmwrite('Amplutide',Amplitude,'\t')
return