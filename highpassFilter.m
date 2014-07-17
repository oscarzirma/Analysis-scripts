function f=highpassFilter(s,freq,Fs)
%takes in a vector and outputs that vector after low pass filtering line
%noise. 

h=fdesign.highpass('Fst,Fp,Ast,Ap',freq,1.2*freq,1,80,Fs);
d=design(h,'equiripple'); %Lowpass FIR filter
f=filtfilt(d.Numerator,1,s);

end