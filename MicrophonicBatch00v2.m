function [Frequency,Amplitude]=MicrophonicBatch00v2(Range,Interval,Freq,Srate,fishposition,coordinates,display)
%[Frequency,Amplitude]=MicrophonicBatch00(Range,Interval,Freq,Srate,display
%)
%Imports all the text Run files in current directory in sequential order.
%crop the files to a relevant range (entered as a parameter) runs a running
%mean filter (interval=50) and scan that range for the Interval (in data points, scans by Interval/10) of maximum 
%amplitude spectrum at the stimulation frequency (for columns 1 and
%3) or twice the stimulation frequency (for column 2, response). will desplay
%the interval with a pause optionally.
%Outputs the frequency and amplitude of that interval.
%The first line of the output matrix is a background value. It is the mean
%frequency and amplitude of the first 1 to Interval points across all runs.

file=dir('***-Run **.txt');
for(i=1:length(file))
    file(i).name
    Run=load(file(i).name);
    [freq,amp]=Analysis(Run,Range,Interval,Freq,Srate,display);
    [f(i,:),a(i,:)]=Analysis(Run,[1 round(1.1*Interval)],Interval,Freq,Srate,0);
    Frequency(i+1,:)=freq;
    Amplitude(i+1,:)=amp;
end
Frequency(1,:)=mean(f);
Amplitude(1,:)=mean(a);
   

    Positions=zeros(size(a,1)+2,5);
    size(Positions(1:3,1:2))
    size(fishposition)
    Positions(1:3,1:2)=fishposition;
    Positions(1,3:5)=Amplitude(1,:);
    size(Positions(4:size(Positions,1),3:5))
    size(Amplitude(2:size(a,1),:))
    Positions(5:4+size(coordinates,1),1:2)=coordinates;
    tmp=Amplitude(2:size(a,1),:);
    size(Positions)
    s=pwd;
    for(i=length(s):-1:1)
    if(s(i)=='/')
    break
    end
    end
    flnm=['n' s(i+1:length(s)) '.nm'];
    Positions(4:size(Positions,1),3:5)=tmp;
    dlmwrite(flnm,Positions,'\t')
    cd ..
    cd 'Output'
    dlmwrite(flnm,Positions,'\t')

return


function [Frequency, Amplitude]=Analysis(Run,Range,Interval,Freq,Srate,display)
R=Run(Range(1):Range(2),:);
R=RMFa(R,50);

[m,n]=size(R);



for(c=1:n)
    j=1;k=j+Interval;
    int=R(j:k,c);
    [Frequency(c),IFreqT]=freqtarget(int,Srate,Freq(c));
    amp=0;index=0; %initialize tracking variables
    while(k<m)
        int=R(j:k,c);
        a=Amplitudemax(int,IFreqT);
        if a>amp
            amp=a;
            index=j;
        end
        j=j+round(Interval/10);
        k=j+Interval;
    end
    Amplitude(c)=amp;
    if(display==1)
        plot(R(index:index+Interval,c))
        pause(1)
    end
end

return        
      
        
function [f,I]=freqtarget(Data,Fs,FreqT)
%finds the index of the target frequency
dt=1/Fs;
L=length(Data);
n=L/2;
freq=(0:round(L/20-1))/(2*n*dt);
x=1000;
I=0;
for(i=1:length(freq))
    if(abs(freq(i)-FreqT)<x)
        f=freq(i);
        I=i;
        x=abs(freq(i)-FreqT);
    end
end
return
        
function [a]=Amplitudemax(Data,IFreqT)
%finds the value of the amplitude spectrum at the target frequency
L=length(Data);
z=fft(Data);
n=L/2;
ampspec=abs(z)/n;
a=ampspec(IFreqT);
return







