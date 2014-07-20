function [Baseline StimFreq StimAmp ResFreq AbsAmp RelAmp] = MicroBatchAnalysis(Range,prefix,suffix)
%Will import microphonic 2 column data files over a range of numbers with a
%given prefix and suffix (e.g. for Run 01 - Run 05, range = [1 5] prefix =
%'Run ' suffix = '.txt'. Assumes that there are three files for each
%neuromast, a 100hz 10cycle baseline, a multi-freq, multi-amp test,
%followed by another 100hz 10cycle baseline. The test parameters must be
%manually entered in the initiation values within the program. Neuromasts
%in rows, frequencies along columns.

%The program will output 
%1)Baseline amplitude response between neuromasts at 100hz (absolute 
%in column 1, relative in column 2), 2) Stimulus frequencies, 3) Stimulus amplitudes,
%4-5)Frequency response between neuromasts (in the form of a 3-dim matrix: 
%rows represent neuromasts, columns represent frequencies, and z-columns represent 
%amplitudes) with the first matrix being absolute values and the second matrix being relative values.

%intiialization values
numcycles = 60;
taper = 5;
delay = 80;
freq = [300 25 250 50 200 75 175 100 150 125];
amp = [2];
samplerate = 20000;

index=1;

%data import
[S R]=dataIn(Range,prefix,suffix)

%Build 3 matrices, one for base, test, and post.
while(index<Range(2))
    for(i=1:Range(2)/3)
        data1=[cell2mat(S(index)),cell2mat(R(index))];
        %size(data1)
        Base(i,:) = multiMicroFour(data1,10,2,100,[100],[2],20000);
        index=index+1;
        data2=[cell2mat(S(index)),cell2mat(R(index))];
        %size(data2)
        Test = multiMicroFour(data2,numcycles,taper,delay,freq,amp,samplerate);
        StimFreq(i,:)=Test(:,1)';
        StimAmp(i,:)=Test(:,2)';
        ResFreq(i,:)=Test(:,3)';
        AbsAmp(i,:)=Test(:,4)';
        index=index+1;
        data3=[cell2mat(S(index)),cell2mat(R(index))];
        %size(data3)
        Post(i,:) = multiMicroFour(data3,10,2,100,[100],[2],20000);
        index=index+1
    end
end
%Analyze the data
%1) Baseline

[m n] = size(Base);
BaseAmp = Base(:,4);
PostAmp = Post(:,4);
BaseMax=max(BaseAmp);
PostMax=max(PostAmp);
Baseline(:,1)=BaseAmp;
Baseline(:,3)=PostAmp;
for(i=1:m)
    Baseline(i,2)=BaseAmp(i)/BaseMax;
    Baseline(i,4)=PostAmp(i)/PostMax;
end

%Output Frequency Response Matrices

for(i=1:m)
    dat = AbsAmp(i,:);
    Max = max(dat);
    for(j=1:length(dat))
        rel(j)=dat(j)/Max;
    end
    RelAmp(i,:) = rel;
end

dlmwrite('data.dat',' ','-append')
dlmwrite('data.dat','Abs Base,Rel Base,Abs Post,Rel Post','-append','delimiter','')
dlmwrite('data.dat',Baseline,'-append','precision',6)
dlmwrite('data.dat',' ','-append')
dlmwrite('data.dat','Stimulus Frequency','-append','delimiter','')
dlmwrite('data.dat',StimFreq,'-append','precision',6)
dlmwrite('data.dat',' ','-append')
dlmwrite('data.dat','Stimulus Amplitude','-append','delimiter','')
dlmwrite('data.dat',round(StimFreq(1,:)),'-append')
dlmwrite('data.dat',StimAmp,'-append','precision',6)
dlmwrite('data.dat',' ','-append')
dlmwrite('data.dat','Response Frequency','-append','delimiter','')
dlmwrite('data.dat',round(StimFreq(1,:)),'-append')
dlmwrite('data.dat',ResFreq,'-append','precision',6)
dlmwrite('data.dat',' ','-append')
dlmwrite('data.dat','Response Amplitude','-append','delimiter','')
dlmwrite('data.dat',round(StimFreq(1,:)),'-append')
dlmwrite('data.dat',AbsAmp,'-append','precision',6)
dlmwrite('data.dat',' ','-append')
dlmwrite('data.dat','Relative Response Amplitude','-append','delimiter','')
dlmwrite('data.dat',round(StimFreq(1,:)),'-append')
dlmwrite('data.dat',RelAmp,'-append','precision',6)
dlmwrite('data.dat',' ','-append')
        
        
        
        
        