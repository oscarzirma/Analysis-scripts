function f=batchlowpassFilter(s,freq,Fs)
%takes in a matrix and outputs that matrix after band pass filtering each row. 


h=fdesign.lowpass('Fp,Fst,Ap,Ast',.8*freq,freq,1,60,Fs);
d=design(h,'equiripple'); %Lowpass FIR filter

for i=1:size(s,1)
f(i,:)=filtfilt(d.Numerator,1,s(i,:));
end

end