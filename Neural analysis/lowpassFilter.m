function f=lowpassFilter(s,freq,Fs)
%takes in a vector and outputs that vector after low pass filtering line
%noise. 

h=fdesign.lowpass('Fp,Fst,Ap,Ast',.8*freq,freq,1,60,Fs);h
d=design(h,'equiripple'); %Lowpass FIR filter
d
f=filtfilt(d.Numerator,1,s);

end