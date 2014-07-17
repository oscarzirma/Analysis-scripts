function [Frequency,Amplitude]=MicrophonicBatchDIR(Range,Interval,Freq,Srate,display)
%Runs MicrophonicBatch on all directories starting XX-nm where XX are
%digits to put the directories in the proper order.

file=dir('**nm**');
Frequency=[];
Amplitude=[];


for(i=1:length(file))
    P=pwd;
    R=[P '/' file(i).name];
    fprintf(file(i).name)
    cd(R);
    [f a]=MicrophonicBatch(Range,Interval,Freq,Srate,display)
    dlmwrite('amp',a,'\t')
    cd ..
    Frequency=[Frequency;[0 0 0];f(1,:);[0 0 0];[0 0 0];f(2:length(f),:)];
    Amplitude=[Amplitude;[0 0 0];a(1,:);[0 0 0];[0 0 0];a(2:length(a),:)];
end
dlmwrite('Amplutide',Amplitude,'\t')
return