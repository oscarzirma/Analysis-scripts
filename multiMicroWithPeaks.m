function [Peaki,Peako]=multiMicroWithPeaks(Data,NumCycles,TaperCycles,Delay,freq,amp,SRate)
%takes in Data file (two column, stimulus in the first column and response
%in the second), NumCycles (the number of cycles for each frequency),
%TaperCycles (number cycles tapering up to the amplitude), Delay (delay
%preceding the stimulus, in ms), freq (an array of the frequencies tested), 
%amp (an array of the amplitudes tested), and Srate
%(the sampling rate) and outputs the input frequency mean, range, and stdev
%(MRS), input ampitude MRS, output frequency MRS, and output amplitude MRS.
%If display is 'on' it will display each iteration.

s=0;%start index for the specific interval
f=0;%end index for the specific interval
x=1;
Peaki=[];
Peako=[];
Numfreq=length(freq);
Numamp=length(amp);
fprintf('input freq    input amp     output freq mean   output freq stdev   output amp mean     output amp stdev');
for(j=1:(Numamp))
    for(k=1:Numfreq)
        s=round(f+(Delay*(SRate/1000))+((1/freq(k))*TaperCycles*SRate));
        f=round(f+(Delay*(SRate/1000))+((1/freq(k))*NumCycles*SRate));
        fe=round(f-((1/freq(k))*TaperCycles*SRate));
        if(freq(k)<=50) frq=65; else frq=freq(k); end
        [Fi,Ai,Fo,Ao,Pi,Po,I]=FMicrophonic(Data,[s fe],SRate,frq);
        O=[Fi(1) Ai(1) Fo(1) Fo(3) Ao(1) Ao(3)];
        R(x,:)=O;
        x=x+1;
        A=Pi(:,1);
        [a,b]=size(A);
        Index=ones(a,1)*s;
        size(A)
        size(Index)
        Pi(:,1)=A+Index;
        A=Po(:,1);
        [a,b]=size(A);
        Index=ones(a,1)*s;
        Po(:,1)=A+Index;
        Peaki=[Peaki
            Pi];
        Peako=[Peako
            Po];
    end
end
dlmwrite('data.dat',R,'delimiter','\t','precision',5)
return