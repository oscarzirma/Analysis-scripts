function [Fi,Ai,Fo,Ao]=FourierMicrophonic(Data,I,Srate)
%takes in a two column data vector with stimulus in column1 and response in
%column2 and finds the frequency with the maximum power over the interval
%I, returning the frequency (Fi,Fo) and power (Ai,Ao). Srate is the
%sampling rate.

Y=fft(Data(I(1):I(2),1));%compute input frequency
N=length(Y);
S=round(N/2);
Y(1)=[];
power=abs(Y(1:S)).^2;
nyquist=1/2;
freq=(1:S)/(S)*nyquist;
[y,x]=max(power);
Fi=freq(x)*Srate;


Ai=[];

Y=fft(Data(I(1):I(2),2));%compute output frequency
Y(1)=[];
power=abs(Y(1:S)).^2;
[y,x]=max(power);
Fo=freq(x)*Srate;

Ao=[];