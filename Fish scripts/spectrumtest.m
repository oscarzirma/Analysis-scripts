function [power freq period]=spectrumtest(Data,Fs)
%takes in data and sampling rate and plots spectrum

time=linspace(0,length(Data)/Fs,length(Data));


Y=fft(Data);
N=length(Y);
Y(1)=[];
power=abs(Y(1:N/2)).^2;
nyquist=1/2;
freq=(1:N/2)/(N/2)*nyquist;
plot(freq,power),grid on
pause()
period=1./freq;
plot(period,power)