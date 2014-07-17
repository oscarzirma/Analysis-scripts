function [Fi,Ai,Fo,Ao]=FourierMicrophonic(Data,I,Srate)
%takes in a two column data vector with stimulus in column1 and response in
%column2 and finds the frequency with the maximum amplitude over the interval
%I, returning the frequency (Fi,Fo) and power (Ai,Ao). Srate is the
%sampling rate.

%size(Data)
%I
In=Data(I(1):I(2),1);
Out=Data(I(1):I(2),2);
dt=1/Srate;
L=I(2)-I(1);
n=L/2;
freq=(0:L-1)/(2*n*dt);

z=fft(In);%compute amplitude and frequency of input stimulus
ampspec=abs(z)/n;
ampspec(1)=[0];
[Ai x]=max(ampspec);
Fi=freq(x);
%plot(freq,ampspec(1:L))

z=fft(Out);%compute amplitude and frequency of input stimulus
ampspec=abs(z)/n;
ampspec(1)=[0];
[Ao x]=max(ampspec);
Fo=freq(x);
%plot(freq,ampspec(1:L))