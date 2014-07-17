function R=multiMicroFour(Data,NumCycles,TaperCycles,Delay,freq,amp,SRate)
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
        s=round(f+(Delay*(SRate/1000))+((1/freq(k))*TaperCycles*SRate));
        f=round(f+(Delay*(SRate/1000))+((1/freq(k))*NumCycles*SRate));
        fe=round(f-((1/freq(k))*TaperCycles*SRate));
        [Fi,Ai,Fo,Ao]=FourierMicrophonic(Data,[s fe],SRate);
        O=[Fi Ai Fo Ao];
        R(x,:)=O;
        x=x+1;
    end
end
%dlmwrite('data.dat',R,'-append','delimiter','\t','precision',6)
return