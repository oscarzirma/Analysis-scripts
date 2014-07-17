function R=multiMicroFourDelayV2(Data,NumCycles,TaperCycles,preDelay,postDelay,freq,amp,SRate)
%takes in Data file (two column, stimulus in the first column and response
%in the second), NumCycles (the number of cycles for each frequency),
%TaperCycles (number cycles tapering up to the amplitude), Delay (delay
%preceding the stimulus, in ms), freq (an array of the frequencies tested), 
%amp (an array of the amplitudes tested), and Srate
%(the sampling rate) and outputs the input frequency and ampitude and output frequency and amplitude.
%If display is 'on' it will display each iteration.

s=0;%start index for the specific interval
f=0;%end index for the specific interval
x=1;
Numfreq=length(freq);
Numamp=length(amp);
%fprintf('input freq    input amp     output freq mean   output freq stdev   output amp mean     output amp stdev');
for(j=1:(Numamp))
    for(k=1:Numfreq)
        s=round(f+(preDelay*(SRate/1000))+((1/freq(k))*TaperCycles*SRate));
        f=round(f+((preDelay+postDelay)*(SRate/1000))+((1/freq(k))*NumCycles*SRate));
        fe=round(f-((1/freq(k))*TaperCycles*SRate)-(postDelay*SRate/1000));
        [Fi,Ai,Fo,Ao]=FourierMicrophonic(Data,[s fe],SRate);
        O=[Fi Ai Fo Ao];
        R(x,:)=O;
        x=x+1;
    end
end
dlmwrite('data.dat',' ','-append')
dlmwrite('data.dat',' ','-append')
dlmwrite('data.dat',' ','-append')
dlmwrite('data.dat',R,'-append','delimiter','\t','precision',6)

[m,n]=size(R);
S=zeros(m,n);%build a matrix of values sorted by frequency
i=1;
for(j=1:length(freq))
    for(k=1:length(amp))
        S(i,:)=R((k-1)*length(freq)+j,:);
        i=i+1;
    end
end

dlmwrite('dataF.dat',' ','-append')
dlmwrite('dataF.dat',' ','-append')
dlmwrite('dataF.dat',' ','-append')
dlmwrite('dataF.dat',S,'-append','delimiter','\t','precision',6)
        
return