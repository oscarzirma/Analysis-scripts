function f=bandpassFilter(s,lowfreq,highfreq,Fs)
%takes in a vector and outputs that vector after low pass filtering line
%noise. 

h=fdesign.bandpass('Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2',.8333*lowfreq,lowfreq,highfreq,1.2*highfreq,60,1,60,Fs);
d=design(h,'equiripple'); %Lowpass FIR filter
f=filtfilt(d.Numerator,1,s);

end