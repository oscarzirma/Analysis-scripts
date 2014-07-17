function [Frequency,Amplitude]=MicrophonicBatch(Run,Range,Interval,Freq,Srate,display)
%crop the files to a relevant range (entered as a parameter) runs a running
%mean filter (interval=50) and scan that range for the Interval (in data points, scans by Interval/10) of maximum 
%amplitude spectrum at the stimulation frequency (for columns 1 and
%3) or twice the stimulation frequency (for column 2, response). will desplay
%the interval with a pause optionally.
%Outputs the frequency and amplitude of that interval.

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
        j=j+(Interval/10);
        k=j+Interval;
    end
    Amplitude(c)=amp;
    if(display==1)
        plot(R(index:index+Interval,c))
        pause()
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







