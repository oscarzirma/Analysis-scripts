function f=lineFilter(s,Fs)
%takes in a vector and outputs that vector after bandstop filtering line
%noise. 

h=fdesign.bandstop('Fp1,Fst1,Fst2,Fp2,Ap1,Ast,Ap2' ,54,59,61,66,1,60,1,Fs);
d=design(h,'equiripple'); %Lowpass FIR filter
f=filtfilt(d.Numerator,1,s);

end