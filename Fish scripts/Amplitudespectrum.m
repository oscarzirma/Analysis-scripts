function [freq ampspec]=Amplitudespectrum(Data,Fs)
%takes in data and sampling rate and plots spectrum

dt=1/Fs;
L=length(Data);
z=fft(Data);
n=L/2;
ampspec=abs(z)/n;
freq=(0:round(L/20))/(2*n*dt);
plot(freq(1:round(L/20)),ampspec(1:round(L/20)))
ampspec=ampspec(1:round(L/20));